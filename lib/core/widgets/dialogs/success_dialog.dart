import 'package:flutter/material.dart';

/// A reusable success dialog.
class SuccessDialog {
  const SuccessDialog._();

  /// Shows a success dialog.
  static Future<void> show(
    BuildContext context, {
    String title = 'Success',
    required String message,
    String buttonText = 'OK',
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        final theme = Theme.of(context);

        return AlertDialog(
          icon: Icon(
            Icons.check_circle_outline_rounded,
            color: theme.colorScheme.primary,
            size: 40,
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}
