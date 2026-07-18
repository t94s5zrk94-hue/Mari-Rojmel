import 'package:flutter/foundation.dart';

/// Immutable monthly report model.
///
/// Represents the aggregated financial statistics for a
/// specific month and year.
@immutable
class MonthlyReportModel {
  /// Creates a monthly report model.
  const MonthlyReportModel({
    required this.year,
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.totalTransactions,
    required this.highestIncome,
    required this.highestExpense,
    required this.averageIncome,
    required this.averageExpense,
  });

  /// Report year.
  final int year;

  /// Report month (1-12).
  final int month;

  /// Total income.
  final double totalIncome;

  /// Total expense.
  final double totalExpense;

  /// Net balance (Income - Expense).
  final double netBalance;

  /// Total number of transactions.
  final int totalTransactions;

  /// Highest income transaction.
  final double highestIncome;

  /// Highest expense transaction.
  final double highestExpense;

  /// Average income transaction.
  final double averageIncome;

  /// Average expense transaction.
  final double averageExpense;

  /// Empty monthly report.
  const MonthlyReportModel.empty()
    : year = 0,
      month = 0,
      totalIncome = 0,
      totalExpense = 0,
      netBalance = 0,
      totalTransactions = 0,
      highestIncome = 0,
      highestExpense = 0,
      averageIncome = 0,
      averageExpense = 0;

  /// Returns a copy with modified values.
  MonthlyReportModel copyWith({
    int? year,
    int? month,
    double? totalIncome,
    double? totalExpense,
    double? netBalance,
    int? totalTransactions,
    double? highestIncome,
    double? highestExpense,
    double? averageIncome,
    double? averageExpense,
  }) {
    return MonthlyReportModel(
      year: year ?? this.year,
      month: month ?? this.month,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netBalance: netBalance ?? this.netBalance,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      highestIncome: highestIncome ?? this.highestIncome,
      highestExpense: highestExpense ?? this.highestExpense,
      averageIncome: averageIncome ?? this.averageIncome,
      averageExpense: averageExpense ?? this.averageExpense,
    );
  }

  /// Converts model to map.
  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netBalance': netBalance,
      'totalTransactions': totalTransactions,
      'highestIncome': highestIncome,
      'highestExpense': highestExpense,
      'averageIncome': averageIncome,
      'averageExpense': averageExpense,
    };
  }

  /// Creates model from map.
  factory MonthlyReportModel.fromMap(Map<String, dynamic> map) {
    return MonthlyReportModel(
      year: (map['year'] as num?)?.toInt() ?? 0,
      month: (map['month'] as num?)?.toInt() ?? 0,
      totalIncome: (map['totalIncome'] as num?)?.toDouble() ?? 0,
      totalExpense: (map['totalExpense'] as num?)?.toDouble() ?? 0,
      netBalance: (map['netBalance'] as num?)?.toDouble() ?? 0,
      totalTransactions: (map['totalTransactions'] as num?)?.toInt() ?? 0,
      highestIncome: (map['highestIncome'] as num?)?.toDouble() ?? 0,
      highestExpense: (map['highestExpense'] as num?)?.toDouble() ?? 0,
      averageIncome: (map['averageIncome'] as num?)?.toDouble() ?? 0,
      averageExpense: (map['averageExpense'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  String toString() {
    return 'MonthlyReportModel('
        'year: $year, '
        'month: $month, '
        'totalIncome: $totalIncome, '
        'totalExpense: $totalExpense, '
        'netBalance: $netBalance, '
        'totalTransactions: $totalTransactions, '
        'highestIncome: $highestIncome, '
        'highestExpense: $highestExpense, '
        'averageIncome: $averageIncome, '
        'averageExpense: $averageExpense'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is MonthlyReportModel &&
        other.year == year &&
        other.month == month &&
        other.totalIncome == totalIncome &&
        other.totalExpense == totalExpense &&
        other.netBalance == netBalance &&
        other.totalTransactions == totalTransactions &&
        other.highestIncome == highestIncome &&
        other.highestExpense == highestExpense &&
        other.averageIncome == averageIncome &&
        other.averageExpense == averageExpense;
  }

  @override
  int get hashCode => Object.hash(
    year,
    month,
    totalIncome,
    totalExpense,
    netBalance,
    totalTransactions,
    highestIncome,
    highestExpense,
    averageIncome,
    averageExpense,
  );
}
