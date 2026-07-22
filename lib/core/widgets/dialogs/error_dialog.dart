import 'package:flutter/material.dart';

/// A reusable Material 3 error dialog.
class ErrorDialog {
  const ErrorDialog._();

  /// Shows an error dialog.
  static Future<void> show(
    BuildContext context, {
    String title = 'Error',
    required String message,
    String buttonText = 'OK',
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        final theme = Theme.of(context);

        return AlertDialog(
          icon: Icon(
            Icons.error_outline_rounded,
            color: theme.colorScheme.error,
            size: 40,
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}
