/// ===============================================================
/// Mari-Rojmel
/// Payment Mode Parser
///
/// Detects payment mode from Quick Entry text.
///
/// Examples:
///
/// 500 Milk Cash
/// 500 Petrol UPI
/// 1200 Salary Bank
/// 450 Grocery PhonePe
/// 800 GPay
/// 1500 Google Pay
///
/// ===============================================================

// ignore_for_file: dangling_library_doc_comments

class PaymentModeParser {
  const PaymentModeParser._();

  static const List<String> _cashKeywords = ['cash', 'rokda', 'રોકડા'];

  static const List<String> _upiKeywords = [
    'upi',
    'gpay',
    'google pay',
    'phonepe',
    'phone pe',
    'paytm',
    'bhim',
  ];

  static const List<String> _bankKeywords = [
    'bank',
    'neft',
    'rtgs',
    'imps',
    'transfer',
  ];

  static const List<String> _cardKeywords = [
    'card',
    'credit card',
    'debit card',
    'visa',
    'mastercard',
    'rupay',
  ];

  /// Returns detected payment mode.
  ///
  /// Possible values:
  ///
  /// Cash
  /// UPI
  /// Bank
  /// Card
  ///
  /// Returns null if nothing is detected.
  static String? parse(String input) {
    final text = input.trim().toLowerCase();

    if (text.isEmpty) {
      return null;
    }

    if (_containsAny(text, _upiKeywords)) {
      return 'UPI';
    }

    if (_containsAny(text, _bankKeywords)) {
      return 'Bank';
    }

    if (_containsAny(text, _cardKeywords)) {
      return 'Card';
    }

    if (_containsAny(text, _cashKeywords)) {
      return 'Cash';
    }

    return null;
  }

  /// Removes payment keywords from input.
  static String removePaymentMode(String input) {
    String result = input;

    for (final keyword in [
      ..._upiKeywords,
      ..._bankKeywords,
      ..._cardKeywords,
      ..._cashKeywords,
    ]) {
      result = result.replaceAll(RegExp(keyword, caseSensitive: false), '');
    }

    return result.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static bool _containsAny(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        return true;
      }
    }

    return false;
  }
}
