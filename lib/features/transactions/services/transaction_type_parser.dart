// ===============================================================
// Mari-Rojmel
// Transaction Type Parser
//
// Detects transaction type from Quick Entry text.
//
// Production Ready
// =============================================================
import '../../../core/enums/transaction_type.dart';

class TransactionTypeParser {
  const TransactionTypeParser._();

  // ---------------------------------------------------------------
  // Income Keywords
  // ---------------------------------------------------------------

  static const List<String> _incomeKeywords = [
    // English
    'salary',
    'income',
    'earning',
    'bonus',
    'commission',
    'interest',
    'refund',
    'cashback',
    'profit',
    'received',
    'credit',
    'rent received',
    'dividend',

    // Gujarati
    'પગાર',
    'આવક',
    'વ્યાજ',
    'બોનસ',
    'કમિશન',
    'નફો',
    'રિફંડ',
    'મળ્યા',
    'મળ્યું',
    'આવ્યું',
    'જમા થયા',
  ];

  // ---------------------------------------------------------------
  // Expense Keywords
  // ---------------------------------------------------------------

  static const List<String> _expenseKeywords = [
    // English
    'milk',
    'grocery',
    'groceries',
    'vegetable',
    'vegetables',
    'petrol',
    'diesel',
    'fuel',
    'medicine',
    'medical',
    'hospital',
    'doctor',
    'rent',
    'bill',
    'shopping',
    'recharge',
    'electricity',
    'water',
    'gas',
    'fee',
    'purchase',
    'expense',
    'paid',
    'payment',

    // Gujarati
    'દૂધ',
    'શાક',
    'ભાજી',
    'પેટ્રોલ',
    'ડીઝલ',
    'ઇંધણ',
    'દવા',
    'હોસ્પિટલ',
    'ડોક્ટર',
    'ભાડું',
    'લાઈટ બિલ',
    'વીજળી',
    'પાણી',
    'ગેસ',
    'રિચાર્જ',
    'ખરીદી',
    'ખર્ચ',
    'ચૂકવ્યું',
    'આપ્યા',
    'આપી',
  ];

  // ---------------------------------------------------------------
  // Parse
  // ---------------------------------------------------------------

  static TransactionType? parse(String input) {
    final text = _normalize(input);

    if (text.isEmpty) {
      return null;
    }

    if (_containsAny(text, _incomeKeywords)) {
      return TransactionType.income;
    }

    if (_containsAny(text, _expenseKeywords)) {
      return TransactionType.expense;
    }

    return null;
  }

  // ---------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------

  static bool _containsAny(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  static String _normalize(String input) {
    return input.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }
}
