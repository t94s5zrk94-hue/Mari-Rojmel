import 'package:flutter/material.dart';

import 'confirmation_dialog.dart';

/// A reusable delete confirmation dialog.
///
/// Uses [ConfirmationDialog] with delete-specific styling.
class DeleteDialog {
  const DeleteDialog._();

  /// Shows a delete confirmation dialog.
  static Future<bool> show(
    BuildContext context, {
    String title = 'Delete',
    required String message,
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
  }) async {
    return ConfirmationDialog.show(
      context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: Icons.delete_outline_rounded,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
  }
}
