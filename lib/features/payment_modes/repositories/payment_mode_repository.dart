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
    this.message =
        'Default payment modes cannot be modified or deleted.',
  ]);

  @override
  String toString() => message;
}

/// Interface defining the contract for Payment Mode data operations.
abstract class IPaymentModeRepository {
  Future<void> createTable();
  Future<void> seedDefaults();
  Future<List<PaymentModeModel>> getActive();
  Future<List<PaymentModeModel>> search(String keyword);
  Future<PaymentModeModel?> getById(String id);
  Future<bool> existsByName(String name, {String? excludeId});
  Future<bool> insert(PaymentModeModel model);
  Future<bool> update(PaymentModeModel model);
  Future<bool> softDelete(String id);
  Future<bool> restore(String id);
  Future<int> count();
}

/// Implementation of [IPaymentModeRepository] using SQLite.
class PaymentModeRepository implements IPaymentModeRepository {
  final DatabaseHelper _dbHelper;
  static const String _tableName = 'payment_modes';
  
  static const String colId = 'payment_mode_id';
  static const String colName = 'payment_mode_name';
  static const String colIcon = 'icon';
  static const String colIsDefault = 'is_default';
  static const String colIsActive = 'is_active';
  static const String colSortOrder = 'sort_order';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';
  static const String colDeletedAt = 'deleted_at';

  PaymentModeRepository(this._dbHelper);

  @override
  Future<void> createTable() async {
    final db = await _dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        $colId TEXT PRIMARY KEY,
        $colName TEXT NOT NULL UNIQUE COLLATE NOCASE,
        $colIcon TEXT NOT NULL,
        $colIsDefault INTEGER NOT NULL DEFAULT 0,
        $colIsActive INTEGER NOT NULL DEFAULT 1,
        $colSortOrder INTEGER NOT NULL,
        $colCreatedAt TEXT,
        $colUpdatedAt TEXT,
        $colDeletedAt TEXT
      )
    ''');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_payment_mode_name ON $_tableName($colName)');
  }

  @override
  Future<void> seedDefaults() async {
    final db = await _dbHelper.database;
    

    final currentCount = Sqflite.firstIntValue(
    await db.rawQuery(
    'SELECT COUNT(*) FROM $_tableName',
    ),
    ) ?? 0;

  if (currentCount > 0) return;

    final defaults = [
      {'id': 'PM001', 'name': 'Cash', 'icon': '💵', 'sort': 1},
      {'id': 'PM002', 'name': 'UPI', 'icon': '📱', 'sort': 2},
    ];

    await db.transaction((txn) async {
      for (final item in defaults) {
        await txn.insert(
          _tableName,
          {
            colId: item['id'],
            colName: item['name'],
            colIcon: item['icon'],
            colIsDefault: 1,
            colIsActive: 1,
            colSortOrder: item['sort'],
            colCreatedAt: DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    });
  }

  @override
  Future<List<PaymentModeModel>> getActive() async {
    final db = await _dbHelper.database;
    final results = await db.query(
      _tableName,
      where: '$colIsActive = ? AND $colDeletedAt IS NULL',
      whereArgs: [1],
      orderBy: '$colSortOrder ASC',
    );
    return results.map((e) => _mapToModel(e)).toList();
  }

  @override
  Future<List<PaymentModeModel>> search(String keyword) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      _tableName,
        where: '''
        $colIsActive = ?
        AND $colDeletedAt IS NULL
        AND TRIM($colName) LIKE ? COLLATE NOCASE
        ''',
        whereArgs: [
          1,
          '%${keyword.trim()}%',
        ],
      orderBy: '$colSortOrder ASC',
    );
    return results.map((e) => _mapToModel(e)).toList();
  }

  @override
  Future<PaymentModeModel?> getById(String id) async {
    final db = await _dbHelper.database;
    final results = await db.query(_tableName, where: '$colId = ?', whereArgs: [id]);
    if (results.isEmpty) return null;
    return _mapToModel(results.first);
  }

  @override
  Future<bool> existsByName(String name, {String? excludeId}) async {
    final db = await _dbHelper.database;
    String sql = 'SELECT 1 FROM $_tableName WHERE $colName = ? COLLATE NOCASE';
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
    final existing = await getById(model.id);
    if (existing == null) return false;
    
    if (existing.isDefault && existing.name != model.name) {
      throw DefaultPaymentModeException();
    }

    if (await existsByName(model.name, excludeId: model.id)) {
      throw DuplicatePaymentModeException();
    }

    final db = await _dbHelper.database;
    final data = _toMap(model);
    data[colUpdatedAt] = DateTime.now().toIso8601String();
    
    final count = await db.update(
      _tableName,
      data,
      where: '$colId = ?',
      whereArgs: [model.id],
    );
    return count > 0;
  }

  @override
  Future<bool> softDelete(String id) async {
    final existing = await getById(id);
    if (existing?.isDefault == true) throw DefaultPaymentModeException();

    final db = await _dbHelper.database;
    final count = await db.update(
      _tableName,
      {
        colIsActive: 0,
        colDeletedAt: DateTime.now().toIso8601String(),
      },
      where: '$colId = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  @override
  Future<bool> restore(String id) async {
    final db = await _dbHelper.database;
    final count = await db.update(
      _tableName,
      {
        colIsActive: 1,
        colDeletedAt: null,
        colUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '$colId = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  @override
  Future<int> count() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $_tableName WHERE $colIsActive = 1 AND $colDeletedAt IS NULL');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Map<String, dynamic> _toMap(PaymentModeModel model) => {
    colId: model.id,
    colName: model.name.trim(),
    colIcon: model.icon,
    colIsDefault: model.isDefault ? 1 : 0,
    colIsActive: model.isActive ? 1 : 0,
    colSortOrder: model.sortOrder,
  };

  PaymentModeModel _mapToModel(Map<String, dynamic> map) => PaymentModeModel(
    id: map[colId] as String,
    name: map[colName] as String,
    icon: map[colIcon] as String,
    isDefault: (map[colIsDefault] as int) == 1,
    isActive: (map[colIsActive] as int) == 1,
    sortOrder: map[colSortOrder] as int,
  );
}