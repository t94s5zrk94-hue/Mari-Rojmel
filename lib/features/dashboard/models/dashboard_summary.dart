class DashboardSummary {
  const DashboardSummary({
    required this.todayIncome,
    required this.todayExpense,
    required this.balance,
    required this.transactionCount,
  });

  final double todayIncome;
  final double todayExpense;
  final double balance;
  final int transactionCount;
}