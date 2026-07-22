import 'package:flutter/widgets.dart';

/// ===========================================================
/// Mari-Rojmel
/// App Radius
/// ===========================================================
abstract final class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;

  static const BorderRadius small = BorderRadius.all(Radius.circular(sm));

  static const BorderRadius medium = BorderRadius.all(Radius.circular(md));

  static const BorderRadius large = BorderRadius.all(Radius.circular(lg));

  static const BorderRadius extraLarge = BorderRadius.all(Radius.circular(xl));
}
