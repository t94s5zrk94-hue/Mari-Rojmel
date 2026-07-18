// ===============================================================
// Payment Mode Report Item
//
// Production Ready
// Immutable Model
// ===============================================================

class PaymentModeReportItem {
  const PaymentModeReportItem({
    required this.paymentModeId,
    required this.name,
    required this.icon,
    required this.color,
    required this.amount,
    required this.transactionCount,
  });

  final int paymentModeId;
  final String name;
  final String icon;
  final int color;
  final double amount;
  final int transactionCount;
}
