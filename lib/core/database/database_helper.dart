// ===============================================================
// Mari-Rojmel
// Database Helper
//
// Production Database V2
// Part 1 / 5
// ===============================================================

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'database_constants.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  // ==========================================================
  // Database Getter
  // ==========================================================

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initializeDatabase();
    return _database!;
  }

  // ==========================================================
  // Initialize Database
  // ==========================================================

  Future<Database> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseConstants.databaseName);

    final db = await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return db;
  }

  // ==========================================================
  // Database Configuration
  // ==========================================================

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');

    await db.rawQuery('PRAGMA journal_mode=WAL');

    await db.rawQuery('PRAGMA synchronous=NORMAL');
  }

  // ==========================================================
  // Database Creation
  // ==========================================================

  Future<void> _onCreate(Database db, int version) async {
    await _createTransactionsTable(db);
    await _createCategoriesTable(db);
    await _createPaymentModesTable(db);
    await _createTransactionLearningTable(db);
    await _createUserProfileTable(db);
    await _createIndexes(db);
  }

  // ==========================================================
  // Database Upgrade
  // ==========================================================

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion >= newVersion) {
      return;
    }

    if (oldVersion < 4) {
      await _migratePaymentModesToV4(db);
    }

    if (oldVersion < 5) {
      await _createUserProfileTable(db);
    }
  }
  // ==========================================================
  // Transactions Table
  // ==========================================================

  Future<void> _createTransactionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseConstants.transactionsTable} (
        ${DatabaseConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.amount} REAL NOT NULL,
        ${DatabaseConstants.transactionType} TEXT NOT NULL,
        ${DatabaseConstants.categoryId} INTEGER NOT NULL,
        ${DatabaseConstants.paymentModeId} INTEGER NOT NULL,
        ${DatabaseConstants.transactionDate} TEXT NOT NULL,
        ${DatabaseConstants.note} TEXT NOT NULL DEFAULT '',
        ${DatabaseConstants.createdAt} TEXT NOT NULL,
        ${DatabaseConstants.updatedAt} TEXT NOT NULL,
        ${DatabaseConstants.isDeleted} INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> _createUserProfileTable(Database db) async {
    await db.execute('''
    CREATE TABLE ${DatabaseConstants.userProfileTable} (
      ${DatabaseConstants.columnUserId} INTEGER PRIMARY KEY,
      ${DatabaseConstants.columnUserName} TEXT NOT NULL,
      ${DatabaseConstants.columnUserMobileNumber} TEXT,
      ${DatabaseConstants.columnUserEmail} TEXT,
      ${DatabaseConstants.columnUserAddress} TEXT,
      ${DatabaseConstants.columnUserCreatedAt} TEXT,
      ${DatabaseConstants.columnUserUpdatedAt} TEXT
    )
  ''');
  }
  // ==========================================================
  // Categories Table
  // ==========================================================

  Future<void> _createCategoriesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DatabaseConstants.categoriesTable} (
        ${DatabaseConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.categoryName} TEXT NOT NULL,
        ${DatabaseConstants.categoryIcon} TEXT NOT NULL,
        ${DatabaseConstants.categoryColor} INTEGER NOT NULL,
        ${DatabaseConstants.categoryTransactionType} TEXT NOT NULL,
        ${DatabaseConstants.categorySortOrder} INTEGER NOT NULL,
        ${DatabaseConstants.categoryIsDefault} INTEGER NOT NULL DEFAULT 0,
        ${DatabaseConstants.categoryIsActive} INTEGER NOT NULL DEFAULT 1,
        ${DatabaseConstants.createdAt} TEXT,
        ${DatabaseConstants.updatedAt} TEXT
      )
    ''');
  }
  // ==========================================================
  // Payment Modes Table
  // ==========================================================

  Future<void> _createPaymentModesTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS ${DatabaseConstants.paymentModesTable} (
      ${DatabaseConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DatabaseConstants.paymentModeName} TEXT NOT NULL,
      ${DatabaseConstants.paymentModeIcon} TEXT NOT NULL,
      ${DatabaseConstants.paymentModeColor} INTEGER NOT NULL,
      ${DatabaseConstants.paymentModeSortOrder} INTEGER NOT NULL,
      ${DatabaseConstants.paymentModeIsDefault} INTEGER NOT NULL DEFAULT 0,
      ${DatabaseConstants.paymentModeIsActive} INTEGER NOT NULL DEFAULT 1,
      ${DatabaseConstants.createdAt} TEXT,
      ${DatabaseConstants.updatedAt} TEXT
    )
  ''');
  }

  Future<void> _migratePaymentModesToV4(Database db) async {
    await db.transaction((txn) async {
      // 1. Rename old table
      await txn.execute('''
      ALTER TABLE ${DatabaseConstants.paymentModesTable}
      RENAME TO payment_modes_old
    ''');

      // 2. Create new table
      await txn.execute('''
      CREATE TABLE ${DatabaseConstants.paymentModesTable} (
        ${DatabaseConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.paymentModeName} TEXT NOT NULL,
        ${DatabaseConstants.paymentModeIcon} TEXT NOT NULL,
        ${DatabaseConstants.paymentModeColor} INTEGER NOT NULL,
        ${DatabaseConstants.paymentModeSortOrder} INTEGER NOT NULL,
        ${DatabaseConstants.paymentModeIsDefault} INTEGER NOT NULL DEFAULT 0,
        ${DatabaseConstants.paymentModeIsActive} INTEGER NOT NULL DEFAULT 1,
        ${DatabaseConstants.createdAt} TEXT,
        ${DatabaseConstants.updatedAt} TEXT
      )
    ''');

      // 3. Copy data
      await txn.execute('''
      INSERT INTO ${DatabaseConstants.paymentModesTable} (
        ${DatabaseConstants.paymentModeName},
        ${DatabaseConstants.paymentModeIcon},
        ${DatabaseConstants.paymentModeColor},
        ${DatabaseConstants.paymentModeSortOrder},
        ${DatabaseConstants.paymentModeIsDefault},
        ${DatabaseConstants.paymentModeIsActive},
        ${DatabaseConstants.createdAt},
        ${DatabaseConstants.updatedAt}
      )
      SELECT
        ${DatabaseConstants.paymentModeName},
        ${DatabaseConstants.paymentModeIcon},
        ${DatabaseConstants.paymentModeColor},
        ${DatabaseConstants.paymentModeSortOrder},
        ${DatabaseConstants.paymentModeIsDefault},
        ${DatabaseConstants.paymentModeIsActive},
        ${DatabaseConstants.createdAt},
        ${DatabaseConstants.updatedAt}
      FROM payment_modes_old
    ''');
    });
  }
  // ==========================================================
  // Transaction Learning Table
  // ==========================================================

  Future<void> _createTransactionLearningTable(Database db) async {
    await db.execute('''
  CREATE TABLE IF NOT EXISTS
  ${DatabaseConstants.transactionLearningTable}
  (
    ${DatabaseConstants.id}
    INTEGER PRIMARY KEY AUTOINCREMENT,

    ${DatabaseConstants.keyword}
    TEXT NOT NULL UNIQUE,

    ${DatabaseConstants.categoryId}
    INTEGER NOT NULL,

    ${DatabaseConstants.useCount}
    INTEGER NOT NULL DEFAULT 1,

    ${DatabaseConstants.lastUsedAt}
    TEXT NOT NULL,

    ${DatabaseConstants.createdAt}
    TEXT NOT NULL,

    ${DatabaseConstants.updatedAt}
    TEXT NOT NULL
  )
  ''');
  }

  // ==========================================================
  // Database Indexes
  // ==========================================================

  Future<void> _createIndexes(Database db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_transactions_date ON ${DatabaseConstants.transactionsTable} (${DatabaseConstants.transactionDate})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_transactions_category ON ${DatabaseConstants.transactionsTable} (${DatabaseConstants.categoryId})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_transactions_payment ON ${DatabaseConstants.transactionsTable} (${DatabaseConstants.paymentModeId})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_categories_name ON ${DatabaseConstants.categoriesTable} (${DatabaseConstants.categoryName})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_payment_modes_name ON ${DatabaseConstants.paymentModesTable} (${DatabaseConstants.paymentModeName})',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_transaction_learning_keyword ON ${DatabaseConstants.transactionLearningTable} (${DatabaseConstants.keyword})',
    );
  }

  // ==========================================================
  // Close Database
  // ==========================================================

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // ==========================================================
  // Delete Database
  // ==========================================================

  Future<void> deleteDatabaseFile() async {
    await closeDatabase();
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DatabaseConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
  }

  // ==========================================================
  // Reset Database
  // ==========================================================

  Future<void> resetDatabase() async {
    await deleteDatabaseFile();
    _database = await _initializeDatabase();
  }
}
