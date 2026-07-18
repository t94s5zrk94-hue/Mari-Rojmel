// ===============================================================
// Mari-Rojmel
// Transaction Learning Model
//
// Production Ready
// ===============================================================

class TransactionLearningModel {
  const TransactionLearningModel({
    this.id,
    required this.keyword,
    required this.categoryId,
    this.useCount = 1,
    required this.lastUsedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;

  /// Learning Item
  /// Example:
  /// Mango
  /// Petrol
  /// Salary
  final String keyword;

  /// Linked Category Id
  final int categoryId;

  /// Number of times this mapping is used
  final int useCount;

  /// Last used timestamp
  final DateTime lastUsedAt;

  /// Created timestamp
  final DateTime createdAt;

  /// Updated timestamp
  final DateTime updatedAt;

  // ===============================================================
  // Copy With
  // ===============================================================

  TransactionLearningModel copyWith({
    int? id,
    String? keyword,
    int? categoryId,
    int? useCount,
    DateTime? lastUsedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionLearningModel(
      id: id ?? this.id,
      keyword: keyword ?? this.keyword,
      categoryId: categoryId ?? this.categoryId,
      useCount: useCount ?? this.useCount,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // ===============================================================
  // To Map
  // ===============================================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'keyword': keyword,
      'category_id': categoryId,
      'use_count': useCount,
      'last_used_at': lastUsedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // ===============================================================
  // From Map
  // ===============================================================

  factory TransactionLearningModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return TransactionLearningModel(
      id: map['id'] as int?,
      keyword: map['keyword'] as String,
      categoryId: map['category_id'] as int,
      useCount: map['use_count'] as int? ?? 1,
      lastUsedAt: DateTime.parse(
        map['last_used_at'] as String,
      ),
      createdAt: DateTime.parse(
        map['created_at'] as String,
      ),
      updatedAt: DateTime.parse(
        map['updated_at'] as String,
      ),
    );
  }

  // ===============================================================
  // JSON
  // ===============================================================

  Map<String, dynamic> toJson() => toMap();

  factory TransactionLearningModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransactionLearningModel.fromMap(json);
  }

  // ===============================================================
  // Equality
  // ===============================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionLearningModel &&
            other.id == id &&
            other.keyword == keyword &&
            other.categoryId == categoryId &&
            other.useCount == useCount &&
            other.lastUsedAt == lastUsedAt &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        keyword,
        categoryId,
        useCount,
        lastUsedAt,
        createdAt,
        updatedAt,
      );

  @override
  String toString() {
    return 'TransactionLearningModel('
        'id: $id, '
        'keyword: $keyword, '
        'categoryId: $categoryId, '
        'useCount: $useCount'
        ')';
  }
}