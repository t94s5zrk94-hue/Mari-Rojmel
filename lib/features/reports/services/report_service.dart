import 'dart:collection';

import '../../transactions/models/transaction_model.dart';
import '../../transactions/repositories/transaction_repository.dart';
import '../models/report_summary.dart';



/// ==========================================================
/// Report Filter
/// ==========================================================

enum ReportFilterType {
  today,
  thisWeek,
  thisMonth,
  thisYear,
  custom,
}

/// ==========================================================
/// Date Range Filter
/// ==========================================================

class ReportFilter {
  const ReportFilter({
    required this.type,
    this.startDate,
    this.endDate,
  });

  final ReportFilterType type;
  final DateTime? startDate;
  final DateTime? endDate;

  const ReportFilter.today()
      : type = ReportFilterType.today,
        startDate = null,
        endDate = null;

  const ReportFilter.thisWeek()
      : type = ReportFilterType.thisWeek,
        startDate = null,
        endDate = null;

  const ReportFilter.thisMonth()
      : type = ReportFilterType.thisMonth,
        startDate = null,
        endDate = null;

  const ReportFilter.thisYear()
      : type = ReportFilterType.thisYear,
        startDate = null,
        endDate = null;

  const ReportFilter.custom({
    required DateTime from,
    required DateTime to,
  })  : type = ReportFilterType.custom,
        startDate = from,
        endDate = to;
}

/// ==========================================================
/// Reports Service
/// ==========================================================

class ReportsService {
  ReportsService._({
    TransactionRepository? repository,
  }) : _repository =
            repository ??
            TransactionRepository.instance;

    static final ReportsService instance =
      ReportsService._();

    final TransactionRepository _repository;

   

  /// ==========================================================
  /// Public APIs
  /// ==========================================================

  Future<ReportSummary> getSummary({
    required ReportFilter filter,
  }) async {
    final transactions =
        await _getFilteredTransactions(filter);

    return _buildSummary(transactions);
  }

  Future<Map<int, double>> getCategoryReport({
    required ReportFilter filter,
  }) async {
    final transactions =
        await _getFilteredTransactions(filter);

    final result = SplayTreeMap<int, double>();

    for (final transaction in transactions) {
      result.update(
        transaction.categoryId,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    return result;
  }

  Future<Map<int, double>>
      getPaymentModeReport({
    required ReportFilter filter,
  }) async {
    final transactions =
        await _getFilteredTransactions(filter);

    final result = SplayTreeMap<int, double>();

    for (final transaction in transactions) {
      result.update(
        transaction.paymentModeId,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    return result;
  }

  /// ==========================================================
  /// Private Methods
  /// ==========================================================

  Future<List<TransactionModel>>
      _getFilteredTransactions(
    ReportFilter filter,
  ) async {
    final allTransactions =
        await _repository.getActive();

    final now = DateTime.now();

    switch (filter.type) {
      case ReportFilterType.today:
        return _filterToday(
          allTransactions,
          now,
        );

      case ReportFilterType.thisWeek:
        return _filterThisWeek(
          allTransactions,
          now,
        );

      case ReportFilterType.thisMonth:
        return _filterThisMonth(
          allTransactions,
          now,
        );

      case ReportFilterType.thisYear:
        return _filterThisYear(
          allTransactions,
          now,
        );

      case ReportFilterType.custom:
        return _filterCustom(
          allTransactions,
          filter.startDate!,
          filter.endDate!,
        );
    }
  }
    ReportSummary _buildSummary(
        List<TransactionModel> transactions,
    ) {
        if (transactions.isEmpty) {
        return const ReportSummary.empty();
        }

        final incomeTransactions = transactions
            .where((transaction) => transaction.isIncome)
            .toList();

        final expenseTransactions = transactions
            .where((transaction) => transaction.isExpense)
            .toList();

        final totalIncome = incomeTransactions.fold<double>(
        0,
        (sum, transaction) => sum + transaction.amount,
        );

        final totalExpense = expenseTransactions.fold<double>(
        0,
        (sum, transaction) => sum + transaction.amount,
        );

        final double highestIncome = incomeTransactions.isEmpty
            ? 0.0
            : incomeTransactions
                .map((e) => e.amount)
                .reduce((a, b) => a > b ? a : b)
                .toDouble();

        final double highestExpense = expenseTransactions.isEmpty
            ? 0.0
            : expenseTransactions
                .map((e) => e.amount)
                .reduce((a, b) => a > b ? a : b)
                .toDouble();

        final double averageIncome = incomeTransactions.isEmpty
            ? 0.0
            : totalIncome / incomeTransactions.length;

        final double averageExpense = expenseTransactions.isEmpty
            ? 0.0

    : totalExpense / expenseTransactions.length;
        return ReportSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        netBalance: totalIncome - totalExpense,
        highestIncome: highestIncome,
        highestExpense: highestExpense,
        totalTransactions: transactions.length,
        averageIncome: averageIncome,
        averageExpense: averageExpense,
        );
    }

    List<TransactionModel> _filterToday(
        List<TransactionModel> transactions,
        DateTime now,
    ) {
        return transactions.where((transaction) {
        final date = transaction.transactionDate;

        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
        }).toList();
    }

    List<TransactionModel> _filterThisWeek(
        List<TransactionModel> transactions,
        DateTime now,
    ) {
        final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day,
        ).subtract(
        Duration(days: now.weekday - 1),
        );

        final endOfWeek = startOfWeek.add(
        const Duration(days: 7),
        );

        return transactions.where((transaction) {
        final date = transaction.transactionDate;

        return !date.isBefore(startOfWeek) &&
            date.isBefore(endOfWeek);
        }).toList();
    }

    List<TransactionModel> _filterThisMonth(
        List<TransactionModel> transactions,
        DateTime now,
    ) {
        return transactions.where((transaction) {
        final date = transaction.transactionDate;

        return date.year == now.year &&
            date.month == now.month;
        }).toList();
    }

    List<TransactionModel> _filterThisYear(
        List<TransactionModel> transactions,
        DateTime now,
    ) {
        return transactions.where((transaction) {
        return transaction.transactionDate.year ==
            now.year;
        }).toList();
    }

    List<TransactionModel> _filterCustom(
        List<TransactionModel> transactions,
        DateTime from,
        DateTime to,
    ) {
        final start = DateTime(
        from.year,
        from.month,
        from.day,
        );

        final end = DateTime(
        to.year,
        to.month,
        to.day,
        23,
        59,
        59,
        999,
        );

        return transactions.where((transaction) {
        final date = transaction.transactionDate;

        return !date.isBefore(start) &&
            !date.isAfter(end);
        }).toList();
    }
    }