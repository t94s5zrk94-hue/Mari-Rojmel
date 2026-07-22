import 'package:flutter/material.dart';

/// A reusable error view widget.
///
/// Features:
/// - Material 3 compatible
/// - Theme aware
/// - Optional retry button
/// - Reusable across the application
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.title = 'Something went wrong',
    this.buttonText = 'Retry',
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
    this.padding = const EdgeInsets.all(24),
  });

  /// Error title.
  final String title;

  /// Error message.
  final String message;

  /// Retry button text.
  final String buttonText;

  /// Retry callback.
  final VoidCallback? onRetry;

  /// Error icon.
  final IconData icon;

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
            Icon(icon, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(buttonText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
