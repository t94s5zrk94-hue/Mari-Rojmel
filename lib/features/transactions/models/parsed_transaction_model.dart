// ===============================================================
// Mari-Rojmel
// Parsed Transaction Model
//
// Contract between Parser and UI
// ===============================================================

import '../../categories/models/category_model.dart';
import '../../payment_modes/models/payment_mode_model.dart';

class ParsedTransactionModel {
  const ParsedTransactionModel({
    this.amount,
    this.category,
    this.paymentMode,
    required this.transactionDate,
    this.note = '',
    this.confidence = 0.0,
    this.isCategoryLearned = false,
  });

  /// Parsed amount
  final double? amount;

  /// Selected category
  final CategoryModel? category;

  /// Selected payment mode
  final PaymentModeModel? paymentMode;

  /// Transaction date
  final DateTime transactionDate;

  /// Remaining description
  final String note;

  /// Parser confidence (0.0 - 1.0)
  final double confidence;

  /// Category came from learning engine?
  final bool isCategoryLearned;

  ParsedTransactionModel copyWith({
    double? amount,
    CategoryModel? category,
    PaymentModeModel? paymentMode,
    DateTime? transactionDate,
    String? note,
    double? confidence,
    bool? isCategoryLearned,
  }) {
    return ParsedTransactionModel(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      paymentMode: paymentMode ?? this.paymentMode,
      transactionDate: transactionDate ?? this.transactionDate,
      note: note ?? this.note,
      confidence: confidence ?? this.confidence,
      isCategoryLearned: isCategoryLearned ?? this.isCategoryLearned,
    );
  }

  @override
  String toString() {
    return '''
ParsedTransactionModel(
  amount: $amount,
  category: ${category?.name},
  paymentMode: ${paymentMode?.name},
  transactionDate: $transactionDate,
  note: $note,
  confidence: $confidence,
  learned: $isCategoryLearned
)
''';
  }
}
