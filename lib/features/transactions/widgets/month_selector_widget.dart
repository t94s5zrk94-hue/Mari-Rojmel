import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

class MonthSelectorWidget extends StatelessWidget {
  const MonthSelectorWidget({
    super.key,
    required this.monthText,
    required this.onPrevious,
    required this.onNext,
    required this.isCurrentMonth,
  });

  final String monthText;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isCurrentMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            tooltip: AppLocalizations.of(context)!.previousMonth,
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
          ),

          Expanded(
            child: Center(
              child: Text(
                monthText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          IconButton(
            tooltip: AppLocalizations.of(context)!.nextMonth,
            onPressed: isCurrentMonth ? null : onNext,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
