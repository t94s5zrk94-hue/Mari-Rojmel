import 'package:flutter/material.dart';

/// A reusable section header widget.
///
/// Features:
/// - Material 3 compatible
/// - Theme aware
/// - Optional action button
/// - Optional subtitle
/// - Reusable across Dashboard, Reports, Settings, etc.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  /// Main section title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Optional action text.
  final String? actionText;

  /// Action callback.
  final VoidCallback? onActionPressed;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          if (actionText != null)
            TextButton(onPressed: onActionPressed, child: Text(actionText!)),
        ],
      ),
    );
  }
}
