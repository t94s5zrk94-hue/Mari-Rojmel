// ===============================================================
// Mari-Rojmel
// Tokenizer
//
// Converts raw transaction text into normalized tokens.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

class Tokenizer {
  const Tokenizer._();

  // ==========================================================
  // Tokenize
  // ==========================================================

  static List<String> tokenize(String input) {
    if (input.trim().isEmpty) {
      return const [];
    }

    var text = input.trim();

    // Normalize multiple spaces
    text = text.replaceAll(RegExp(r'\s+'), ' ');

    // Remove common currency symbols
    text = text.replaceAll('₹', '');
    text = text.replaceAll('Rs.', '');
    text = text.replaceAll('Rs', '');
    text = text.replaceAll('rs.', '');
    text = text.replaceAll('rs', '');
    text = text.replaceAll('INR', '');
    text = text.replaceAll('inr', '');

    // Remove thousand separators from numbers
    text = text.replaceAll(',', '');

    final tokens = text
        .split(' ')
        .map((token) => token.trim())
        .where((token) => token.isNotEmpty)
        .toList(growable: false);

    return tokens;
  }

  // ==========================================================
  // Normalize
  // ==========================================================

  static String normalize(String input) {
    return tokenize(input).join(' ');
  }

  // ==========================================================
  // Is Empty
  // ==========================================================

  static bool isEmpty(String input) {
    return tokenize(input).isEmpty;
  }
}
