import 'package:flutter/material.dart';
import '../../../core/enums/transaction_type.dart';
import '../../../l10n/generated/app_localizations.dart';

class TypeDropdown extends StatelessWidget {
  const TypeDropdown({super.key, required this.value, required this.onChanged});

  final TransactionType value;

  final ValueChanged<TransactionType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<TransactionType>(
          initialValue: value,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.type,
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(
              value: TransactionType.expense,
              child: Text(AppLocalizations.of(context)!.expense),
            ),
            DropdownMenuItem(
              value: TransactionType.income,
              child: Text(AppLocalizations.of(context)!.income),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
