import '../../../core/database/database_constants.dart';
import '../../../core/database/database_helper.dart';
import '../models/dashboard_summary.dart';

class DashboardService {
  DashboardService._();

  static final DashboardService instance = DashboardService._();

  Future<DashboardSummary> getSummary() async {
    final db = await DatabaseHelper.instance.database;

    final rows = await db.query(DatabaseConstants.transactionsTable);

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

    return DashboardSummary(
      todayIncome: income,
      todayExpense: expense,
      balance: income - expense,
      transactionCount: rows.length,
    );
  }
}