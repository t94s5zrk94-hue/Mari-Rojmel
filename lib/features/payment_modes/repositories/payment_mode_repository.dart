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
import '../../../core/database/database_helper.dart';
import '../models/payment_mode_model.dart';

/// Thrown when a payment mode with the same name already exists.
class DuplicatePaymentModeException implements Exception {
  final String message;

  const DuplicatePaymentModeException([
    this.message = 'A payment mode with this name already exists.',
  ]);

  @override
  String toString() => message;
}

/// Thrown when an operation is attempted on a protected default payment mode.
class DefaultPaymentModeException implements Exception {
  final String message;

  const DefaultPaymentModeException([
    this.message = 'Default payment modes cannot be modified or deleted.',
  ]);

  @override
  String toString() => message;
}

/// Interface defining the contract for Payment Mode data operations.
abstract class IPaymentModeRepository {
  Future<List<PaymentModeModel>> getActive();
  Future<List<PaymentModeModel>> search(String keyword);
  Future<PaymentModeModel?> getDefaultPayment();
  Future<PaymentModeModel?> getById(int id);
  Future<bool> existsByName(String name, {int? excludeId});
  Future<bool> insert(PaymentModeModel model);
  Future<bool> update(PaymentModeModel model);
  Future<bool> softDelete(int id);
  Future<bool> restore(int id);
  Future<int> count();
}

/// Implementation of [IPaymentModeRepository] using SQLite.
class PaymentModeRepository implements IPaymentModeRepository {
  final DatabaseHelper _dbHelper;
  static const String _tableName = 'payment_modes';

  static const String colId = 'id';
  static const String colName = 'name';
  static const String colIcon = 'icon';
  static const String colColor = 'color';
  static const String colIsDefault = 'is_default';
  static const String colIsActive = 'is_active';
  static const String colSortOrder = 'sort_order';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  PaymentModeRepository(this._dbHelper);

  @override
  Future<List<PaymentModeModel>> getActive() async {
    final db = await _dbHelper.database;

    final results = await db.query(
      _tableName,
      where: '$colIsActive = ?',
      whereArgs: [1],
      orderBy: '$colSortOrder ASC',
    );

    return results.map(_mapToModel).toList();
  }

  @override
  Future<List<PaymentModeModel>> search(String keyword) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      _tableName,
      where:
          '''
        $colIsActive = ?
        AND TRIM($colName) LIKE ? COLLATE NOCASE
        ''',
      whereArgs: [1, '%${keyword.trim()}%'],
      orderBy: '$colSortOrder ASC',
    );
    return results.map((e) => _mapToModel(e)).toList();
  }

  @override
  Future<PaymentModeModel?> getDefaultPayment() async {
    final db = await _dbHelper.database;

    final result = await db.query(
      _tableName,
      where:
          '''
      $colIsDefault = 1
      AND $colIsActive = 1
    ''',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    final model = _mapToModel(result.first);

    return model;
  }

  @override
  Future<PaymentModeModel?> getById(int id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      _tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return _mapToModel(results.first);
  }

  @override
  Future<bool> existsByName(String name, {int? excludeId}) async {
    final db = await _dbHelper.database;
    String sql =
        'SELECT 1 FROM $_tableName '
        'WHERE $colName = ? COLLATE NOCASE '
        'AND $colIsActive = 1';
    List<dynamic> args = [name.trim()];

    if (excludeId != null) {
      sql += ' AND $colId != ?';
      args.add(excludeId);
    }

    final result = await db.rawQuery(sql, args);
    return result.isNotEmpty;
  }

  @override
  Future<bool> insert(PaymentModeModel model) async {
    if (await existsByName(model.name)) {
      throw DuplicatePaymentModeException();
    }

    final db = await _dbHelper.database;
    final data = _toMap(model);
    data[colCreatedAt] = DateTime.now().toIso8601String();

    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return id > 0;
  }

  @override
  Future<bool> update(PaymentModeModel model) async {
    if (model.id == null) {
      return false;
    }

    final db = await _dbHelper.database;

    final existing = await getById(model.id!);

    if (existing == null) {
      return false;
    }

    if (existing.isDefault && existing.name != model.name) {
      throw DefaultPaymentModeException();
    }

    if (await existsByName(model.name, excludeId: model.id!)) {
      throw DuplicatePaymentModeException();
    }

    final data = _toMap(model);
    data[colUpdatedAt] = DateTime.now().toIso8601String();

    final count = await db.update(
      _tableName,
      data,
      where: '$colId = ?',
      whereArgs: [model.id!],
    );

    return count > 0;
  }

  @override
  Future<bool> softDelete(int id) async {
    final existing = await getById(id);
    if (existing?.isDefault == true) throw DefaultPaymentModeException();

    final db = await _dbHelper.database;
    final count = await db.update(
      _tableName,
      {colIsActive: 0, colUpdatedAt: DateTime.now().toIso8601String()},
      where: '$colId = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  @override
  Future<bool> restore(int id) async {
    final db = await _dbHelper.database;
    final count = await db.update(
      _tableName,
      {colIsActive: 1, colUpdatedAt: DateTime.now().toIso8601String()},
      where: '$colId = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  @override
  Future<int> count() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) FROM $_tableName WHERE $colIsActive = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> clearAll() async {
    final db = await _dbHelper.database;

    await db.delete(_tableName, where: '$colIsDefault = ?', whereArgs: [0]);
  }

  Future<void> restoreAll(List<Map<String, dynamic>> paymentModes) async {
    final db = await _dbHelper.database;

    final batch = db.batch();

    for (final paymentMode in paymentModes) {
      batch.insert(
        _tableName,
        paymentMode,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Map<String, dynamic> _toMap(PaymentModeModel model) => {
    colId: model.id,
    colName: model.name.trim(),
    colIcon: model.icon,
    colIsDefault: model.isDefault ? 1 : 0,
    colIsActive: model.isActive ? 1 : 0,
    colSortOrder: model.sortOrder,
    colColor: model.color,
  };

  PaymentModeModel _mapToModel(Map<String, dynamic> map) => PaymentModeModel(
    id: map[colId] as int?,
    name: map[colName] as String,
    icon: (map[colIcon] ?? '💳') as String,
    color: map[colColor] as int,
    isDefault: (map[colIsDefault] as int) == 1,
    isActive: (map[colIsActive] as int) == 1,
    sortOrder: map[colSortOrder] as int,
  );
}
