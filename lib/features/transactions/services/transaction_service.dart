import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_constants.dart';
import '../../../core/database/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionService {
  TransactionService._();

  static final TransactionService instance = TransactionService._();

  Future<int> saveTransaction(TransactionModel transaction) async {
    final Database db = await DatabaseHelper.instance.database;

    return await db.insert(
      DatabaseConstants.transactionsTable,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final Database db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> result = await db.query(
      DatabaseConstants.transactionsTable,
      orderBy: '${DatabaseConstants.transactionDate} DESC',
    );

    return result
        .map((e) => TransactionModel.fromMap(e))
        .toList();
  }

  Future<void> deleteAllTransactions() async {
    final Database db = await DatabaseHelper.instance.database;

    await db.delete(DatabaseConstants.transactionsTable);
  }

  Future<int> getTransactionCount() async {
    final Database db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM ${DatabaseConstants.transactionsTable}',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
}