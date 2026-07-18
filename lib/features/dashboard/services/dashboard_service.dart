import '../../../core/database/database_constants.dart';
import '../../../core/database/database_helper.dart';
import '../models/dashboard_summary.dart';
import 'package:flutter/foundation.dart';
//import 'package:sqflite/sqflite.dart';

class DashboardService {
  DashboardService._();

  static final DashboardService instance = DashboardService._();

  Future<DashboardSummary> getSummary() async {
    debugPrint('A');

    final db = await DatabaseHelper.instance.database;

    debugPrint('B');

    final rows = await db.query(
      DatabaseConstants.transactionsTable,
      where: '${DatabaseConstants.isDeleted} = ?',
      whereArgs: [0],
    );

    debugPrint('C rows = ${rows.length}');

    double income = 0;
    double expense = 0;

    for (final row in rows) {
      final amount = (row[DatabaseConstants.amount] as num).toDouble();

      if (row[DatabaseConstants.transactionType] == 'income') {
        income += amount;
      } else {
        expense += amount;
      }
    }

    debugPrint('D');

    return DashboardSummary(
      todayIncome: income,
      todayExpense: expense,
      balance: income - expense,
      transactionCount: rows.length,
    );
  }
}
