// ===============================================================
// Mari-Rojmel
// Transaction Type Enum
//
// Single Source of Truth
// ===============================================================

/// Represents the type of a transaction.
///
/// This enum is shared across the entire application:
///
/// - Category Module
/// - Transaction Module
/// - Dashboard
/// - Reports
/// - Smart Parser
/// - Learning Engine
enum TransactionType {
  expense,
  income;

  /// SQLite / JSON value
  String get value => name;

  /// Display name
  String get displayName {
    switch (this) {
      case TransactionType.expense:
        return 'Expense';

      case TransactionType.income:
        return 'Income';
    }
  }

  /// Parse string safely
  static TransactionType fromString(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'income':
        return TransactionType.income;

      case 'expense':
      default:
        return TransactionType.expense;
    }
  }

  /// SQLite integer support (future use)
  int get indexValue {
    switch (this) {
      case TransactionType.expense:
        return 0;

      case TransactionType.income:
        return 1;
    }
  }

  static TransactionType fromIndex(int? value) {
    switch (value) {
      case 1:
        return TransactionType.income;

      case 0:
      default:
        return TransactionType.expense;
    }
  }

  @override
  String toString() => displayName;
}
