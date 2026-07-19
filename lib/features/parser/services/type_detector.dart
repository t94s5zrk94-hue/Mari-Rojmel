// ===============================================================
// Mari-Rojmel
// Transaction Type Detector
//
// Detects Income / Expense from transaction tokens.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import '../../../core/enums/transaction_type.dart';
import '../constants/parser_keywords.dart';

class TypeDetector {
  const TypeDetector._();

  // ==========================================================
  // Detect Type
  // ==========================================================

  static TransactionType? detect(List<String> tokens) {
    for (final token in tokens) {
      final normalized = token.trim().toLowerCase();

      if (_contains(ParserKeywords.incomeKeywords, normalized)) {
        return TransactionType.income;
      }

      if (_contains(ParserKeywords.expenseKeywords, normalized)) {
        return TransactionType.expense;
      }
    }

    return null;
  }

  // ==========================================================
  // Is Income
  // ==========================================================

  static bool isIncome(List<String> tokens) {
    return detect(tokens) == TransactionType.income;
  }

  // ==========================================================
  // Is Expense
  // ==========================================================

  static bool isExpense(List<String> tokens) {
    return detect(tokens) == TransactionType.expense;
  }

  // ==========================================================
  // Extract Matched Token
  // ==========================================================

  static String? extractToken(List<String> tokens) {
    for (final token in tokens) {
      final normalized = token.trim().toLowerCase();

      if (_contains(ParserKeywords.incomeKeywords, normalized) ||
          _contains(ParserKeywords.expenseKeywords, normalized)) {
        return token;
      }
    }

    return null;
  }

  // ==========================================================
  // Keyword Match
  // ==========================================================

  static bool _contains(List<String> keywords, String value) {
    return keywords.any((keyword) => keyword.toLowerCase() == value);
  }
}
