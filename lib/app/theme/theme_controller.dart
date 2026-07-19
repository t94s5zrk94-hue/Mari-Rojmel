// ===============================================================
// Mari-Rojmel
// Theme Controller
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/material.dart';

import '../../core/database/database_helper.dart';
import '../../features/settings/models/app_settings_model.dart';
import '../../features/settings/repositories/settings_repository.dart';
import '../../features/settings/services/settings_service.dart';

class ThemeController extends ChangeNotifier {
  ThemeController();

  final SettingsService _service = SettingsService(
    SettingsRepository(DatabaseHelper.instance),
  );

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> initialize() async {
    final settings = await _service.getSettings();

    setTheme(settings.themeMode, notify: false);
  }

  void setTheme(AppThemeMode mode, {bool notify = true}) {
    switch (mode) {
      case AppThemeMode.system:
        _themeMode = ThemeMode.system;
        break;

      case AppThemeMode.light:
        _themeMode = ThemeMode.light;
        break;

      case AppThemeMode.dark:
        _themeMode = ThemeMode.dark;
        break;
    }

    if (notify) {
      notifyListeners();
    }
  }
}
