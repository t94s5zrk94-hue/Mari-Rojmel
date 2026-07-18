import 'package:flutter/material.dart';
import '../../../core/enums/transaction_type.dart';

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
          decoration: const InputDecoration(
            labelText: 'Type',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: TransactionType.expense,
              child: Text('Expense'),
            ),
            DropdownMenuItem(
              value: TransactionType.income,
              child: Text('Income'),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
