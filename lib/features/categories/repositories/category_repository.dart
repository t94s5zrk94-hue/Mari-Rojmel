// ==========================================================
// NOTE
//
// Database schema creation and default seeding are handled by:
//
// - DatabaseHelper
// - DatabaseInitializer
//
// This repository is CRUD only.
// ==========================================================
import 'package:sqflite/sqflite.dart';
import '../../../core/enums/transaction_type.dart';
import '../../../core/database/database_helper.dart';
import '../models/category_model.dart';
import 'package:flutter/foundation.dart';

/// Thrown when a category with the same name and transaction type
/// already exists.
class DuplicateCategoryException implements Exception {
  final String message;

  const DuplicateCategoryException([
    this.message = 'A category with the same name already exists.',
  ]);

  @override
  String toString() => message;
}

/// Thrown when an operation is attempted on a protected
/// default category.
class DefaultCategoryException implements Exception {
  final String message;

  const DefaultCategoryException([
    this.message = 'Default categories cannot be modified or deleted.',
  ]);

  @override
  String toString() => message;
}

/// Repository Contract
abstract class ICategoryRepository {
  Future<List<CategoryModel>> getActive({TransactionType? transactionType});

  Future<List<CategoryModel>> search(
    String keyword, {
    TransactionType? transactionType,
  });

  Future<CategoryModel?> getDefaultCategory(TransactionType transactionType);

  Future<CategoryModel?> getById(int id);

  Future<bool> existsByName(
    String name, {
    required TransactionType transactionType,
    int? excludeId,
  });

  Future<bool> insert(CategoryModel model);

  Future<bool> update(CategoryModel model);

  Future<bool> softDelete(int id);

  Future<bool> restore(int id);

  Future<int> count({TransactionType? transactionType});
}

/// SQLite Repository Implementation
class CategoryRepository implements ICategoryRepository {
  CategoryRepository(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  static const String tableName = 'categories';

  static const String colId = 'id';
  static const String colName = 'name';
  static const String colIcon = 'icon';
  static const String colColor = 'color';
  static const String colTransactionType = 'transaction_type';
  static const String colIsDefault = 'is_default';
  static const String colIsActive = 'is_active';
  static const String colSortOrder = 'sort_order';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  @override
  Future<CategoryModel?> getDefaultCategory(
    TransactionType transactionType,
  ) async {
    final db = await _databaseHelper.database;

    // Debug: Raw database records
    final allRows = await db.rawQuery('''
    SELECT
      id,
      name,
      transaction_type,
      is_default,
      is_active
    FROM $tableName
    ORDER BY id
  ''');

    debugPrint('==============================');
    debugPrint('RAW CATEGORY TABLE');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
    debugPrint('==============================');

    final result = await db.query(
      tableName,
      where:
          '''
      $colIsDefault = 1
      AND $colIsActive = 1
      AND $colTransactionType = ?
    ''',
      whereArgs: [transactionType.value],
      limit: 1,
    );

    debugPrint('DEFAULT CATEGORY QUERY RESULT: $result');

    if (result.isEmpty) {
      debugPrint('DEFAULT CATEGORY = NULL');
      return null;
    }

    final model = _mapToModel(result.first);

    debugPrint(
      'DEFAULT CATEGORY => '
      'id=${model.id}, '
      'name=${model.name}, '
      'default=${model.isDefault}, '
      'active=${model.isActive}',
    );

    return model;
  }

  @override
  Future<List<CategoryModel>> getActive({
    TransactionType? transactionType,
  }) async {
    final db = await _databaseHelper.database;

    String where = '$colIsActive = 1';
    final whereArgs = <dynamic>[];

    if (transactionType != null) {
      where += ' AND $colTransactionType = ?';
      whereArgs.add(transactionType.value);
    }

    final result = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: '$colTransactionType ASC, $colSortOrder ASC',
    );

    return result.map(_mapToModel).toList();
  }

  @override
  Future<List<CategoryModel>> search(
    String keyword, {
    TransactionType? transactionType,
  }) async {
    final db = await _databaseHelper.database;

    final buffer = StringBuffer()
      ..write('$colIsActive = 1 ')
      ..write('AND TRIM($colName) LIKE ? COLLATE NOCASE');

    final args = <dynamic>['%${keyword.trim()}%'];

    if (transactionType != null) {
      buffer.write(' AND $colTransactionType = ?');
      args.add(transactionType.value);
    }

    final result = await db.query(
      tableName,
      where: buffer.toString(),
      whereArgs: args,
      orderBy: '$colTransactionType ASC, $colSortOrder ASC',
    );

    return result.map(_mapToModel).toList();
  }

