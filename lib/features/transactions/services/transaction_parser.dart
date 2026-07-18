// ===============================================================
// Mari-Rojmel
// Smart Transaction Parser
//
// Production Ready
// ===============================================================

import 'package:mari_rojmel_app/features/payment_modes/models/payment_mode_model.dart';

import '../models/parsed_transaction_model.dart';
import '../repositories/transaction_learning_repository.dart';
import '../../categories/repositories/category_repository.dart';
import '../../categories/models/category_model.dart';
import 'amount_parser.dart';
import 'date_parser.dart';

class TransactionParser {
  TransactionParser({
    required this._learningRepository,
    required this._categoryRepository,
  });

  final TransactionLearningRepository _learningRepository;
  final CategoryRepository _categoryRepository;

  PaymentModeModel? paymentMode;

  /// Parse Quick Entry
  Future<ParsedTransactionModel> parse(String input) async {
    final text = input.trim();

    if (text.isEmpty) {
      return ParsedTransactionModel(transactionDate: DateTime.now());
    }

    // -----------------------------
    // Amount
    // -----------------------------

    final amount = AmountParser.parse(text);

    // -----------------------------
    // Payment Mode
    // -----------------------------

    //final paymentMode = PaymentModeParser.parse(text);

    // -----------------------------
    // Date
    // -----------------------------

    final transactionDate = DateParser.parse(text);

    // -----------------------------
    // Remaining Text
    // -----------------------------

    var remaining = text;

    // Remove amount
    if (amount != null) {
      remaining = remaining.replaceFirst(RegExp(r'(\d[\d,]*\.?\d*)'), '');
    }

    // Remove payment mode words
    const paymentWords = [
      'cash',
      'upi',
      'gpay',
      'google pay',
      'googlepay',
      'phonepe',
      'phone pe',
      'paytm',
      'bank',
      'card',
      'cheque',
    ];

    for (final word in paymentWords) {
      remaining = remaining.replaceAll(RegExp(word, caseSensitive: false), '');
    }

    // Remove today / yesterday

    remaining = remaining.replaceAll(
      RegExp('today|yesterday', caseSensitive: false),
      '',
    );

    remaining = remaining.trim();

    // -----------------------------
    // Learning Lookup
    // -----------------------------

    final learning = await _learningRepository.findByKeyword(remaining);

    // -----------------------------
    // Resolve Category
    // -----------------------------

    CategoryModel? category;

    if (learning != null) {
      category = await _categoryRepository.getById(learning.categoryId);
    }

    return ParsedTransactionModel(
      amount: amount,
      category: category,
      transactionDate: transactionDate,
      paymentMode: paymentMode,
      note: remaining,
      confidence: learning == null ? 0.30 : 1.00,
      isCategoryLearned: learning != null,
    );
  }
}
