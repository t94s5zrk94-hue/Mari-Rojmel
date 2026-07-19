// ===============================================================
// Mari-Rojmel
// Settings Repository
//
// SQLite Repository for App Settings
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_constants.dart';
import '../../../core/database/database_helper.dart';
import '../models/app_settings_model.dart';

/// ===============================================================
/// Exception
/// ===============================================================

class AppSettingsNotFoundException implements Exception {
  final String message;

  const AppSettingsNotFoundException([
    this.message = 'Application settings not found.',
  ]);

  @override
  String toString() => message;
}

/// ===============================================================
/// Repository Contract
/// ===============================================================

abstract class ISettingsRepository {
  Future<AppSettingsModel> getSettings();

  Future<bool> hasSettings();

  Future<bool> saveSettings(AppSettingsModel settings);

  Future<bool> updateSettings(AppSettingsModel settings);
}

/// ===============================================================
/// SQLite Repository
/// ===============================================================

class SettingsRepository implements ISettingsRepository {
  SettingsRepository(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  static const String _tableName = DatabaseConstants.appSettingsTable;

  static const String _colId = DatabaseConstants.columnSettingsId;

  @override
  Future<AppSettingsModel> getSettings() async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      _tableName,
      where: '$_colId = ?',
      whereArgs: const [1],
      limit: 1,
    );

    if (result.isEmpty) {
      return AppSettingsModel(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    return AppSettingsModel.fromMap(result.first);
  }

  @override
  Future<bool> hasSettings() async {
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

  @override
  Future<bool> saveSettings(AppSettingsModel settings) async {
    final db = await _databaseHelper.database;

    final data = settings.copyWith(updatedAt: DateTime.now()).toMap();

    data[_colId] = 1;

    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id > 0;
  }

  @override
  Future<bool> updateSettings(AppSettingsModel settings) async {
    final db = await _databaseHelper.database;

    if (!await hasSettings()) {
      throw const AppSettingsNotFoundException();
    }

    final existing = await getSettings();

    final now = DateTime.now();

    final data = settings
        .copyWith(createdAt: existing.createdAt, updatedAt: now)
        .toMap();

    data[_colId] = 1;

    final count = await db.update(
      _tableName,
      data,
      where: '$_colId = ?',
      whereArgs: const [1],
    );

    return count > 0;
  }
}
