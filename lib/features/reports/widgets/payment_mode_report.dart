import 'package:flutter/material.dart';
import '../models/payment_mode_report_item.dart';
import '../../../l10n/generated/app_localizations.dart';

/// ==========================================================
/// Payment Mode Report
///
/// Production Ready
/// Material 3
/// Responsive
/// ==========================================================
class PaymentModeReport extends StatelessWidget {
  const PaymentModeReport({super.key, required this.reportData});

  final List<PaymentModeReportItem> reportData;

  @override
  Widget build(BuildContext context) {
    if (reportData.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.noPaymentModeReportAvailable,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.paymentModeReportTitle,
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

                return _PaymentModeTile(item: item, percentage: percentage);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentModeTile extends StatelessWidget {
  const _PaymentModeTile({required this.item, required this.percentage});

  final PaymentModeReportItem item;
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
