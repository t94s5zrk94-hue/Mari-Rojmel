// ===============================================================
// Mari-Rojmel
// Amount Detector
//
// Detects transaction amount from tokenized input.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

class AmountDetector {
  const AmountDetector._();

  // ==========================================================
  // Detect Amount
  // ==========================================================

  static double? detect(List<String> tokens) {
    for (final token in tokens) {
      final amount = _parseToken(token);

      if (amount != null) {
        return amount;
      }
    }

    return null;
  }

  // ==========================================================
  // Has Amount
  // ==========================================================

  static bool hasAmount(List<String> tokens) {
    return detect(tokens) != null;
  }

  // ==========================================================
  // Parse Token
  // ==========================================================

  static double? _parseToken(String token) {
    if (token.trim().isEmpty) {
      return null;
    }

    var value = token.trim();

    // Remove currency symbols
    value = value.replaceAll('₹', '');
    value = value.replaceAll('Rs.', '');
    value = value.replaceAll('Rs', '');
    value = value.replaceAll('rs.', '');
    value = value.replaceAll('rs', '');
    value = value.replaceAll('INR', '');
    value = value.replaceAll('inr', '');

    // Remove thousand separators
    value = value.replaceAll(',', '');

    // Keep only valid numeric characters
    value = value.replaceAll(RegExp(r'[^0-9.\-]'), '');

    if (value.isEmpty) {
      return null;
    }

    final amount = double.tryParse(value);

    if (amount == null) {
      return null;
    }

    if (amount == 0) {
      return null;
    }

    return amount;
  }

  // ==========================================================
  // Extract Amount Token
  // ==========================================================

  static String? extractToken(List<String> tokens) {
    for (final token in tokens) {
      if (_parseToken(token) != null) {
        return token;
      }
    }

    return null;
  }
}
