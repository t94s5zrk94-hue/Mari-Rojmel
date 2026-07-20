import 'package:flutter/material.dart';
import '../../transactions/screens/transaction_entry_screen.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../transactions/screens/transactions_screen.dart';
import '../../reports/screens/reports_screen.dart';
import '../../account/screens/account_screen.dart';
import '../../account/repositories/account_repository.dart';
import '../../../core/database/database_helper.dart';
import '../../../l10n/generated/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0:
        return const DashboardScreen();

      case 1:
        return const ReportsScreen();

      case 2:
        return const SizedBox.shrink();

      case 3:
        return const TransactionsScreen();

      case 4:
        return AccountScreen(
          repository: AccountRepository(DatabaseHelper.instance),
        );

      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) async {
          if (index == 2) {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (_) => const TransactionEntryScreen()),
            );

            if (!mounted) return;

            if (result == true) {
              setState(() {
                _currentIndex = 3; // Transactions tab
              });
            }

            return;
          }

          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: AppLocalizations.of(context)!.navDashboard,
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: AppLocalizations.of(context)!.navReports,
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: AppLocalizations.of(context)!.navAdd,
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: AppLocalizations.of(context)!.navTransactions,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: AppLocalizations.of(context)!.navAccount,
          ),
        ],
      ),
    );
  }
}
