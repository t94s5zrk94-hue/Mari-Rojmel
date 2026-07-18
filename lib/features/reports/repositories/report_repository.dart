// ===============================================================
// Mari-Rojmel
// Report Repository
//
// Production Ready
// Flutter 3.x
// Material 3
// Clean Architecture
// Repository Pattern
// ===============================================================

import 'package:sqflite/sqflite.dart';
import '../models/payment_mode_report_item.dart';
import '../../../core/database/database_constants.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/enums/transaction_type.dart';
import '../../transactions/models/transaction_model.dart';
import '../models/category_report_item.dart';
import '../models/monthly_report_model.dart';
import '../models/report_summary.dart';

class ReportRepository {
  ReportRepository({DatabaseHelper? databaseHelper})
    : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _databaseHelper;

  // ==========================================================
  // Database
  // ==========================================================

  Future<Database> get _database async => _databaseHelper.database;

  // ==========================================================
  // Common WHERE Clause
  // ==========================================================

  static const String _activeTransactionsWhere =
      '${DatabaseConstants.isDeleted} = 0';

  // ==========================================================
  // Helpers
  // ==========================================================

  Future<List<Map<String, dynamic>>> _queryTransactions({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? transactionType,
  }) async {
    final db = await _database;

    final whereParts = <String>[_activeTransactionsWhere];

    final whereArgs = <Object?>[];

    if (transactionType != null) {
      whereParts.add('${DatabaseConstants.transactionType} = ?');
      whereArgs.add(transactionType.value);
    }

    if (startDate != null) {
      whereParts.add('${DatabaseConstants.transactionDate} >= ?');
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      whereParts.add('${DatabaseConstants.transactionDate} <= ?');
      whereArgs.add(endDate.toIso8601String());
    }

    return db.query(
      DatabaseConstants.transactionsTable,
      where: whereParts.join(' AND '),
      whereArgs: whereArgs,
      orderBy: '${DatabaseConstants.transactionDate} DESC',
    );
  }

  List<TransactionModel> _toTransactions(List<Map<String, dynamic>> rows) {
    return rows.map(TransactionModel.fromMap).toList(growable: false);
  }

  double _sumAmounts(Iterable<TransactionModel> transactions) {
    return transactions.fold<double>(0, (sum, item) => sum + item.amount);
  }

  double _highestAmount(Iterable<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return 0;
    }

