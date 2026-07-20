// ===============================================================
// Mari-Rojmel
// Transaction Parser
//
// Smart transaction parsing engine.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================
import '../../categories/repositories/category_repository.dart';
import 'amount_detector.dart';
import 'category_detector.dart';
import 'payment_detector.dart';
import '../../payment_modes/repositories/payment_mode_repository.dart';
import '../../payment_modes/services/payment_mode_detector.dart';
import 'tokenizer.dart';
import 'type_detector.dart';
import '../models/parsed_transaction_model.dart';
import '../../transactions/repositories/transaction_learning_repository.dart';

class TransactionParser {
  TransactionParser({
    required CategoryRepository categoryRepository,
    required PaymentModeRepository paymentModeRepository,
    required this._learningRepository,
  }) : _categoryDetector = CategoryDetector(categoryRepository),
       _paymentModeDetector = PaymentModeDetector(paymentModeRepository);
  final TransactionLearningRepository _learningRepository;
  final CategoryDetector _categoryDetector;
  final PaymentModeDetector _paymentModeDetector;
  Future<ParsedTransactionModel> parse(String input) async {
    final tokens = Tokenizer.tokenize(input);

    if (tokens.isEmpty) {
      return const ParsedTransactionModel(
        amount: null,
        transactionType: null,
        category: null,
        paymentMode: null,
        description: '',
        originalText: '',
        confidence: 0,
      );
    }

    // ----------------------------------------------------------
    // Amount
    // ----------------------------------------------------------

    final amount = AmountDetector.detect(tokens);

    // ----------------------------------------------------------
    // Transaction Type
    // ----------------------------------------------------------

    final transactionType = TypeDetector.detect(tokens);

    // ----------------------------------------------------------
    // Category
    // ----------------------------------------------------------

    final learning = await _learningRepository.findByKeywords(tokens);

    final category = learning != null
        ? await _categoryDetector.findById(learning.categoryId)
        : await _categoryDetector.detect(
            tokens,
            transactionType: transactionType,
          );
    // ----------------------------------------------------------
    // Payment Mode
    // ----------------------------------------------------------

    final paymentMode = await _paymentModeDetector.detect(tokens);
    // ----------------------------------------------------------
    // Confidence
    // ----------------------------------------------------------

    double confidence = 0.0;

    if (amount != null) confidence += 0.35;
    if (transactionType != null) confidence += 0.25;
    if (category != null) confidence += 0.30;
    if (PaymentDetector.hasPayment(tokens)) confidence += 0.10;

    if (confidence > 1.0) {
      confidence = 1.0;
    }

    // ----------------------------------------------------------
    // Result
    // ----------------------------------------------------------

    return ParsedTransactionModel(
      amount: amount,
      transactionType: transactionType,
      category: category,
      paymentMode: paymentMode,
      description: input.trim(),
      originalText: input,
      confidence: confidence * 100,
      isAmountDetected: amount != null,
      isCategoryDetected: category != null,
      isPaymentDetected: paymentMode != null,
      isTypeDetected: transactionType != null,
    );
  }
}
