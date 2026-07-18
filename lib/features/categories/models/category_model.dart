import 'dart:convert';
import '../../../core/enums/transaction_type.dart';

/// Category Model
///
/// SQLite Table Columns:
///
/// id
/// name
/// icon
/// color
/// transaction_type
/// is_default
/// is_active
/// sort_order
class CategoryModel {
  const CategoryModel({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.transactionType,
    this.isDefault = false,
    this.isActive = true,
    this.sortOrder = 0,
  });

  final int? id;
  final String name;
  final String icon;
  final int color;
  final TransactionType transactionType;
  final bool isDefault;
  final bool isActive;
  final int sortOrder;

  /// Empty Model
  factory CategoryModel.empty() {
    return const CategoryModel(
      id: null,
      name: '',
      icon: 'category',
      color: 0xFF2196F3,
      transactionType: TransactionType.expense,
      isDefault: false,
      isActive: true,
      sortOrder: 0,
    );
  }

  /// Copy With
  CategoryModel copyWith({
    int? id,
    String? name,
    String? icon,
    int? color,
    TransactionType? transactionType,
    bool? isDefault,
    bool? isActive,
    int? sortOrder,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      transactionType: transactionType ?? this.transactionType,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// SQLite Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name.trim(),
      'icon': icon,
      'color': color,
      'transaction_type': transactionType.value,
      'is_default': isDefault ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'sort_order': sortOrder,
    };
  }

  /// SQLite Map
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: (map['name'] ?? '').toString(),
      icon: (map['icon'] ?? 'category').toString(),
      color: (map['color'] ?? 0xFF2196F3) as int,
      transactionType: TransactionType.fromString(
        map['transaction_type']?.toString(),
      ),
      isDefault: (map['is_default'] ?? 0) == 1,
      isActive: (map['is_active'] ?? 1) == 1,
      sortOrder: (map['sort_order'] ?? 0) as int,
    );
  }

  /// JSON
  String toJson() => jsonEncode(toMap());

  /// JSON
  factory CategoryModel.fromJson(String source) {
    return CategoryModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }

  /// Validation

  bool get hasId => id != null;

  bool get isIncome => transactionType == TransactionType.income;

  bool get isExpense => transactionType == TransactionType.expense;

  bool get isNameValid => name.trim().isNotEmpty;

  bool get canDelete => !isDefault;

  bool get canEdit => true;

  bool get isEnabled => isActive;

  CategoryModel normalized() {
    return copyWith(name: name.trim(), icon: icon.trim());
  }

  @override
  String toString() {
    return 'CategoryModel('
        'id: $id, '
        'name: $name, '
        'icon: $icon, '
        'color: $color, '
        'transactionType: ${transactionType.value}, '
        'isDefault: $isDefault, '
        'isActive: $isActive, '
        'sortOrder: $sortOrder'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.color == color &&
        other.transactionType == transactionType &&
        other.isDefault == isDefault &&
        other.isActive == isActive &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      icon,
      color,
      transactionType,
      isDefault,
      isActive,
      sortOrder,
    );
  }
}
