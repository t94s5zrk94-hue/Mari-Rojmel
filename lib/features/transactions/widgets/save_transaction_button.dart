import 'package:flutter/material.dart';

class SaveTransactionButton extends StatelessWidget {
  const SaveTransactionButton({
    super.key,
    required this.isSaving,
    required this.onPressed,
  });

  final bool isSaving;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        onPressed: isSaving ? null : onPressed,
        icon: isSaving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
        label: Text(isSaving ? 'Saving...' : 'Save Transaction'),
      ),
    );
  }
}
