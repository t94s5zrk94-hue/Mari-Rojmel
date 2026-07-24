/// ===============================================================
/// Mari-Rojmel
/// Emoji Search Engine
///
/// Provides search and filtering utilities for the shared emoji
/// database.
///
/// Version : v2.0
/// ===============================================================

import 'emoji_data.dart';
import 'emoji_model.dart';

class EmojiSearch {
  EmojiSearch._();

  /// All emojis
  static List<EmojiModel> get all => EmojiData.emojis;

  /// All group names
  static List<String> get groupNames {
    return EmojiData.emojis.map((e) => e.group).toSet().toList()..sort();
  }

  /// Emojis of a specific group
  static List<EmojiModel> getByGroup(String group) {
    return EmojiData.emojis.where((e) => e.group == group).toList();
  }

  /// Search emojis
  static List<EmojiModel> search(String query) {
    final value = query.trim();

    if (value.isEmpty) {
      return EmojiData.emojis;
    }

    return EmojiData.emojis.where((emoji) => emoji.matches(value)).toList();
  }

  /// Returns grouped emoji map
  static Map<String, List<EmojiModel>> get groupedEmojis {
    final Map<String, List<EmojiModel>> map = {};

    for (final emoji in EmojiData.emojis) {
      map.putIfAbsent(emoji.group, () => []);
      map[emoji.group]!.add(emoji);
    }

    return map;
  }

  /// Find emoji model by emoji character
  static EmojiModel? findByEmoji(String emoji) {
    for (final item in EmojiData.emojis) {
      if (item.emoji == emoji) {
        return item;
      }
    }
    return null;
  }

  /// Check whether emoji exists
  static bool contains(String emoji) {
    return EmojiData.emojis.any((e) => e.emoji == emoji);
  }
}
