import 'package:flutter/material.dart';

import '../features/home/screens/home_screen.dart';
import 'theme.dart';

import 'theme/theme_provider.dart';

class MariRojmelApp extends StatelessWidget {
  const MariRojmelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'મારી રોજમેલ',

          theme: appLightTheme,
          darkTheme: appDarkTheme,
          themeMode: themeController.themeMode,

          home: const HomeScreen(),
        );
      },
    );
  }
}
