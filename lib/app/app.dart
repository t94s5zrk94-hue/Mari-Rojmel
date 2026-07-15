import 'package:flutter/material.dart';

import '../features/home/screens/home_screen.dart';
import 'theme.dart';

class MariRojmelApp extends StatelessWidget {
  const MariRojmelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'મારી રોજમેલ',
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}