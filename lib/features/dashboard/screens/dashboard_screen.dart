import 'package:flutter/material.dart';

import '../models/dashboard_summary.dart';
import '../services/dashboard_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardSummary? summary;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final data = await DashboardService.instance.getSummary();

    setState(() {
      summary = data;
      loading = false;
    });
  }

  Widget buildCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
           backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: loadDashboard,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          buildCard(
            "Today's Income",
            "₹${summary!.todayIncome.toStringAsFixed(2)}",
            Icons.arrow_downward,
            Colors.green,
          ),

          buildCard(
            "Today's Expense",
            "₹${summary!.todayExpense.toStringAsFixed(2)}",
            Icons.arrow_upward,
            Colors.red,
          ),

          buildCard(
            "Balance",
            "₹${summary!.balance.toStringAsFixed(2)}",
            Icons.account_balance_wallet,
            Colors.blue,
          ),

          buildCard(
            "Transactions",
            summary!.transactionCount.toString(),
            Icons.receipt_long,
            Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}