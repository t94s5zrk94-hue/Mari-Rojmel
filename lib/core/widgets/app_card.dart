import 'package:flutter/material.dart';

/// A reusable Material 3 card widget used throughout the application.
///
/// Features:
/// - Theme aware
/// - Optional tap handling
/// - Custom padding, margin and elevation
/// - Custom background color
/// - Custom border radius
/// - Material ripple effect
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.elevation = 0,
    this.color,
    this.borderRadius = 16,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Card content.
  final Widget child;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Outer margin.
  final EdgeInsetsGeometry margin;

  /// Card elevation.
  final double elevation;

  /// Optional card color.
  final Color? color;

  /// Card corner radius.
  final double borderRadius;

  /// Clip behavior.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      child: Material(
        color: color ?? theme.colorScheme.surface,
        elevation: elevation,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: clipBehavior,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
