import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../models/report_summary.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_radius.dart';
import '../../../app/app_spacing.dart';

/// ==========================================================
/// Report Summary Card
///
/// Production Ready
/// Material 3
/// Responsive
/// Reusable
/// ==========================================================

class ReportSummaryCard extends StatelessWidget {
  const ReportSummaryCard({super.key, required this.summary});

  final ReportSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            if (isWide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.reportSummary,
                    style: theme.textTheme.titleLarge,
                  ),

                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildColumnOne(context, theme)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildColumnTwo(context, theme)),
                    ],
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.reportSummary,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                _buildColumnOne(context, theme),
                const SizedBox(height: 12),
                _buildColumnTwo(context, theme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildColumnOne(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        _SummaryTile(
          title: AppLocalizations.of(context)!.totalIncome,
          value: summary.totalIncome,
          color: AppColors.success,
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 12),
        _SummaryTile(
          title: AppLocalizations.of(context)!.totalExpense,
          value: summary.totalExpense,
          color: AppColors.error,
          icon: Icons.trending_down,
        ),
        const SizedBox(height: 12),
        _SummaryTile(
          title: AppLocalizations.of(context)!.netBalance,
          value: summary.netBalance,
          color: AppColors.info,
          icon: Icons.account_balance_wallet,
        ),
        const SizedBox(height: 12),
        _SummaryTile(
          title: AppLocalizations.of(context)!.totalTransactions,
          value: summary.totalTransactions.toDouble(),
          color: AppColors.primaryAccent,
          icon: Icons.receipt_long,
          isCurrency: false,
        ),
      ],
    );
  }

  Widget _buildColumnTwo(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        _SummaryTile(
          title: AppLocalizations.of(context)!.highestIncome,
          value: summary.highestIncome,
          color: AppColors.secondaryAccent,
          icon: Icons.arrow_circle_up,
        ),
        const SizedBox(height: 12),
        _SummaryTile(
          title: AppLocalizations.of(context)!.highestExpense,
          value: summary.highestExpense,
          color: AppColors.warning,
          icon: Icons.arrow_circle_down,
        ),
        const SizedBox(height: 12),
        _SummaryTile(
          title: AppLocalizations.of(context)!.averageIncome,
          value: summary.averageIncome,
          color: AppColors.success,
          icon: Icons.bar_chart,
        ),
        const SizedBox(height: 12),
        _SummaryTile(
          title: AppLocalizations.of(context)!.averageExpense,
          value: summary.averageExpense,
          color: AppColors.error,
          icon: Icons.stacked_bar_chart,
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    this.isCurrency = true,
  });

  final String title;
  final double value;
  final Color color;
  final IconData icon;
  final bool isCurrency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.medium,
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  _formatValue(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatValue() {
    if (!isCurrency) {
      return value.toInt().toString();
    }

    return '₹${value.toStringAsFixed(2)}';
  }
}
