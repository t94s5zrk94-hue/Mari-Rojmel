// ===============================================================
// Mari-Rojmel
// User Profile Repository
//
// SQLite Repository for User Profile
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_constants.dart';
import '../../../core/database/database_helper.dart';
import '../models/user_profile_model.dart';

/// ===============================================================
/// Exception
/// ===============================================================

class UserProfileNotFoundException implements Exception {
  const UserProfileNotFoundException([
    this.message = 'User profile not found.',
  ]);

  final String message;

  @override
  String toString() => message;
}

/// ===============================================================
/// Repository Contract
/// ===============================================================

abstract class IUserProfileRepository {
  Future<UserProfileModel?> getProfile();

  Future<bool> hasProfile();

  Future<bool> saveProfile(UserProfileModel profile);

  Future<bool> updateProfile(UserProfileModel profile);

  Future<bool> deleteProfile();
}

/// ===============================================================
/// SQLite Repository
/// ===============================================================

class UserProfileRepository implements IUserProfileRepository {
  UserProfileRepository(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  static const String _tableName = DatabaseConstants.userProfileTable;

  static const String _colId = DatabaseConstants.columnUserId;

  static const int _profileId = 1;

  @override
  Future<UserProfileModel?> getProfile() async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      _tableName,
      where: '$_colId = ?',
      whereArgs: const [_profileId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UserProfileModel.fromMap(result.first);
  }

  @override
  Future<bool> hasProfile() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*)
      FROM $_tableName
      WHERE $_colId = ?
      ''',
      [_profileId],
    );

    return (Sqflite.firstIntValue(result) ?? 0) > 0;
  }

  @override
  Future<bool> saveProfile(UserProfileModel profile) async {
    final db = await _databaseHelper.database;

    final now = DateTime.now();

    final data = profile
        .copyWith(
          id: _profileId,
          createdAt: profile.createdAt ?? now,
          updatedAt: now,
        )
        .toMap();

    data[_colId] = _profileId;

    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id > 0;
  }

  @override
  Future<bool> updateProfile(UserProfileModel profile) async {
    final db = await _databaseHelper.database;

    final existing = await getProfile();

    if (existing == null) {
      throw const UserProfileNotFoundException();
    }

    final data = profile
        .copyWith(
          id: _profileId,
          createdAt: existing.createdAt,
          updatedAt: DateTime.now(),
        )
        .toMap();

    data[_colId] = _profileId;

    final count = await db.update(
      _tableName,
      data,
      where: '$_colId = ?',
      whereArgs: const [_profileId],
    );

    return count > 0;
  }

  @override
  Future<bool> deleteProfile() async {
    final db = await _databaseHelper.database;

    final count = await db.delete(
      _tableName,
      where: '$_colId = ?',
      whereArgs: const [_profileId],
    );

    return count > 0;
  }

  Future<bool> restoreProfile(Map<String, dynamic> profile) async {
    return saveProfile(UserProfileModel.fromMap(profile));
  }
}
