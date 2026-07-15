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
  });

  final String id;
  final String name;
  final String icon;
  final bool isDefault;
  final bool isActive;
  final int sortOrder;

  PaymentModeModel copyWith({
    String? id,
    String? name,
    String? icon,
    bool? isDefault,
    bool? isActive,
    int? sortOrder,
  }) {
    return PaymentModeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  factory PaymentModeModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return PaymentModeModel(
      id: map['payment_mode_id'] as String,
      name: map['payment_mode_name'] as String,
      icon: (map['icon'] ?? '💳') as String,
      isDefault: (map['is_default'] ?? 0) == 1,
      isActive: (map['is_active'] ?? 1) == 1,
      sortOrder: (map['sort_order'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payment_mode_id': id,
      'payment_mode_name': name,
      'icon': icon,
      'is_default': isDefault ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'sort_order': sortOrder,
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
  int get hashCode => Object.hash(
        id,
        name,
        icon,
        isDefault,
        isActive,
        sortOrder,
      );

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