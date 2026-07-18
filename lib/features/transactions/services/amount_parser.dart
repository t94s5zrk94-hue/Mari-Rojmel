/// ===============================================================
/// Mari-Rojmel
/// Amount Parser
///
/// Responsible for extracting transaction amount
/// from Quick Entry text.
///
/// Examples:
///
/// 500 Milk
/// ₹500 Milk
/// Rs.500 Milk
/// Milk 500
/// 1,250 Grocery
/// 1000.75 Salary
///
/// ===============================================================

// ignore_for_file: dangling_library_doc_comments

class AmountParser {
  const AmountParser._();

  static final RegExp _amountPattern = RegExp(r'(\d+(?:,\d{3})*(?:\.\d+)?)');

  /// Returns parsed amount.
  ///
  /// Returns null if amount is not found.
  static double? parse(String input) {
    final text = input.trim();

    if (text.isEmpty) {
      return null;
    }

    final cleaned = text
        .replaceAll('₹', '')
        .replaceAll('Rs.', '')
        .replaceAll('Rs', '')
        .replaceAll('INR', '')
        .trim();

    final match = _amountPattern.firstMatch(cleaned);

    if (match == null) {
      return null;
    }

    final value = match.group(1)!.replaceAll(',', '');

    return double.tryParse(value);
  }

  /// Returns true if valid amount exists.
  static bool hasAmount(String input) {
    return parse(input) != null;
  }

  /// Removes amount from input.
  ///
  /// Example:
  ///
  /// 500 Milk
  ///
  /// returns
  ///
  /// Milk
  static String removeAmount(String input) {
    final cleaned = input
        .replaceAll('₹', '')
        .replaceAll('Rs.', '')
        .replaceAll('Rs', '')
        .replaceAll('INR', '');

    return cleaned
        .replaceFirst(_amountPattern, '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
