import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../models/category_model.dart';

/// Thrown when a category with the same name and transaction type
/// already exists.
class DuplicateCategoryException implements Exception {
  final String message;

  const DuplicateCategoryException([
    this.message =
        'A category with the same name already exists.',
  ]);

  @override
  String toString() => message;
}

/// Thrown when an operation is attempted on a protected
/// default category.
class DefaultCategoryException implements Exception {
  final String message;

  const DefaultCategoryException([
    this.message =
        'Default categories cannot be modified or deleted.',
  ]);

  @override
  String toString() => message;
}

/// Repository Contract
abstract class ICategoryRepository {
  Future<void> createTable();

  Future<void> seedDefaults();

  Future<List<CategoryModel>> getActive({
    TransactionType? transactionType,
  });

  Future<List<CategoryModel>> search(
    String keyword, {
    TransactionType? transactionType,
  });

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

  Future<int> count({
    TransactionType? transactionType,
  });
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
  static const String colDeletedAt = 'deleted_at';
  @override
  Future<void> createTable() async {
    final db = await _databaseHelper.database;

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colName TEXT NOT NULL,
        $colIcon TEXT NOT NULL,
        $colColor INTEGER NOT NULL,
        $colTransactionType TEXT NOT NULL,
        $colIsDefault INTEGER NOT NULL DEFAULT 0,
        $colIsActive INTEGER NOT NULL DEFAULT 1,
        $colSortOrder INTEGER NOT NULL DEFAULT 0,
        $colCreatedAt TEXT,
        $colUpdatedAt TEXT,
        $colDeletedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_category_name
      ON $tableName($colName)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_category_type
      ON $tableName($colTransactionType)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_category_active
      ON $tableName($colIsActive)
    ''');
  }

  @override
  Future<void> seedDefaults() async {
    final db = await _databaseHelper.database;

    final currentCount =
        Sqflite.firstIntValue(await db.rawQuery(
              'SELECT COUNT(*) FROM $tableName',
            )) ??
            0;

    if (currentCount > 0) {
      return;
    }

    final now = DateTime.now().toIso8601String();

    final defaults = <Map<String, dynamic>>[
      // =========================
      // Income Categories
      // =========================

      {
        colName: 'Salary',
        colIcon: '💰',
        colColor: 0xFF4CAF50,
        colTransactionType: TransactionType.income.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 1,
      },
      {
        colName: 'Business',
        colIcon: '🏢',
        colColor: 0xFF009688,
        colTransactionType: TransactionType.income.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 2,
      },
      {
        colName: 'Interest',
        colIcon: '🏦',
        colColor: 0xFF3F51B5,
        colTransactionType: TransactionType.income.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 3,
      },
      {
        colName: 'Gift',
        colIcon: '🎁',
        colColor: 0xFFE91E63,
        colTransactionType: TransactionType.income.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 4,
      },
      {
        colName: 'Refund',
        colIcon: '↩️',
        colColor: 0xFF9C27B0,
        colTransactionType: TransactionType.income.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 5,
      },
      {
        colName: 'Other Income',
        colIcon: '➕',
        colColor: 0xFF607D8B,
        colTransactionType: TransactionType.income.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 6,
      },

      // =========================
      // Expense Categories
      // =========================

      {
        colName: 'Food',
        colIcon: '🍽️',
        colColor: 0xFFFF9800,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 101,
      },
      {
        colName: 'Grocery',
        colIcon: '🛒',
        colColor: 0xFF8BC34A,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 102,
      },
      {
        colName: 'Petrol / Diesel / CNG / EV Charging',
        colIcon: '⛽',
        colColor: 0xFF795548,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 103,
      },
      {
        colName: 'Medicine',
        colIcon: '💊',
        colColor: 0xFFF44336,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 104,
      },
      {
        colName: 'Electricity',
        colIcon: '⚡',
        colColor: 0xFFFFC107,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 105,
      },
      {
        colName: 'Mobile Recharge',
        colIcon: '📱',
        colColor: 0xFF03A9F4,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 106,
      },
      {
        colName: 'Internet',
        colIcon: '🌐',
        colColor: 0xFF2196F3,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 107,
      },
      {
        colName: 'Rent',
        colIcon: '🏠',
        colColor: 0xFF9E9E9E,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 108,
      },
      {
        colName: 'Education',
        colIcon: '🎓',
        colColor: 0xFF673AB7,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 109,
      },
      {
        colName: 'Entertainment',
        colIcon: '🎬',
        colColor: 0xFFE91E63,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 110,
      },
      {
        colName: 'Shopping',
        colIcon: '🛍️',
        colColor: 0xFF00BCD4,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 111,
      },
      {
        colName: 'Travel',
        colIcon: '✈️',
        colColor: 0xFF4CAF50,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 112,
      },
      {
        colName: 'EMI',
        colIcon: '💳',
        colColor: 0xFF3F51B5,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 113,
      },
      {
        colName: 'Insurance',
        colIcon: '🛡️',
        colColor: 0xFF009688,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 114,
      },
      {
        colName: 'Donation',
        colIcon: '❤️',
        colColor: 0xFFC2185B,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 115,
      },
      {
        colName: 'Other Expense',
        colIcon: '➖',
        colColor: 0xFF607D8B,
        colTransactionType: TransactionType.expense.value,
        colIsDefault: 1,
        colIsActive: 1,
        colSortOrder: 116,
      },
    ];

    await db.transaction((txn) async {
      for (final item in defaults) {
        await txn.insert(
          tableName,
          {
            ...item,
            colCreatedAt: now,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    });
  }
    @override
  Future<List<CategoryModel>> getActive({
    TransactionType? transactionType,
  }) async {
    final db = await _databaseHelper.database;

    String where = '$colIsActive = 1 AND $colDeletedAt IS NULL';
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
      ..write('AND $colDeletedAt IS NULL ')
      ..write('AND TRIM($colName) LIKE ? COLLATE NOCASE');

    final args = <dynamic>[
      '%${keyword.trim()}%',
    ];

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
      ..write('AND $colDeletedAt IS NULL');

    final args = <dynamic>[
      name.trim(),
      transactionType.value,
    ];

    if (excludeId != null) {
      sql.write(' AND $colId != ?');
      args.add(excludeId);
    }

    final result = await db.rawQuery(
      sql.toString(),
      args,
    );

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
  Future<bool> restore(int id) async {
    final db = await _databaseHelper.database;

    final count = await db.update(
      tableName,
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
  Future<int> count({
    TransactionType? transactionType,
  }) async {
    final db = await _databaseHelper.database;

    String sql = '''
      SELECT COUNT(*)
      FROM $tableName
      WHERE $colIsActive = 1
      AND $colDeletedAt IS NULL
    ''';

    final args = <dynamic>[];

    if (transactionType != null) {
      sql += ' AND $colTransactionType = ?';
      args.add(transactionType.value);
    }

    final result = await db.rawQuery(sql, args);

    return Sqflite.firstIntValue(result) ?? 0;
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

  CategoryModel _mapToModel(
    Map<String, dynamic> map,
  ) {
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