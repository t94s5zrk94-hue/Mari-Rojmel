// ===============================================================
// Mari-Rojmel
// Account Repository
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

/// Thrown when user profile is not found.
class UserProfileNotFoundException implements Exception {
  final String message;

  const UserProfileNotFoundException([
    this.message = 'User profile not found.',
  ]);

  @override
  String toString() => message;
}

/// ===============================================================
/// Repository Contract
/// ===============================================================

abstract class IAccountRepository {
  Future<UserProfileModel?> getProfile();

  Future<bool> hasProfile();

  Future<bool> saveProfile(UserProfileModel profile);

  Future<bool> updateProfile(UserProfileModel profile);
}

/// ===============================================================
/// SQLite Repository Implementation
/// ===============================================================

class AccountRepository implements IAccountRepository {
  AccountRepository(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  static const String _tableName = DatabaseConstants.userProfileTable;
  static const String _colId = DatabaseConstants.columnUserId;
  static const int _profileId = 1;
  // ===============================================================
  // Get User Profile
  // ===============================================================

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

  // ===============================================================
  // Check Profile Exists
  // ===============================================================

  @override
  Future<bool> hasProfile() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*)
      FROM $_tableName
      WHERE $_colId = ?
      ''',
      [1],
    );

    return (Sqflite.firstIntValue(result) ?? 0) > 0;
  }
  // ===============================================================
  // Save User Profile
  // ===============================================================

  @override
  Future<bool> saveProfile(UserProfileModel profile) async {
    final db = await _databaseHelper.database;

    final data = profile
        .copyWith(
          id: _profileId,
          createdAt: profile.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        )
        .toMap();

    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id > 0;
  }

  // ===============================================================
  // Update User Profile
  // ===============================================================

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

    final count = await db.update(
      _tableName,
      data,
      where: '$_colId = ?',
      whereArgs: const [_profileId],
    );

    return count > 0;
  }
}
