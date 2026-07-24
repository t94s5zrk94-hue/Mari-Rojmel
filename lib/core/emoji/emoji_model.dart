/// ===============================================================
/// Mari-Rojmel
/// Emoji Model
///
/// Shared emoji model used across the application.
///
/// Used by:
/// • Categories
/// • Payment Modes
/// • Accounts
/// • Budgets (Future)
/// • Tags (Future)
///
/// Version : v2.0
/// ===============================================================

import 'package:flutter/foundation.dart';

@immutable
class EmojiModel {
  /// Actual emoji character.
  final String emoji;

  /// Display name.
  final String name;

  /// Search keywords.
  final List<String> keywords;

  /// Group name.
  ///
  /// Examples:
  /// Finance
  /// Food
  /// Transport
  /// Health
  final String group;

  const EmojiModel({
    required this.emoji,
    required this.name,
    required this.keywords,
    required this.group,
  });

  bool matches(String query) {
    final value = query.trim().toLowerCase();

    if (value.isEmpty) return true;

    if (name.toLowerCase().contains(value)) {
      return true;
    }

    if (group.toLowerCase().contains(value)) {
      return true;
    }

    return keywords.any((keyword) => keyword.toLowerCase().contains(value));
  }

  @override
  String toString() => '$emoji $name';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmojiModel &&
          runtimeType == other.runtimeType &&
          emoji == other.emoji;

  @override
  int get hashCode => emoji.hashCode;
}
