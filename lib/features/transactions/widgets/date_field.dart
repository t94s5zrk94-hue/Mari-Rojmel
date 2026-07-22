import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../app/app_radius.dart';

class DateField extends StatelessWidget {
  const DateField({super.key, required this.selectedDate, required this.onTap});

  final DateTime selectedDate;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.medium,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.date,
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          MaterialLocalizations.of(context).formatCompactDate(selectedDate),
        ),
      ),
    );
  }
}
