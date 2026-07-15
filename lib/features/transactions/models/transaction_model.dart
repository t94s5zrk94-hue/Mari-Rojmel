import 'dart:convert';

/// Transaction Type
enum TransactionType {
  income,
  expense,
}

/// Transaction Model
///
/// Production-ready immutable model.
/// Used for SQLite persistence and UI.
class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.amount,
    required this.transactionType,
    required this.categoryId,
    required this.paymentModeId,
    required this.transactionDate,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  }) : assert(
          amount >= 0,
          'Amount cannot be negative.',
        );

  /// SQLite Auto Increment ID
  final int? id;

  /// Transaction Amount
  final double amount;

  /// Income / Expense
  final TransactionType transactionType;

  /// FK → Category
  final int categoryId;

  /// FK → Payment Mode
  final int paymentModeId;

  /// Date & Time of transaction
  final DateTime transactionDate;

  /// Optional Note
  final String note;

  /// Record Created Time
  final DateTime createdAt;

  /// Record Updated Time
  final DateTime updatedAt;

  /// Soft Delete Flag
  final bool isDeleted;

  /// Empty Model
  factory TransactionModel.empty() {
    final now = DateTime.now();

    return TransactionModel(
      id: null,
      amount: 0,
      transactionType: TransactionType.expense,
      categoryId: 0,
      paymentModeId: 0,
      transactionDate: now,
      note: '',
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );
  }
    /// Returns a new TransactionModel with updated values.
  TransactionModel copyWith({
    int? id,
    double? amount,
    TransactionType? transactionType,
    int? categoryId,
    int? paymentModeId,
    DateTime? transactionDate,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      transactionType: transactionType ?? this.transactionType,
      categoryId: categoryId ?? this.categoryId,
      paymentModeId: paymentModeId ?? this.paymentModeId,
      transactionDate: transactionDate ?? this.transactionDate,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  /// Convert model to SQLite map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'transaction_type': transactionType.name,
      'category_id': 0,
      'payment_mode_id': 0,
      'transaction_date': transactionDate.toIso8601String(),
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_deleted': isDeleted ? 1 : 0,
    };
  }

  /// Create model from SQLite map.
  factory TransactionModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return TransactionModel(
      id: map['id'] as int?,
      amount: (map['amount'] as num).toDouble(),
      transactionType: TransactionType.values.firstWhere(
        (e) => e.name == map['transaction_type'],
      ),
      categoryId: map['category_id'] as int,
      paymentModeId: map['payment_mode_id'] as int,
      transactionDate: DateTime.parse(
        map['transaction_date'] as String,
      ),
      note: (map['note'] as String?) ?? '',
      createdAt: DateTime.parse(
        map['created_at'] as String,
      ),
      updatedAt: DateTime.parse(
        map['updated_at'] as String,
      ),
      isDeleted: (map['is_deleted'] as int? ?? 0) == 1,
    );
  }

  /// Convert model to JSON.
  String toJson() => jsonEncode(toMap());

  /// Create model from JSON.
  factory TransactionModel.fromJson(
    String source,
  ) {
    return TransactionModel.fromMap(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }
    /// Returns true if transaction is Income.
  bool get isIncome =>
      transactionType == TransactionType.income;

  /// Returns true if transaction is Expense.
  bool get isExpense =>
      transactionType == TransactionType.expense;

  @override
  String toString() {
    return 'TransactionModel('
        'id: $id, '
        'amount: $amount, '
        'transactionType: ${transactionType.name}, '
        'categoryId: $categoryId, '
        'paymentModeId: $paymentModeId, '
        'transactionDate: $transactionDate, '
        'note: $note, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'isDeleted: $isDeleted'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is TransactionModel &&
        other.id == id &&
        other.amount == amount &&
        other.transactionType == transactionType &&
        other.categoryId == categoryId &&
        other.paymentModeId == paymentModeId &&
        other.transactionDate == transactionDate &&
        other.note == note &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isDeleted == isDeleted;
  }

  @override
  int get hashCode => Object.hash(
        id,
        amount,
        transactionType,
        categoryId,
        paymentModeId,
        transactionDate,
        note,
        createdAt,
        updatedAt,
        isDeleted,
      );
}