import 'package:flutter/material.dart';

class IncomeExpenseCard extends StatelessWidget {
  const IncomeExpenseCard({
    super.key,
    required this.income,
    required this.expense,
  });

  final double income;
  final double expense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final balance = income - expense;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income vs Expense',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            _AmountTile(
              title: 'Income',
              amount: income,
              icon: Icons.arrow_downward_rounded,
              color: Colors.green,
            ),

            const Divider(height: 28),

            _AmountTile(
              title: 'Expense',
              amount: expense,
              icon: Icons.arrow_upward_rounded,
              color: Colors.red,
            ),

            const Divider(height: 28),

            _AmountTile(
              title: 'Net Balance',
              amount: balance,
              icon: Icons.account_balance_wallet_rounded,
              color: balance >= 0
                  ? Colors.blue
                  : colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountTile extends StatelessWidget {
  const _AmountTile({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String title;
  final double amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall,
          ),
        ),

        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}