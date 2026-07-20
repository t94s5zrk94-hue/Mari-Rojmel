// ===============================================================
// Mari-Rojmel
// Language State
//
// Immutable language state.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/material.dart';

import 'app_locale.dart';

@immutable
class LanguageState {
  const LanguageState({required this.appLocale});

  final AppLocale appLocale;

  Locale get locale => appLocale.locale;

  String get languageCode => appLocale.code;

  bool get isEnglish => appLocale == AppLocale.english;

  bool get isGujarati => appLocale == AppLocale.gujarati;

  LanguageState copyWith({AppLocale? appLocale}) {
    return LanguageState(appLocale: appLocale ?? this.appLocale);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LanguageState &&
            runtimeType == other.runtimeType &&
            appLocale == other.appLocale;
  }

  @override
  int get hashCode => appLocale.hashCode;

  @override
  String toString() {
    return 'LanguageState(appLocale: $appLocale)';
  }
}
