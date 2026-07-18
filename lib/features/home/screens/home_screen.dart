import 'package:flutter/material.dart';
import '../../transactions/screens/transaction_entry_screen.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../transactions/screens/transactions_screen.dart';
import '../../reports/screens/reports_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),

    const ReportsScreen(),

    const SizedBox.shrink(),

    const TransactionsScreen(),

    const Center(child: Text('Account', style: TextStyle(fontSize: 24))),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
