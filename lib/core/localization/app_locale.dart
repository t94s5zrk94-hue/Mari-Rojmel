// ===============================================================
// Mari-Rojmel
// App Locale
//
// Supported application languages.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/material.dart';

enum AppLocale {
  english(
    code: 'en',
    locale: Locale('en'),
    displayName: 'English',
    nativeName: 'English',
  ),

  gujarati(
    code: 'gu',
    locale: Locale('gu'),
    displayName: 'Gujarati',
    nativeName: 'ગુજરાતી',
  );

  const AppLocale({
    required this.code,
    required this.locale,
    required this.displayName,
    required this.nativeName,
  });

  final String code;
  final Locale locale;
  final String displayName;
  final String nativeName;

  static AppLocale fromCode(String? code) {
    return values.firstWhere(
      (locale) => locale.code == code,
      orElse: () => AppLocale.english,
    );
  }
}
