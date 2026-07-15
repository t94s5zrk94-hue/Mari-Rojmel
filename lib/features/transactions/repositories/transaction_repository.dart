import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_constants.dart';
import '../../../core/database/database_helper.dart';
import '../models/transaction_model.dart';

/// ==========================================================
/// Exceptions
/// ==========================================================

class TransactionNotFoundException implements Exception {
  const TransactionNotFoundException();

  @override
  String toString() => 'Transaction not found.';
}

class DuplicateTransactionException implements Exception {
  const DuplicateTransactionException();

  @override
  String toString() => 'Duplicate transaction found.';
}

class ProtectedTransactionException implements Exception {
  const ProtectedTransactionException();

  @override
  String toString() => 'This transaction cannot be modified.';
}

/// ==========================================================
/// Repository Contract
/// ==========================================================

abstract interface class ITransactionRepository {
  Future<bool> insert(TransactionModel model);

  Future<bool> update(TransactionModel model);

  Future<bool> softDelete(int id);

  Future<bool> restore(int id);

  Future<TransactionModel?> getById(int id);

  Future<List<TransactionModel>> getAll();

  Future<List<TransactionModel>> getActive();

  Future<List<TransactionModel>> getDeleted();

  Future<List<TransactionModel>> search(
    String query,
  );

  Future<void> seedDefaultData();
}

/// ==========================================================
/// Repository Implementation
/// ==========================================================

class TransactionRepository
    implements ITransactionRepository {

  TransactionRepository._({
    DatabaseHelper? databaseHelper,
  }) : _databaseHelper =
          databaseHelper ??
          DatabaseHelper.instance;

  static final TransactionRepository instance =
      TransactionRepository._();

  final DatabaseHelper _databaseHelper;

  Future<Database> get _database async =>
      _databaseHelper.database;

  static const String _table =
      DatabaseConstants.transactionsTable;
    // ==========================================================
  // Private Helpers
  // ==========================================================

  Future<bool> _exists(int id) async {
    final db = await _database;

    final result = await db.query(
      _table,
      columns: [DatabaseConstants.id],
      where: '${DatabaseConstants.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  // ==========================================================
  // INSERT
  // ==========================================================

  @override
  Future<bool> insert(
    TransactionModel model,
  ) async {
    final db = await _database;

    final id = await db.insert(
      _table,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return id > 0;
  }

  // ==========================================================
  // UPDATE
  // ==========================================================

  @override
  Future<bool> update(
    TransactionModel model,
  ) async {
    if (model.id == null) {
      throw const TransactionNotFoundException();
    }

    final db = await _database;

    final updatedRows = await db.update(
      _table,
      model
          .copyWith(
            updatedAt: DateTime.now(),
          )
          .toMap(),
      where: '${DatabaseConstants.id} = ?',
      whereArgs: [model.id],
    );

    if (updatedRows == 0) {
      throw const TransactionNotFoundException();
    }

    return true;
  }

  // ==========================================================
  // GET BY ID
  // ==========================================================

  @override
  Future<TransactionModel?> getById(
    int id,
  ) async {
    final db = await _database;

    final result = await db.query(
      _table,
      where: '${DatabaseConstants.id} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return TransactionModel.fromMap(
      result.first,
    );
  }

  // ==========================================================
  // ACTIVE
  // ==========================================================

  @override
  Future<List<TransactionModel>>
      getActive() async {
    final db = await _database;

    final result = await db.query(
      _table,
      where:
          '${DatabaseConstants.isDeleted} = ?',
      whereArgs: [0],
      orderBy:
          '${DatabaseConstants.transactionDate} DESC',
    );

    return result
        .map(TransactionModel.fromMap)
        .toList();
  }

  // ==========================================================
  // DELETED
  // ==========================================================

  @override
  Future<List<TransactionModel>>
      getDeleted() async {
    final db = await _database;

    final result = await db.query(
      _table,
      where:
          '${DatabaseConstants.isDeleted} = ?',
      whereArgs: [1],
      orderBy:
          '${DatabaseConstants.transactionDate} DESC',
    );

    return result
        .map(TransactionModel.fromMap)
        .toList();
  }
    // ==========================================================
  // SOFT DELETE
  // ==========================================================

  @override
  Future<bool> softDelete(
    int id,
  ) async {
    if (!await _exists(id)) {
      throw const TransactionNotFoundException();
    }

    final db = await _database;

    final rows = await db.update(
      _table,
      {
        DatabaseConstants.isDeleted: 1,
        DatabaseConstants.updatedAt:
            DateTime.now().toIso8601String(),
      },
      where: '${DatabaseConstants.id} = ?',
      whereArgs: [id],
    );

    return rows > 0;
  }

  // ==========================================================
  // RESTORE
  // ==========================================================

  @override
  Future<bool> restore(
    int id,
  ) async {
    if (!await _exists(id)) {
      throw const TransactionNotFoundException();
    }

    final db = await _database;

    final rows = await db.update(
      _table,
      {
        DatabaseConstants.isDeleted: 0,
        DatabaseConstants.updatedAt:
            DateTime.now().toIso8601String(),
      },
      where: '${DatabaseConstants.id} = ?',
      whereArgs: [id],
    );

    return rows > 0;
  }

  // ==========================================================
  // SEARCH
  // ==========================================================

  @override
  Future<List<TransactionModel>> search(
    String query,
  ) async {
    final db = await _database;

    final keyword = '%${query.trim()}%';

    final result = await db.query(
      _table,
      where: '''
        ${DatabaseConstants.note} LIKE ?
        AND ${DatabaseConstants.isDeleted} = 0
      ''',
      whereArgs: [keyword],
      orderBy:
          '${DatabaseConstants.transactionDate} DESC',
    );

    return result
        .map(TransactionModel.fromMap)
        .toList();
  }

  // ==========================================================
  // GET ALL
  // ==========================================================

  @override
  Future<List<TransactionModel>> getAll() async {
    final db = await _database;

    final result = await db.query(
      _table,
      orderBy:
          '${DatabaseConstants.transactionDate} DESC',
    );

    return result
        .map(TransactionModel.fromMap)
        .toList();
  }

  // ==========================================================
  // SEED DEFAULT DATA
  // ==========================================================

  @override
  Future<void> seedDefaultData() async {
    // Transactions are user-generated.
    // No default seed data required.
  }
}