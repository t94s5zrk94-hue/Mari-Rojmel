import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/categories/repositories/category_repository.dart';
import '../../features/payment_modes/repositories/payment_mode_repository.dart';
import 'database_constants.dart';

/// ===============================================================
/// Mari-Rojmel Database Helper
///
/// SQLite Database Manager
/// Production Ready
/// ===============================================================
class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance =
      DatabaseHelper._();

  Database? _database;

  /// Returns the singleton database instance.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();

    return _database!;
  }

  /// Initializes SQLite database.
  Future<Database> _initializeDatabase() async {
    final databasePath =
        await getDatabasesPath();

    final path = join(
      databasePath,
      DatabaseConstants.databaseName,
    );

    return openDatabase(
      path,
      version:
          DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  /// Configure SQLite.
  Future<void> _onConfigure(
    Database db,
  ) async {
    await db.execute(
      'PRAGMA foreign_keys = ON;',
    );
  }

  /// Database creation callback.
  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
        // ==========================================================
        // Transactions Table
        // ==========================================================

        await db.execute('''
          CREATE TABLE ${DatabaseConstants.transactionsTable} (
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

        await db.execute('''
          CREATE INDEX idx_transactions_date
          ON ${DatabaseConstants.transactionsTable}
          (${DatabaseConstants.transactionDate})
        ''');

        await db.execute('''
          CREATE INDEX idx_transactions_category
          ON ${DatabaseConstants.transactionsTable}
          (${DatabaseConstants.categoryId})
        ''');

        await db.execute('''
          CREATE INDEX idx_transactions_payment_mode
          ON ${DatabaseConstants.transactionsTable}
          (${DatabaseConstants.paymentModeId})
        ''');

        // ==========================================================
        // Category Table
        // ==========================================================

        final categoryRepository =
            CategoryRepository(
          DatabaseHelper.instance,
        );

        await categoryRepository.createTable();

        await categoryRepository.seedDefaults();

        // ==========================================================
        // Payment Mode Table
        // ==========================================================

        final paymentModeRepository =
            PaymentModeRepository(
          DatabaseHelper.instance,
        );

        await paymentModeRepository.createTable();

        await paymentModeRepository.seedDefaults();
    }

  // ==========================================================
  // Database Upgrade
  // ==========================================================

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Future database migrations.
    //
    // Example:
    //
    // if (oldVersion < 2) {
    //   await db.execute(...);
    // }
  }

  // ==========================================================
  // Close Database
  // ==========================================================

  Future<void> close() async {
    if (_database == null) {
      return;
    }

    await _database!.close();

    _database = null;
  }

  // ==========================================================
  // Delete Database
  // ==========================================================

  Future<void> deleteDatabaseFile() async {
    await close();

    final databasePath =
        await getDatabasesPath();

    final path = join(
      databasePath,
      DatabaseConstants.databaseName,
    );

    await databaseFactory.deleteDatabase(
      path,
    );
  }

  // ==========================================================
  // Recreate Database (Development Only)
  // ==========================================================

  Future<void> resetDatabase() async {
    await deleteDatabaseFile();

    await database;
  }
}
      