import 'package:flutter/widgets.dart';

/// ===========================================================
/// Mari-Rojmel
/// App Spacing
/// ===========================================================
abstract final class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;

  static const EdgeInsets pagePadding = EdgeInsets.all(lg);

  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  static const EdgeInsets dialogPadding = EdgeInsets.fromLTRB(xxl, xl, xxl, lg);
}
