// ===============================================================
// Mari-Rojmel
// App Settings Model
//
// Stores application settings.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/foundation.dart';

@immutable
class AppSettingsModel {
  const AppSettingsModel({
    this.languageCode = 'gu',
    this.currencySymbol = '₹',
    this.currencyCode = 'INR',
    this.isDarkMode = false,
    this.isAppLockEnabled = false,
    this.isBiometricEnabled = false,
  });

  final String languageCode;
  final String currencySymbol;
  final String currencyCode;
  final bool isDarkMode;
  final bool isAppLockEnabled;
  final bool isBiometricEnabled;

  AppSettingsModel copyWith({
    String? languageCode,
    String? currencySymbol,
    String? currencyCode,
    bool? isDarkMode,
    bool? isAppLockEnabled,
    bool? isBiometricEnabled,
  }) {
    return AppSettingsModel(
      languageCode: languageCode ?? this.languageCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencyCode: currencyCode ?? this.currencyCode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isAppLockEnabled: isAppLockEnabled ?? this.isAppLockEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'language_code': languageCode,
      'currency_symbol': currencySymbol,
      'currency_code': currencyCode,
      'is_dark_mode': isDarkMode ? 1 : 0,
      'is_app_lock_enabled': isAppLockEnabled ? 1 : 0,
      'is_biometric_enabled': isBiometricEnabled ? 1 : 0,
    };
  }

  factory AppSettingsModel.fromMap(Map<String, Object?> map) {
    return AppSettingsModel(
      languageCode: map['language_code'] as String? ?? 'gu',
      currencySymbol: map['currency_symbol'] as String? ?? '₹',
      currencyCode: map['currency_code'] as String? ?? 'INR',
      isDarkMode: (map['is_dark_mode'] as int? ?? 0) == 1,
      isAppLockEnabled: (map['is_app_lock_enabled'] as int? ?? 0) == 1,
      isBiometricEnabled: (map['is_biometric_enabled'] as int? ?? 0) == 1,
    );
  }

  @override
  String toString() {
    return 'AppSettingsModel('
        'languageCode: $languageCode, '
        'currencySymbol: $currencySymbol, '
        'currencyCode: $currencyCode, '
        'isDarkMode: $isDarkMode, '
        'isAppLockEnabled: $isAppLockEnabled, '
        'isBiometricEnabled: $isBiometricEnabled'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppSettingsModel &&
        other.languageCode == languageCode &&
        other.currencySymbol == currencySymbol &&
        other.currencyCode == currencyCode &&
        other.isDarkMode == isDarkMode &&
        other.isAppLockEnabled == isAppLockEnabled &&
        other.isBiometricEnabled == isBiometricEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      languageCode,
      currencySymbol,
      currencyCode,
      isDarkMode,
      isAppLockEnabled,
      isBiometricEnabled,
    );
  }
}