  @override
  Future<CategoryModel?> getById(int id) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return _mapToModel(result.first);
  }

  @override
  Future<bool> existsByName(
    String name, {
    required TransactionType transactionType,
    int? excludeId,
  }) async {
    final db = await _databaseHelper.database;

    final sql = StringBuffer()
      ..write('SELECT 1 FROM $tableName ')
      ..write('WHERE TRIM($colName)=? COLLATE NOCASE ')
      ..write('AND $colTransactionType=? ')
      ..write('AND $colIsActive=1 ');

    final args = <dynamic>[name.trim(), transactionType.value];

    if (excludeId != null) {
      sql.write(' AND $colId != ?');
      args.add(excludeId);
    }

    final result = await db.rawQuery(sql.toString(), args);

    return result.isNotEmpty;
  }

  @override
  Future<bool> insert(CategoryModel model) async {
    if (await existsByName(
      model.name,
      transactionType: model.transactionType,
    )) {
      throw const DuplicateCategoryException();
    }

    final db = await _databaseHelper.database;

    final data = _toMap(model)
      ..[colCreatedAt] = DateTime.now().toIso8601String();

    final id = await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return id > 0;
  }

  @override
  Future<bool> update(CategoryModel model) async {
    if (model.id == null) {
      return false;
    }

    final existing = await getById(model.id!);

    if (existing == null) {
      return false;
    }

    if (existing.isDefault) {
      if (existing.name != model.name ||
          existing.transactionType != model.transactionType) {
        throw const DefaultCategoryException();
      }
    }

    if (await existsByName(
      model.name,
      transactionType: model.transactionType,
      excludeId: model.id,
    )) {
      throw const DuplicateCategoryException();
    }

    final db = await _databaseHelper.database;

    final data = _toMap(model)
      ..[colUpdatedAt] = DateTime.now().toIso8601String();

    final count = await db.update(
      tableName,
      data,
      where: '$colId = ?',
      whereArgs: [model.id],
    );

    return count > 0;
  }

  @override
  Future<bool> softDelete(int id) async {
    final existing = await getById(id);

    if (existing == null) {
      return false;
    }

    if (existing.isDefault) {
      throw const DefaultCategoryException();
    }

    final db = await _databaseHelper.database;

    final count = await db.update(
      tableName,
      {colIsActive: 0, colUpdatedAt: DateTime.now().toIso8601String()},
      where: '$colId = ?',
      whereArgs: [id],
    );

    return count > 0;
  }

  @override
  Future<bool> restore(int id) async {
    final db = await _databaseHelper.database;

    final count = await db.update(
      tableName,
      {colIsActive: 1, colUpdatedAt: DateTime.now().toIso8601String()},
      where: '$colId = ?',
      whereArgs: [id],
    );

    return count > 0;
  }

  @override
  Future<int> count({TransactionType? transactionType}) async {
    final db = await _databaseHelper.database;

    String sql =
        '''
      SELECT COUNT(*)
      FROM $tableName
      WHERE $colIsActive = 1
    ''';

    final args = <dynamic>[];

    if (transactionType != null) {
      sql += ' AND $colTransactionType = ?';
      args.add(transactionType.value);
    }

    final result = await db.rawQuery(sql, args);

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> clearAll() async {
    final db = await _databaseHelper.database;

    await db.delete(tableName, where: '$colIsDefault = ?', whereArgs: [0]);
  }

  Future<void> restoreAll(List<Map<String, dynamic>> categories) async {
    final db = await _databaseHelper.database;

    final batch = db.batch();

    for (final category in categories) {
      batch.insert(
        tableName,
        category,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Map<String, dynamic> _toMap(CategoryModel model) {
    return {
      colId: model.id,
      colName: model.name.trim(),
      colIcon: model.icon,
      colColor: model.color,
      colTransactionType: model.transactionType.value,
      colIsDefault: model.isDefault ? 1 : 0,
      colIsActive: model.isActive ? 1 : 0,
      colSortOrder: model.sortOrder,
    };
  }

  CategoryModel _mapToModel(Map<String, dynamic> map) {
    return CategoryModel(
      id: map[colId] as int?,
      name: map[colName] as String,
      icon: map[colIcon] as String,
      color: map[colColor] as int,
      transactionType: TransactionType.fromString(
        map[colTransactionType] as String?,
      ),
      isDefault: (map[colIsDefault] as int) == 1,
      isActive: (map[colIsActive] as int) == 1,
      sortOrder: map[colSortOrder] as int,
    );
  }
}
