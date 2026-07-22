import 'package:flutter/material.dart';

/// Standard shadow definitions used throughout the application.
///
/// Avoid creating BoxShadow instances repeatedly.
/// Use AppShadows instead.
abstract final class AppShadows {
  AppShadows._();

  /// No shadow.
  static const List<BoxShadow> none = [];

  /// Small shadow.
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  /// Medium shadow.
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  /// Large shadow.
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x29000000), blurRadius: 16, offset: Offset(0, 8)),
  ];

  /// Floating card shadow.
  static const List<BoxShadow> floating = [
    BoxShadow(color: Color(0x24000000), blurRadius: 20, offset: Offset(0, 10)),
  ];
}
