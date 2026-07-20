import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class QuickEntryCard extends StatelessWidget {
  const QuickEntryCard({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.quickEntry,
        hintText: AppLocalizations.of(context)!.quickEntryHint,
        prefixIcon: const Icon(Icons.flash_on),
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
