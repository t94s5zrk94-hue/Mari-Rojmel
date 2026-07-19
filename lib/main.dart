import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await themeController.initialize();

  runApp(const MariRojmelApp());
}
