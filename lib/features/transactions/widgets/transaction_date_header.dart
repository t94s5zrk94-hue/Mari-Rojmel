import 'package:flutter/material.dart';
import '../../../app/app_radius.dart';

class TransactionDateHeader extends StatelessWidget {
  const TransactionDateHeader({
    super.key,
    required this.date,
    this.margin = const EdgeInsets.fromLTRB(16, 16, 16, 8),
  });

  final DateTime date;
  final EdgeInsetsGeometry margin;

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: margin,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: AppRadius.medium,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_month, size: 16),
                Text(
                  '${date.day}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              _formatDate(date),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
