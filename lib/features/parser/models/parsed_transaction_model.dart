// ===============================================================
// Mari-Rojmel
// Parsed Transaction Model
//
// Output model for Smart Transaction Parser.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import '../../categories/models/category_model.dart';
import '../../payment_modes/models/payment_mode_model.dart';
import '../../../core/enums/transaction_type.dart';

/// Transaction Type

/// Parsed Transaction Model
class ParsedTransactionModel {
  const ParsedTransactionModel({
    this.amount,
    this.transactionType,
    this.category,
    this.paymentMode,
    required this.description,
    required this.originalText,
    required this.confidence,
    this.isAmountDetected = false,
    this.isCategoryDetected = false,
    this.isPaymentDetected = false,
    this.isTypeDetected = false,
  });

  /// Amount
  final double? amount;

  /// Income / Expense
  final TransactionType? transactionType;

  /// Matched Category
  final CategoryModel? category;

  /// Matched Payment Mode
  final PaymentModeModel? paymentMode;

  /// Remaining Description
  final String description;

  /// Original User Input
  final String originalText;

  /// Parser Confidence (0–100)
  final double confidence;

  /// Detection Flags
  final bool isAmountDetected;
  final bool isCategoryDetected;
  final bool isPaymentDetected;
  final bool isTypeDetected;

  /// Complete Detection
  bool get isComplete =>
      amount != null &&
      category != null &&
      paymentMode != null &&
      transactionType != null;

  /// CopyWith
  ParsedTransactionModel copyWith({
    double? amount,
    TransactionType? transactionType,
    CategoryModel? category,
    PaymentModeModel? paymentMode,
    String? description,
    String? originalText,
    double? confidence,
    bool? isAmountDetected,
    bool? isCategoryDetected,
    bool? isPaymentDetected,
    bool? isTypeDetected,
  }) {
    return ParsedTransactionModel(
      amount: amount ?? this.amount,
      transactionType: transactionType ?? this.transactionType,
      category: category ?? this.category,
      paymentMode: paymentMode ?? this.paymentMode,
      description: description ?? this.description,
      originalText: originalText ?? this.originalText,
      confidence: confidence ?? this.confidence,
      isAmountDetected: isAmountDetected ?? this.isAmountDetected,
      isCategoryDetected: isCategoryDetected ?? this.isCategoryDetected,
      isPaymentDetected: isPaymentDetected ?? this.isPaymentDetected,
      isTypeDetected: isTypeDetected ?? this.isTypeDetected,
    );
  }

  @override
  String toString() {
    return '''
ParsedTransactionModel(
  amount: $amount,
  transactionType: $transactionType
  category: ${category?.name},
  payment: ${paymentMode?.name},
  description: $description,
  confidence: $confidence,
)
''';
  }
}
