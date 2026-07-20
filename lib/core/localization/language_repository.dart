// ===============================================================
// Mari-Rojmel
// Language Repository
//
// Handles persistent language storage.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:shared_preferences/shared_preferences.dart';

import 'app_locale.dart';

class LanguageRepository {
  const LanguageRepository();

  static const String _languageKey = 'app_language';

  Future<AppLocale> loadLanguage() async {
    final preferences = await SharedPreferences.getInstance();

    final code = preferences.getString(_languageKey);

    return AppLocale.fromCode(code);
  }

  Future<void> saveLanguage(AppLocale locale) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_languageKey, locale.code);
  }

  Future<void> clearLanguage() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_languageKey);
  }

  Future<bool> hasSavedLanguage() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.containsKey(_languageKey);
  }
}
