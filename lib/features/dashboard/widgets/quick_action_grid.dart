import 'package:flutter/material.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({
    super.key,
    required this.onAddTransaction,
    required this.onCategories,
    required this.onPaymentModes,
    this.onReports,
  });

  final VoidCallback onAddTransaction;
  final VoidCallback onCategories;
  final VoidCallback onPaymentModes;
  final VoidCallback? onReports;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: [
            _ActionCard(
              title: 'Add Transaction',
              icon: Icons.add_circle_outline_rounded,
              color: Colors.blue,
              onTap: onAddTransaction,
            ),
            _ActionCard(
              title: 'Categories',
              icon: Icons.category_outlined,
              color: Colors.orange,
              onTap: onCategories,
            ),
            _ActionCard(
              title: 'Payment Modes',
              icon: Icons.account_balance_wallet_outlined,
              color: Colors.green,
              onTap: onPaymentModes,
            ),
            _ActionCard(
              title: 'Reports',
              icon: Icons.bar_chart_rounded,
              color: Colors.deepPurple,
              onTap: onReports,
              enabled: onReports != null,
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    color.withValues(alpha: 0.12),
                child: Icon(
                  icon,
                  color: color,
                  size: 26,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}