import 'package:flutter/material.dart';

import '../../transactions/models/transaction_model.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({
    super.key,
    required this.transactions,
    this.maxItems = 10,
    this.onTap,
  });

  final List<TransactionModel> transactions;
  final int maxItems;
  final ValueChanged<TransactionModel>? onTap;

  @override
  Widget build(BuildContext context) {
    final items = transactions.take(maxItems).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            Text(
              '${items.length} items',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (items.isEmpty)
          const _EmptyView()
        else
          ...items.map(
            (transaction) => _TransactionTile(
              transaction: transaction,
              onTap: onTap,
            ),
          ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.transaction,
    this.onTap,
  });

  final TransactionModel transaction;
  final ValueChanged<TransactionModel>? onTap;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;

    final color = isIncome
        ? Colors.green
        : Colors.red;

    final icon = isIncome
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap == null
            ? null
            : () => onTap!(transaction),
        leading: CircleAvatar(
          backgroundColor:
              color.withValues(alpha: 0.12),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          transaction.note.isEmpty
              ? 'No Note'
              : transaction.note,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatDate(
            transaction.transactionDate,
          ),
        ),
        trailing: Text(
          '₹${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(
    DateTime date,
  ) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56,
              color: Theme.of(context)
                  .colorScheme
                  .outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No Recent Transactions',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Your latest transactions will appear here.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}