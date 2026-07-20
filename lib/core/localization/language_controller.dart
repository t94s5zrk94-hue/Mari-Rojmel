// ===============================================================
// Mari-Rojmel
// Language Controller
//
// Controls current application language.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/foundation.dart';

import 'app_locale.dart';
import 'language_repository.dart';
import 'language_state.dart';

class LanguageController extends ChangeNotifier {
  LanguageController({LanguageRepository? repository})
    : _repository = repository ?? const LanguageRepository();

  final LanguageRepository _repository;

  LanguageState _state = const LanguageState(appLocale: AppLocale.english);

  LanguageState get state => _state;

  AppLocale get appLocale => _state.appLocale;

  Future<void> initialize() async {
    final locale = await _repository.loadLanguage();

    _state = _state.copyWith(appLocale: locale);

    notifyListeners();
  }

  Future<void> changeLanguage(AppLocale locale) async {
    if (locale == _state.appLocale) {
      return;
    }

    await _repository.saveLanguage(locale);

    _state = _state.copyWith(appLocale: locale);

    notifyListeners();
  }

  Future<void> reset() async {
    await _repository.clearLanguage();

    _state = const LanguageState(appLocale: AppLocale.english);

    notifyListeners();
  }
}
