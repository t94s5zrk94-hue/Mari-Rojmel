import '../constants/keywords.dart';
import '../models/parsed_entry.dart';

class ParserService {
  ParserService._();

  static ParsedEntry? parse(String input) {
    final text = input.trim().toLowerCase();

    if (text.isEmpty) {
      return null;
    }

    final parts = text.split(RegExp(r'\s+'));

    if (parts.length < 2) {
      return null;
    }

    final amount = double.tryParse(parts.first);

    if (amount == null) {
      return null;
    }

    final keyword = parts.sublist(1).join(' ');

    final categoryId = categoryKeywords[keyword];

    if (categoryId == null) {
      return null;
    }

    // Temporary mapping until parser becomes database-driven.
    final isIncome = categoryId == 6 || categoryId == 7;

    return ParsedEntry(
      amount: amount,
      categoryId: categoryId,
      isIncome: isIncome,
      description: keyword,
    );
  }
}