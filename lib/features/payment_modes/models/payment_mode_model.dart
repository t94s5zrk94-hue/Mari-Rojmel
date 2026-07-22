import 'package:flutter/foundation.dart';

@immutable
class PaymentModeModel {
  const PaymentModeModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.isDefault,
    required this.isActive,
    required this.sortOrder,
    required this.color,
  });

  final int? id;
  final String name;
  final String icon;
  final bool isDefault;
  final bool isActive;
  final int sortOrder;
  final int color;

  PaymentModeModel copyWith({
    int? id,
    String? name,
    String? icon,
    bool? isDefault,
    bool? isActive,
    int? sortOrder,
    int? color,
  }) {
    return PaymentModeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      color: color ?? this.color,
    );
  }

  factory PaymentModeModel.fromMap(Map<String, dynamic> map) {
    return PaymentModeModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      icon: (map['icon'] ?? '💳') as String,
      isDefault: (map['is_default'] ?? 0) == 1,
      isActive: (map['is_active'] ?? 1) == 1,
      sortOrder: (map['sort_order'] ?? 0) as int,
      color: map['color'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'is_default': isDefault ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'sort_order': sortOrder,
      'color': color,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PaymentModeModel &&
        other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.isDefault == isDefault &&
        other.isActive == isActive &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode =>
      Object.hash(id, name, icon, isDefault, isActive, sortOrder);

  @override
  String toString() {
    return 'PaymentModeModel('
        'id: $id, '
        'name: $name, '
        'icon: $icon, '
        'isDefault: $isDefault, '
        'isActive: $isActive, '
        'sortOrder: $sortOrder'
        ')';
  }
}
