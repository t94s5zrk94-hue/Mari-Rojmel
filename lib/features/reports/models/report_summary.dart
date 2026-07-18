import 'package:flutter/foundation.dart';

/// Immutable summary model used by the Reports module.
///
/// This model represents the aggregated financial statistics for the
/// selected reporting period.
@immutable
class ReportSummary {
  /// Total income amount.
  final double totalIncome;

  /// Total expense amount.
  final double totalExpense;

  /// Net balance (Income - Expense).
  final double netBalance;

  /// Highest single income transaction.
  final double highestIncome;

  /// Highest single expense transaction.
  final double highestExpense;

  /// Total number of transactions.
  final int totalTransactions;

  /// Average income transaction amount.
  final double averageIncome;

  /// Average expense transaction amount.
  final double averageExpense;

  const ReportSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.highestIncome,
    required this.highestExpense,
    required this.totalTransactions,
    required this.averageIncome,
    required this.averageExpense,
  });

  /// Empty summary used as a safe default.
  const ReportSummary.empty()
      : totalIncome = 0,
        totalExpense = 0,
        netBalance = 0,
        highestIncome = 0,
        highestExpense = 0,
        totalTransactions = 0,
        averageIncome = 0,
        averageExpense = 0;

  /// Creates a copy with modified values.
  ReportSummary copyWith({
    double? totalIncome,
    double? totalExpense,
    double? netBalance,
    double? highestIncome,
    double? highestExpense,
    int? totalTransactions,
    double? averageIncome,
    double? averageExpense,
  }) {
    return ReportSummary(
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      netBalance: netBalance ?? this.netBalance,
      highestIncome: highestIncome ?? this.highestIncome,
      highestExpense: highestExpense ?? this.highestExpense,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      averageIncome: averageIncome ?? this.averageIncome,
      averageExpense: averageExpense ?? this.averageExpense,
    );
  }

  /// Serialize to Map.
  Map<String, dynamic> toMap() {
    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netBalance': netBalance,
      'highestIncome': highestIncome,
      'highestExpense': highestExpense,
      'totalTransactions': totalTransactions,
      'averageIncome': averageIncome,
      'averageExpense': averageExpense,
    };
  }

  /// Deserialize from Map.
  factory ReportSummary.fromMap(Map<String, dynamic> map) {
    return ReportSummary(
      totalIncome: (map['totalIncome'] as num?)?.toDouble() ?? 0,
      totalExpense: (map['totalExpense'] as num?)?.toDouble() ?? 0,
      netBalance: (map['netBalance'] as num?)?.toDouble() ?? 0,
      highestIncome: (map['highestIncome'] as num?)?.toDouble() ?? 0,
      highestExpense: (map['highestExpense'] as num?)?.toDouble() ?? 0,
      totalTransactions: (map['totalTransactions'] as num?)?.toInt() ?? 0,
      averageIncome: (map['averageIncome'] as num?)?.toDouble() ?? 0,
      averageExpense: (map['averageExpense'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  String toString() {
    return 'ReportSummary('
        'totalIncome: $totalIncome, '
        'totalExpense: $totalExpense, '
        'netBalance: $netBalance, '
        'highestIncome: $highestIncome, '
        'highestExpense: $highestExpense, '
        'totalTransactions: $totalTransactions, '
        'averageIncome: $averageIncome, '
        'averageExpense: $averageExpense'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportSummary &&
        other.totalIncome == totalIncome &&
        other.totalExpense == totalExpense &&
        other.netBalance == netBalance &&
        other.highestIncome == highestIncome &&
        other.highestExpense == highestExpense &&
        other.totalTransactions == totalTransactions &&
        other.averageIncome == averageIncome &&
        other.averageExpense == averageExpense;
  }

  @override
  int get hashCode {
    return Object.hash(
      totalIncome,
      totalExpense,
      netBalance,
      highestIncome,
      highestExpense,
      totalTransactions,
      averageIncome,
      averageExpense,
    );
  }
}