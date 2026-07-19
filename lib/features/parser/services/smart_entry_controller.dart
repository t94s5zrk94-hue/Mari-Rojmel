// ===============================================================
// Mari-Rojmel
// Smart Entry Controller
//
// Connects UI with Transaction Parser.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================
import '../models/parsed_transaction_model.dart';
import 'transaction_parser.dart';

class SmartEntryController {
  final TransactionParser _parser;

  const SmartEntryController({required this._parser});

  /// Parses smart entry text and returns structured result.
  Future<ParsedTransactionModel> parse(String input) async {
    return _parser.parse(input);
  }

  /// Returns true if the input contains non-whitespace characters.
  bool canParse(String input) {
    return input.trim().isNotEmpty;
  }

  /// Clears the smart entry text.
  String clear() {
    return '';
  }
}
