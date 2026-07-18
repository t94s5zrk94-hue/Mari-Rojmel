// ===============================================================
// Mari-Rojmel
// Database Initializer
//
// Production Database V2
// Part 1 / 4
// ===============================================================

import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class DatabaseInitializer {
  DatabaseInitializer._();

  static final DatabaseInitializer instance =
      DatabaseInitializer._();

  bool _initialized = false;

  // ==========================================================
  // Initialize Database
  // ==========================================================

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final db =
        await DatabaseHelper.instance.database;

    await _initializeDefaults(db);

    _initialized = true;
  }

  // ==========================================================
  // Default Initialization
  // ==========================================================

  Future<void> _initializeDefaults(
    Database db,
  ) async {
    await _initializeCategories(db);

    await _initializePaymentModes(db);
  }

  // ==========================================================
// Category Initialization
// ==========================================================

Future<void> _initializeCategories(
  Database db,
) async {
  final result = await db.rawQuery(
    '''
SELECT COUNT(*)
FROM categories
''',
  );

  final count =
      Sqflite.firstIntValue(result) ?? 0;

  if (count > 0) {
    return;
  }

  final now =
      DateTime.now().toIso8601String();

  await db.transaction(
    (txn) async {
      await txn.insert(
        'categories',
        {
          'id': 'CAT001',
          'name': 'General',
          'icon': 'category',
          'color': 0xFF2196F3,
          'sort_order': 1,
          'is_default': 1,
          'is_active': 1,
          'created_at': now,
          'updated_at': now,
        },
      );

      await txn.insert(
        'categories',
        {
          'id': 'CAT002',
          'name': 'Food',
          'icon': 'restaurant',
          'color': 0xFFFF9800,
          'sort_order': 2,
          'is_default': 1,
          'is_active': 1,
          'created_at': now,
          'updated_at': now,
        },
      );
    },
  );
}

  // ==========================================================
// Payment Mode Initialization
// ==========================================================

Future<void> _initializePaymentModes(
  Database db,
) async {
  final result = await db.rawQuery(
    '''
SELECT COUNT(*)
FROM payment_modes
''',
  );

  final count =
      Sqflite.firstIntValue(result) ?? 0;

  if (count > 0) {
    return;
  }

  final now =
      DateTime.now().toIso8601String();

  await db.transaction(
    (txn) async {
      await txn.insert(
        'payment_modes',
        {
          'id': 'PM001',
          'payment_mode_name': 'Cash',
          'icon': 'cash',
          'color': 0xFF4CAF50,
          'sort_order': 1,
          'is_default': 1,
          'is_active': 1,
          'created_at': now,
          'updated_at': now,
        },
      );

      await txn.insert(
        'payment_modes',
        {
          'id': 'PM002',
          'payment_mode_name': 'UPI',
          'icon': 'upi',
          'color': 0xFF2196F3,
          'sort_order': 2,
          'is_default': 1,
          'is_active': 1,
          'created_at': now,
          'updated_at': now,
        },
      );

      await txn.insert(
        'payment_modes',
        {
          'id': 'PM003',
          'payment_mode_name': 'Bank',
          'icon': 'account_balance',
          'color': 0xFFFF9800,
          'sort_order': 3,
          'is_default': 1,
          'is_active': 1,
          'created_at': now,
          'updated_at': now,
        },
      );
    },
  );
}
}