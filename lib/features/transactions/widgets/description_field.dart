import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({super.key, required this.controller, this.onChanged});

  final TextEditingController controller;

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: 2,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.description,
        hintText: AppLocalizations.of(context)!.enterDescription,
        prefixIcon: const Icon(Icons.notes),
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
