import 'package:flutter/material.dart';
import '../core/navigation/app_route_observer.dart';
import '../features/home/screens/home_screen.dart';
import 'theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mari_rojmel_app/l10n/generated/app_localizations.dart';
import 'theme/theme_provider.dart';
import '../main.dart';

class MariRojmelApp extends StatelessWidget {
  const MariRojmelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeController, languageController]),
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,

          theme: appLightTheme,
          darkTheme: appDarkTheme,
          themeMode: themeController.themeMode,

          navigatorObservers: [routeObserver],

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: AppLocalizations.supportedLocales,

          locale: languageController.state.locale,

          home: const HomeScreen(),
        );
      },
    );
  }
}
