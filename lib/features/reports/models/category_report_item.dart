import 'package:flutter/foundation.dart';

@immutable
class CategoryReportItem {
  const CategoryReportItem({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.color,
    required this.amount,
    required this.transactionCount,
  });

  final int categoryId;
  final String name;
  final String icon;
  final int color;
  final double amount;
  final int transactionCount;

  CategoryReportItem copyWith({
    int? categoryId,
    String? name,
    String? icon,
    int? color,
    double? amount,
    int? transactionCount,
  }) {
    return CategoryReportItem(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      amount: amount ?? this.amount,
      transactionCount:
          transactionCount ?? this.transactionCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CategoryReportItem &&
        other.categoryId == categoryId &&
        other.name == name &&
        other.icon == icon &&
        other.color == color &&
        other.amount == amount &&
        other.transactionCount == transactionCount;
  }

  @override
  int get hashCode => Object.hash(
        categoryId,
        name,
        icon,
        color,
        amount,
        transactionCount,
      );
}