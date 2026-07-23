// ===============================================================
// Mari-Rojmel
// Dashboard Screen
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../categories/repositories/category_repository.dart';
import '../../categories/screens/category_screen.dart';
import '../../payment_modes/repositories/payment_mode_repository.dart';
import '../../payment_modes/screens/payment_mode_screen.dart';
import '../../reports/screens/reports_screen.dart';
import '../../transactions/models/transaction_model.dart';
import '../../transactions/repositories/transaction_repository.dart';
import '../../../core/database/database_helper.dart';
import '../../transactions/screens/transaction_entry_screen.dart';
import '../models/dashboard_summary.dart';
import '../services/dashboard_service.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_spacing.dart';
import '../widgets/summary_card.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/recent_transactions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _dashboardService = DashboardService.instance;

  final TransactionRepository _transactionRepository =
      TransactionRepository.instance;

  DashboardSummary? _summary;

  List<TransactionModel> _recentTransactions = [];

  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final summary = await _dashboardService.getSummary();

      final transactions = await _transactionRepository.getActive();

      if (!mounted) {
        return;
      }

      setState(() {
        _summary = summary;

        _recentTransactions = transactions.take(10).toList();

        _isLoading = false;
      });
    } on Exception catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _openCategories() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryScreen(
          repository: CategoryRepository(DatabaseHelper.instance),
        ),
      ),
    );
  }

  void _openPaymentModes() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentModeScreen(
          repository: PaymentModeRepository(DatabaseHelper.instance),
        ),
      ),
    );
  }

  void _openReports() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ReportsScreen()));
  }

  Future<void> _refresh() async {
    await _loadDashboard();
  }

  String _currency(double value) {
    return '₹${value.toStringAsFixed(2)}';
  }

  Color _amountColor(double value) {
    if (value > 0) {
      return AppColors.success;
    }

    if (value < 0) {
      return AppColors.error;
    }

    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.dashboard)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 72,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.unableToLoadDashboard,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(_errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final summary = _summary!;

    return Scaffold(
      appBar: AppBar(title: const Text('Mari-Rojmel'), centerTitle: false),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: AppSpacing.cardPadding,
          children: [
            Text(
              _greeting(),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            Text(
              AppLocalizations.of(context)!.welcomeBack,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.currentBalance,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currency(summary.balance),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _amountColor(summary.balance),
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: AppLocalizations.of(context)!.income,
                    value: _currency(summary.todayIncome),
                    icon: Icons.arrow_downward_rounded,
                    color: AppColors.success,
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: AppLocalizations.of(context)!.expense,
                    value: _currency(summary.todayExpense),
                    icon: Icons.arrow_upward_rounded,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: AppLocalizations.of(context)!.balance,
                    value: _currency(summary.balance),
                    icon: Icons.account_balance_wallet,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: AppLocalizations.of(context)!.transactionCount,
                    value: summary.transactionCount.toString(),
                    icon: Icons.receipt_long,
                    color: AppColors.primaryAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.quickActions,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            QuickActionGrid(
              onAddTransaction: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TransactionEntryScreen(),
                  ),
                );

                if (result == true) {
                  _loadDashboard();
                }
              },
              onCategories: _openCategories,
              onPaymentModes: _openPaymentModes,
              onReports: _openReports,
            ),
            const SizedBox(height: 24),

            RecentTransactions(transactions: _recentTransactions),

            const SizedBox(height: 24),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return AppLocalizations.of(context)!.goodMorning;
    }

    if (hour < 17) {
      return AppLocalizations.of(context)!.goodAfternoon;
    }

    return AppLocalizations.of(context)!.goodEvening;
  }
}
