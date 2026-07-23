import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/enums/transaction_type.dart';
import '../models/transaction_model.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_radius.dart';

class TransactionCardWidget extends StatelessWidget {
  const TransactionCardWidget({
    super.key,
    required this.transaction,
    required this.categoryName,
    required this.paymentModeName,
    required this.onEdit,
    required this.onDelete,
  });

  final TransactionModel transaction;
  final String categoryName;
  final String paymentModeName;

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transaction.transactionType == TransactionType.income;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Badge
            Container(
              width: 52,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month, size: 18),
                  const SizedBox(height: 2),
                  Text(
                    "${transaction.transactionDate.day}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount + Payment Mode
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "₹ ${transaction.amount.toStringAsFixed(0)}",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isIncome
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                        ),
                      ),

                      Chip(
                        avatar: const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 18,
                        ),
                        label: Text(paymentModeName),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Category + Actions
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          categoryName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),

                      IconButton(
                        tooltip: AppLocalizations.of(context)!.edit,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.info,
                        ),
                        onPressed: onEdit,
                      ),

                      IconButton(
                        tooltip: AppLocalizations.of(context)!.delete,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                        ),
                        onPressed: onDelete,
                      ),
                    ],
                  ),

                  if (transaction.note.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      transaction.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.grey),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
