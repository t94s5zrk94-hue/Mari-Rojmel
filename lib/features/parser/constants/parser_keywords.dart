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

  static const List<String> cashKeywords = ['cash', 'Cash', 'રોકડ', 'કેશ'];

  // ==========================================================
  // UPI Keywords
  // ==========================================================

  static const List<String> upiKeywords = [
    'upi',
    'UPI',
    'gpay',
    'GPay',
    'googlepay',
    'GooglePay',
    'phonepe',
    'PhonePe',
    'paytm',
    'Paytm',
    'bhim',
    'BHIM',
  ];

  // ==========================================================
  // Bank Keywords
  // ==========================================================

  static const List<String> bankKeywords = [
    'bank',
    'Bank',
    'બેંક',
    'account',
    'Account',
    'transfer',
    'Transfer',
    'neft',
    'rtgs',
    'imps',
  ];

  // ==========================================================
  // Card Keywords
  // ==========================================================

  static const List<String> cardKeywords = [
    'card',
    'Card',
    'credit card',
    'debit card',
    'ક્રેડિટ કાર્ડ',
    'ડેબિટ કાર્ડ',
  ];
}
