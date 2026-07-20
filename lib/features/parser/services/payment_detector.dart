// ===============================================================
// Mari-Rojmel
// Payment Detector
//
// Detects payment mode from tokenized transaction input.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import '../constants/parser_keywords.dart';

enum DetectedPaymentType {
  cash,
  upi,
  bank,
  debitCard,
  creditCard,
  cheque,
  unknown,
}

class PaymentDetector {
  const PaymentDetector._();

  // ==========================================================
  // Detect Payment Type
  // ==========================================================

  static DetectedPaymentType detect(List<String> tokens) {
    for (final token in tokens) {
      final normalized = token.trim().toLowerCase();

      // Credit Card
      if (_contains(ParserKeywords.creditCardKeywords, normalized)) {
        return DetectedPaymentType.creditCard;
      }

      // Debit Card
      if (_contains(ParserKeywords.debitCardKeywords, normalized)) {
        return DetectedPaymentType.debitCard;
      }

      // UPI
      if (_contains(ParserKeywords.upiKeywords, normalized)) {
        return DetectedPaymentType.upi;
      }

      // Bank Transfer
      if (_contains(ParserKeywords.bankKeywords, normalized)) {
        return DetectedPaymentType.bank;
      }

      // Cheque
      if (_contains(ParserKeywords.chequeKeywords, normalized)) {
        return DetectedPaymentType.cheque;
      }

      // Cash
      if (_contains(ParserKeywords.cashKeywords, normalized)) {
        return DetectedPaymentType.cash;
      }
    }

    return DetectedPaymentType.unknown;
  }

  // ==========================================================
  // Has Payment
  // ==========================================================

  static bool hasPayment(List<String> tokens) {
    return detect(tokens) != DetectedPaymentType.unknown;
  }

  // ==========================================================
  // Extract Payment Token
  // ==========================================================

  static String? extractToken(List<String> tokens) {
    for (final token in tokens) {
      final normalized = token.trim().toLowerCase();

      if (_contains(ParserKeywords.creditCardKeywords, normalized) ||
          _contains(ParserKeywords.debitCardKeywords, normalized) ||
          _contains(ParserKeywords.upiKeywords, normalized) ||
          _contains(ParserKeywords.bankKeywords, normalized) ||
          _contains(ParserKeywords.chequeKeywords, normalized) ||
          _contains(ParserKeywords.cashKeywords, normalized)) {
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
