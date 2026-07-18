// ===============================================================
// Mari-Rojmel
// Settings Service
//
// Application Settings using SharedPreferences
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService._();

  static final SettingsService instance = SettingsService._();

  // ==========================================================
  // SharedPreferences Keys
  // ==========================================================

  static const String _languageKey = 'language';

  static const String _currencyKey = 'currency';

  static const String _darkModeKey = 'dark_mode';

  static const String _appLockKey = 'app_lock';

  static const String _biometricKey = 'biometric';

  // ==========================================================
  // Default Values
  // ==========================================================

  static const String defaultLanguage = 'gu';

  static const String defaultCurrency = 'INR';

  static const bool defaultDarkMode = false;

  static const bool defaultAppLock = false;

  static const bool defaultBiometric = false;

  // ==========================================================
  // SharedPreferences Instance
  // ==========================================================

  Future<SharedPreferences> get _preferences async {
    return SharedPreferences.getInstance();
  }
  // ==========================================================
  // Language
  // ==========================================================

  Future<void> setLanguage(String languageCode) async {
    final preferences = await _preferences;

    await preferences.setString(_languageKey, languageCode.trim());
  }

  Future<String> getLanguage() async {
    final preferences = await _preferences;

    return preferences.getString(_languageKey) ?? defaultLanguage;
  }

  // ==========================================================
  // Currency
  // ==========================================================

  Future<void> setCurrency(String currency) async {
    final preferences = await _preferences;

    await preferences.setString(_currencyKey, currency.trim().toUpperCase());
  }

  Future<String> getCurrency() async {
    final preferences = await _preferences;

    return preferences.getString(_currencyKey) ?? defaultCurrency;
  }
  // ==========================================================
  // Dark Mode
  // ==========================================================

  Future<void> setDarkMode(bool enabled) async {
    final preferences = await _preferences;

    await preferences.setBool(_darkModeKey, enabled);
  }

  Future<bool> isDarkMode() async {
    final preferences = await _preferences;

    return preferences.getBool(_darkModeKey) ?? defaultDarkMode;
  }

  // ==========================================================
  // App Lock
  // ==========================================================

  Future<void> setAppLock(bool enabled) async {
    final preferences = await _preferences;

    await preferences.setBool(_appLockKey, enabled);
  }

  Future<bool> isAppLockEnabled() async {
    final preferences = await _preferences;

    return preferences.getBool(_appLockKey) ?? defaultAppLock;
  }

  // ==========================================================
  // Biometric
  // ==========================================================

  Future<void> setBiometric(bool enabled) async {
    final preferences = await _preferences;

    await preferences.setBool(_biometricKey, enabled);
  }

  Future<bool> isBiometricEnabled() async {
    final preferences = await _preferences;

    return preferences.getBool(_biometricKey) ?? defaultBiometric;
  }
  // ==========================================================
  // Reset Settings
  // ==========================================================

  Future<void> reset() async {
    final preferences = await _preferences;

    await preferences.remove(_languageKey);
    await preferences.remove(_currencyKey);
    await preferences.remove(_darkModeKey);
    await preferences.remove(_appLockKey);
    await preferences.remove(_biometricKey);
  }
}
