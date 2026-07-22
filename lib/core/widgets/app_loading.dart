import 'package:flutter/material.dart';

/// A reusable loading widget.
///
/// Features:
/// - Material 3 compatible
/// - Theme aware
/// - Optional loading message
/// - Reusable across the application
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.message,
    this.padding = const EdgeInsets.all(24),
  });

  /// Optional loading message.
  final String? message;

  /// Outer padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
