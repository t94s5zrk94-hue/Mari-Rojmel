import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class AmountField extends StatelessWidget {
  const AmountField({super.key, required this.controller, this.onChanged});

  final TextEditingController controller;

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.amount,
            hintText: AppLocalizations.of(context)!.enterAmount,
            prefixIcon: const Icon(Icons.currency_rupee),
            border: const OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
