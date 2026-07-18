import 'package:flutter/material.dart';

import '../../../core/database/database_helper.dart';
import '../../payment_modes/models/payment_mode_model.dart';
import '../../payment_modes/repositories/payment_mode_repository.dart';

/// ==========================================================
/// Payment Mode Report
///
/// Production Ready
/// Material 3
/// Responsive
/// ==========================================================
class PaymentModeReport extends StatefulWidget {
  const PaymentModeReport({super.key, required this.reportData});

  /// paymentModeId -> total amount
  final Map<int, double> reportData;

  @override
  State<PaymentModeReport> createState() => _PaymentModeReportState();
}

class _PaymentModeReportState extends State<PaymentModeReport> {
  late final PaymentModeRepository _repository;

  List<PaymentModeModel> _paymentModes = const [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _repository = PaymentModeRepository(DatabaseHelper.instance);

    _loadPaymentModes();
  }

  Future<void> _loadPaymentModes() async {
    final result = await _repository.getActive();

    if (!mounted) {
      return;
    }

    setState(() {
      _paymentModes = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.reportData.isEmpty) {
      return const Center(child: Text('No payment mode report available.'));
    }

    final reportItems = widget.reportData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Mode Report',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reportItems.length,
              separatorBuilder: (context, index) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final item = reportItems[index];

                final paymentMode = _paymentModes.firstWhere(
                  (element) => element.id == item.key,
                  orElse: () => _unknownPaymentMode,
                );

                return _PaymentModeTile(
                  paymentMode: paymentMode,
                  amount: item.value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static const PaymentModeModel _unknownPaymentMode = PaymentModeModel(
    id: -1,
    name: 'Unknown',
    icon: '❓',
    color: 0xFF4CAF50,
    isDefault: false,
    isActive: true,
    sortOrder: 9999,
  );
}

class _PaymentModeTile extends StatelessWidget {
  const _PaymentModeTile({required this.paymentMode, required this.amount});

  final PaymentModeModel paymentMode;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Text(paymentMode.icon, style: const TextStyle(fontSize: 18)),
      ),
      title: Text(
        paymentMode.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _formatCurrency(amount),
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  String _formatCurrency(double value) {
    return '₹${value.toStringAsFixed(2)}';
  }
}
