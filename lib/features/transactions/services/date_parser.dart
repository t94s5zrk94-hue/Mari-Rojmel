/// ===============================================================
/// Mari-Rojmel
/// Date Parser
///
/// Parses date from Quick Entry.
///
/// Supported:
///
/// Today
/// Yesterday
/// Tomorrow
///
/// 12/07
/// 12-07
/// 12/07/2026
/// 12-07-2026
///
/// If nothing is found,
/// returns today's date.
/// ===============================================================

// ignore_for_file: dangling_library_doc_comments

class DateParser {
  const DateParser._();

  static final RegExp _datePattern = RegExp(
    r'(\d{1,2})[\/\-](\d{1,2})(?:[\/\-](\d{2,4}))?',
  );

  static DateTime parse(String input) {
    final text = input.trim().toLowerCase();

    final now = DateTime.now();

    if (text.isEmpty) {
      return now;
    }

    if (text.contains('today')) {
      return now;
    }

    if (text.contains('yesterday')) {
      return now.subtract(const Duration(days: 1));
    }

    if (text.contains('tomorrow')) {
      return now.add(const Duration(days: 1));
    }

    final match = _datePattern.firstMatch(text);

    if (match == null) {
      return now;
    }

    final day = int.parse(match.group(1)!);

    final month = int.parse(match.group(2)!);

    final yearString = match.group(3);

    int year = now.year;

    if (yearString != null) {
      year = int.parse(yearString);

      if (year < 100) {
        year += 2000;
      }
    }

    try {
      return DateTime(year, month, day);
    } catch (_) {
      return now;
    }
  }

  static bool hasDate(String input) {
    final text = input.toLowerCase();

    return text.contains('today') ||
        text.contains('yesterday') ||
        text.contains('tomorrow') ||
        _datePattern.hasMatch(text);
  }

  static String removeDate(String input) {
    String result = input;

    result = result.replaceAll(RegExp(r'\btoday\b', caseSensitive: false), '');

    result = result.replaceAll(
      RegExp(r'\byesterday\b', caseSensitive: false),
      '',
    );

    result = result.replaceAll(
      RegExp(r'\btomorrow\b', caseSensitive: false),
      '',
    );

    result = result.replaceFirst(_datePattern, '');

    return result.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