    return transactions.map((e) => e.amount).reduce((a, b) => a > b ? a : b);
  }

  double _averageAmount(Iterable<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return 0;
    }

    return _sumAmounts(transactions) / transactions.length;
  }

  // ==========================================================
  // Public Methods
  // ==========================================================

  // ==========================================================
  // Report Summary
  // ==========================================================

  Future<ReportSummary> getReportSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final rows = await _queryTransactions(
        startDate: startDate,
        endDate: endDate,
      );

      final transactions = _toTransactions(rows);

      final incomeTransactions = transactions
          .where((transaction) => transaction.isIncome)
          .toList(growable: false);

      final expenseTransactions = transactions
          .where((transaction) => transaction.isExpense)
          .toList(growable: false);

      final totalIncome = _sumAmounts(incomeTransactions);

      final totalExpense = _sumAmounts(expenseTransactions);

      final netBalance = totalIncome - totalExpense;

      final highestIncome = _highestAmount(incomeTransactions);

      final highestExpense = _highestAmount(expenseTransactions);

      final averageIncome = _averageAmount(incomeTransactions);

      final averageExpense = _averageAmount(expenseTransactions);

      return ReportSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        netBalance: netBalance,
        highestIncome: highestIncome,
        highestExpense: highestExpense,
        totalTransactions: transactions.length,
        averageIncome: averageIncome,
        averageExpense: averageExpense,
      );
    } catch (_) {
      return const ReportSummary.empty();
    }
  }

  // ==========================================================
  // Category Report
  // ==========================================================

  Future<List<CategoryReportItem>> getCategoryReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _database;

    final whereParts = <String>['t.${DatabaseConstants.isDeleted} = 0'];

    final whereArgs = <Object?>[];

    if (startDate != null) {
      whereParts.add('t.${DatabaseConstants.transactionDate} >= ?');
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      whereParts.add('t.${DatabaseConstants.transactionDate} <= ?');
      whereArgs.add(endDate.toIso8601String());
    }

    final result = await db.rawQuery('''
      SELECT
        c.${DatabaseConstants.id} AS category_id,
        c.${DatabaseConstants.categoryName} AS category_name,
        c.${DatabaseConstants.categoryIcon} AS category_icon,
        c.${DatabaseConstants.categoryColor} AS category_color,

        SUM(t.${DatabaseConstants.amount}) AS total_amount,
        COUNT(t.${DatabaseConstants.id}) AS transaction_count

      FROM ${DatabaseConstants.transactionsTable} t

      INNER JOIN ${DatabaseConstants.categoriesTable} c
        ON t.${DatabaseConstants.categoryId} = c.${DatabaseConstants.id}

      WHERE ${whereParts.join(' AND ')}

      GROUP BY
        c.${DatabaseConstants.id},
        c.${DatabaseConstants.categoryName},
        c.${DatabaseConstants.categoryIcon},
        c.${DatabaseConstants.categoryColor}

      ORDER BY total_amount DESC
      ''', whereArgs);

    return result
        .map((row) {
          return CategoryReportItem(
            categoryId: (row['category_id'] as num).toInt(),
            name: row['category_name'] as String,
            icon: row['category_icon'] as String,
            color: (row['category_color'] as num).toInt(),
            amount: (row['total_amount'] as num).toDouble(),
            transactionCount: (row['transaction_count'] as num).toInt(),
          );
        })
        .toList(growable: false);
  }

  Future<List<PaymentModeReportItem>> getPaymentModeReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await _database;

    final whereParts = <String>['t.${DatabaseConstants.isDeleted} = 0'];

    final whereArgs = <Object?>[];

    if (startDate != null) {
      whereParts.add('t.${DatabaseConstants.transactionDate} >= ?');
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      whereParts.add('t.${DatabaseConstants.transactionDate} <= ?');
      whereArgs.add(endDate.toIso8601String());
    }

    final result = await db.rawQuery('''
    SELECT
      p.${DatabaseConstants.id} AS payment_mode_id,
      p.${DatabaseConstants.paymentModeName} AS payment_mode_name,
      p.${DatabaseConstants.paymentModeIcon} AS payment_mode_icon,
      p.${DatabaseConstants.paymentModeColor} AS payment_mode_color,

      SUM(t.${DatabaseConstants.amount}) AS total_amount,
      COUNT(t.${DatabaseConstants.id}) AS transaction_count

    FROM ${DatabaseConstants.transactionsTable} t

    INNER JOIN ${DatabaseConstants.paymentModesTable} p
      ON t.${DatabaseConstants.paymentModeId} = p.${DatabaseConstants.id}

    WHERE ${whereParts.join(' AND ')}

    GROUP BY
      p.${DatabaseConstants.id},
      p.${DatabaseConstants.paymentModeName},
      p.${DatabaseConstants.paymentModeIcon},
      p.${DatabaseConstants.paymentModeColor}

    ORDER BY total_amount DESC
    ''', whereArgs);

    return result
        .map(
          (row) => PaymentModeReportItem(
            paymentModeId: (row['payment_mode_id'] as num).toInt(),
            name: row['payment_mode_name'] as String,
            icon: row['payment_mode_icon'] as String,
            color: (row['payment_mode_color'] as num).toInt(),
            amount: (row['total_amount'] as num).toDouble(),
            transactionCount: (row['transaction_count'] as num).toInt(),
          ),
        )
        .toList(growable: false);
  }
  // ==========================================================
  // Monthly Report
  // ==========================================================

  Future<List<MonthlyReportModel>> getMonthlyReport({int? year}) async {
    final db = await _database;

    final whereParts = <String>['${DatabaseConstants.isDeleted} = 0'];

    final whereArgs = <Object?>[];

    if (year != null) {
      whereParts.add(
        "strftime('%Y', ${DatabaseConstants.transactionDate}) = ?",
      );
      whereArgs.add(year.toString());
    }

    final result = await db.rawQuery('''
      SELECT

        strftime('%Y', ${DatabaseConstants.transactionDate}) AS report_year,
        strftime('%m', ${DatabaseConstants.transactionDate}) AS report_month,

        SUM(
          CASE
            WHEN ${DatabaseConstants.transactionType} = 'income'
            THEN ${DatabaseConstants.amount}
            ELSE 0
          END
        ) AS total_income,

        SUM(
          CASE
            WHEN ${DatabaseConstants.transactionType} = 'expense'
            THEN ${DatabaseConstants.amount}
            ELSE 0
          END
        ) AS total_expense,

        MAX(
          CASE
            WHEN ${DatabaseConstants.transactionType} = 'income'
            THEN ${DatabaseConstants.amount}
            ELSE 0
          END
        ) AS highest_income,

        MAX(
          CASE
            WHEN ${DatabaseConstants.transactionType} = 'expense'
            THEN ${DatabaseConstants.amount}
            ELSE 0
          END
        ) AS highest_expense,

        COUNT(*) AS total_transactions

      FROM ${DatabaseConstants.transactionsTable}

      WHERE ${whereParts.join(' AND ')}

      GROUP BY
        report_year,
        report_month

      ORDER BY
        report_year DESC,
        report_month DESC
      ''', whereArgs);

    return result
        .map((row) {
          final income = (row['total_income'] as num?)?.toDouble() ?? 0;

          final expense = (row['total_expense'] as num?)?.toDouble() ?? 0;

          final totalTransactions =
              (row['total_transactions'] as num?)?.toInt() ?? 0;

          return MonthlyReportModel(
            year: int.parse(row['report_year'] as String),
            month: int.parse(row['report_month'] as String),

            totalIncome: income,
            totalExpense: expense,
            netBalance: income - expense,

            totalTransactions: totalTransactions,

            highestIncome: (row['highest_income'] as num?)?.toDouble() ?? 0,

            highestExpense: (row['highest_expense'] as num?)?.toDouble() ?? 0,

            averageIncome: totalTransactions == 0
                ? 0
                : income / totalTransactions,

            averageExpense: totalTransactions == 0
                ? 0
                : expense / totalTransactions,
          );
        })
        .toList(growable: false);
  }

  // ==========================================================
  // Income Transactions
  // ==========================================================

  Future<List<TransactionModel>> getIncomeTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final rows = await _queryTransactions(
      startDate: startDate,
      endDate: endDate,
      transactionType: TransactionType.income,
    );

    return _toTransactions(rows);
  }

  // ==========================================================
  // Expense Transactions
  // ==========================================================

  Future<List<TransactionModel>> getExpenseTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final rows = await _queryTransactions(
      startDate: startDate,
      endDate: endDate,
      transactionType: TransactionType.expense,
    );

    return _toTransactions(rows);
  }

  // ==========================================================
  // Transactions By Date Range
  // ==========================================================

  Future<List<TransactionModel>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final rows = await _queryTransactions(
      startDate: startDate,
      endDate: endDate,
    );

    return _toTransactions(rows);
  }
}
