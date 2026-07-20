// ===============================================================
// Mari-Rojmel
// Parser Keywords
//
// Central keyword dictionary for Smart Transaction Parser.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

class ParserKeywords {
  const ParserKeywords._();

  // ==========================================================
  // Currency Symbols
  // ==========================================================

  static const List<String> currencySymbols = [
    '₹',
    'Rs',
    'RS',
    'rs',
    'INR',
    'inr',
  ];

  // ==========================================================
  // Income Keywords
  // ==========================================================

  static const List<String> incomeKeywords = [
    'આવક',
    'પગાર',
    'સેલેરી',
    'વેતન',
    'કમાણી',
    'આવ્યું',
    'મળ્યા',
    'મળ્યું',
    'salary',
    'income',
    'credit',
    'received',
    'earning',
    'earn',
    'bonus',
    'commission',
    'refund',
  ];

  // ==========================================================
  // Expense Keywords
  // ==========================================================

  static const List<String> expenseKeywords = [
    'ખર્ચ',
    'આપ્યા',
    'આપી',
    'ચૂકવ્યું',
    'ખરીદી',
    'દવા',
    'ચા',
    'દૂધ',
    'ભાડું',
    'પેટ્રોલ',
    'expense',
    'paid',
    'purchase',
    'buy',
    'debit',
    'spent',
  ];

  // ==========================================================
  // Cash Keywords
  // ==========================================================

  static const List<String> cashKeywords = [
    'cash',
    'કેશ',
    'રોકડ',
    'રોકડા',
    'નગદ',
  ];

  // ==========================================================
  // UPI Keywords
  // ==========================================================

  static const List<String> upiKeywords = [
    'upi',
    'gpay',
    'googlepay',
    'google pay',
    'phonepe',
    'phone pe',
    'paytm',
    'bhim',
    'bharatpe',
  ];

  // ==========================================================
  // Bank Transfer Keywords
  // ==========================================================

  static const List<String> bankKeywords = [
    'bank',
    'બેંક',
    'account',
    'transfer',
    'bank transfer',
    'online transfer',
    'neft',
    'rtgs',
    'imps',
    'netbanking',
    'net banking',
  ];

  // ==========================================================
  // Debit Card Keywords
  // ==========================================================

  static const List<String> debitCardKeywords = [
    'debit',
    'debit card',
    'atm card',
    'ડેબિટ',
    'ડેબિટ કાર્ડ',
  ];

  // ==========================================================
  // Credit Card Keywords
  // ==========================================================

  static const List<String> creditCardKeywords = [
    'credit',
    'credit card',
    'ક્રેડિટ',
    'ક્રેડિટ કાર્ડ',
  ];

  // ==========================================================
  // Cheque Keywords
  // ==========================================================

  static const List<String> chequeKeywords = [
    'cheque',
    'check',
    'ચેક',
    'ચેકથી',
  ];
}
