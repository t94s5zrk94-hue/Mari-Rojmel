import 'package:flutter/material.dart';
import 'core/localization/language_controller.dart';
import 'app/app.dart';
import 'app/theme/theme_provider.dart';

final languageController = LanguageController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await themeController.initialize();
  await languageController.initialize();

  runApp(const MariRojmelApp());
}
