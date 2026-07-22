import 'package:flutter/material.dart';
import '../models/category_report_item.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../app/app_spacing.dart';

/// ==========================================================
/// Category Report Widget
///
/// Production Ready
/// Material 3
/// Responsive
/// ==========================================================
class CategoryReport extends StatelessWidget {
  const CategoryReport({super.key, required this.reportData});

  final List<CategoryReportItem> reportData;

  @override
  Widget build(BuildContext context) {
    if (reportData.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.noCategoryReportAvailable,
            ),
          ),
        ),
      );
    }

    final totalAmount = reportData.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.categoryReport,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 16),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reportData.length,

              separatorBuilder: (context, index) => const Divider(height: 20),

              itemBuilder: (context, index) {
                final item = reportData[index];

                final percentage = totalAmount == 0
                    ? 0.0
                    : item.amount / totalAmount;

                return _CategoryTile(item: item, percentage: percentage);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.item, required this.percentage});

  final CategoryReportItem item;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    final color = Color(item.color);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Text(item.icon, style: const TextStyle(fontSize: 18)),
      ),
      title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${item.transactionCount} ${AppLocalizations.of(context)!.transactions}',
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '₹${item.amount.toStringAsFixed(2)}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            '${(percentage * 100).toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
