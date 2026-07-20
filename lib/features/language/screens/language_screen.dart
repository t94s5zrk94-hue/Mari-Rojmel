// ===============================================================
// Mari-Rojmel
// Language Screen
//
// Application language selection.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/material.dart';

import '../../../core/localization/app_locale.dart';
import '../../../main.dart';
import '../../settings/widgets/language_tile.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: languageController,
      builder: (context, _) {
        final current = languageController.state.appLocale;

        return Scaffold(
          appBar: AppBar(title: const Text('Language')),
          body: ListView(
            children: [
              LanguageTile(
                title: 'English',
                subtitle: 'English',
                selected: current == AppLocale.english,
                onTap: () async {
                  await languageController.changeLanguage(AppLocale.english);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              LanguageTile(
                title: 'ગુજરાતી',
                subtitle: 'Gujarati',
                selected: current == AppLocale.gujarati,
                onTap: () async {
                  await languageController.changeLanguage(AppLocale.gujarati);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
