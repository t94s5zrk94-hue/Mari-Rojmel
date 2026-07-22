import 'package:flutter/material.dart';

/// A reusable empty state widget.
///
/// Features:
/// - Material 3 compatible
/// - Theme aware
/// - Optional icon
/// - Optional action button
/// - Reusable across the application
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.buttonText,
    this.onPressed,
    this.padding = const EdgeInsets.all(24),
  });

  /// Empty state title.
  final String title;

  /// Optional message.
  final String? message;

  /// Empty state icon.
  final IconData icon;

  /// Optional button text.
  final String? buttonText;

  /// Button callback.
  final VoidCallback? onPressed;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 24),
              FilledButton(onPressed: onPressed, child: Text(buttonText!)),
            ],
          ],
        ),
      ),
    );
  }
}
