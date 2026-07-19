// ===============================================================
// Mari-Rojmel
// Settings Service
//
// Business Logic Layer for Application Settings
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import '../models/app_settings_model.dart';
import '../repositories/settings_repository.dart';

class SettingsService {
  SettingsService(this._repository);

  final ISettingsRepository _repository;

  // ==========================================================
  // Get Settings
  // ==========================================================

  Future<AppSettingsModel> getSettings() async {
    if (!await _repository.hasSettings()) {
      await initializeDefaultSettings();
    }

    return _repository.getSettings();
  }

  // ==========================================================
  // Initialize Default Settings
  // ==========================================================

  Future<void> initializeDefaultSettings() async {
    if (await _repository.hasSettings()) {
      return;
    }

    final now = DateTime.now();

    final settings = AppSettingsModel(
      themeMode: AppThemeMode.system,
      language: AppLanguage.gujarati,
      currencySymbol: '₹',
      dateFormat: DateFormatType.ddMMyyyy,
      notificationsEnabled: true,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.saveSettings(settings);
  }

  // ==========================================================
  // Save
  // ==========================================================

  Future<void> saveSettings(AppSettingsModel settings) async {
    if (await _repository.hasSettings()) {
      await _repository.updateSettings(settings);
    } else {
      await _repository.saveSettings(settings);
    }
  }

  // ==========================================================
  // Update Theme
  // ==========================================================

  Future<void> updateTheme(AppThemeMode theme) async {
    final settings = await getSettings();

    await saveSettings(settings.copyWith(themeMode: theme));
  }

  // ==========================================================
  // Update Language
  // ==========================================================

  Future<void> updateLanguage(AppLanguage language) async {
    final settings = await getSettings();

    await saveSettings(settings.copyWith(language: language));
  }

  // ==========================================================
  // Update Currency
  // ==========================================================

  Future<void> updateCurrency(String currencySymbol) async {
    final settings = await getSettings();

    await saveSettings(settings.copyWith(currencySymbol: currencySymbol));
  }

  // ==========================================================
  // Update Date Format
  // ==========================================================

  Future<void> updateDateFormat(DateFormatType format) async {
    final settings = await getSettings();

    await saveSettings(settings.copyWith(dateFormat: format));
  }

  // ==========================================================
  // Update Notifications
  // ==========================================================

  Future<void> updateNotifications(bool enabled) async {
    final settings = await getSettings();

    await saveSettings(settings.copyWith(notificationsEnabled: enabled));
  }
}
