import 'package:flutter/material.dart';
import '../widgets/month_selector_widget.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';
import '../services/month_service.dart';
import 'transaction_entry_screen.dart';
import '../../categories/models/category_model.dart';
import '../../categories/repositories/category_repository.dart';
import '../widgets/transaction_card_widget.dart';
import '../../payment_modes/models/payment_mode_model.dart';
import '../../payment_modes/repositories/payment_mode_repository.dart';
import '../widgets/transaction_date_header.dart';
import '../../../core/database/database_helper.dart';
import '../widgets/empty_transaction_widget.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<TransactionModel> transactions = [];

  bool loading = true;

  DateTime selectedMonth = DateTime.now();
  late final CategoryRepository _categoryRepository;
  late final PaymentModeRepository _paymentModeRepository;

  Map<int, CategoryModel> _categoryMap = {};

  Map<int, PaymentModeModel> _paymentModeMap = {};

  @override
  void initState() {
    super.initState();

    final db = DatabaseHelper.instance;

    _categoryRepository = CategoryRepository(db);
    _paymentModeRepository = PaymentModeRepository(db);

    loadTransactions();
  }

  Future<void> loadTransactions() async {
    setState(() {
      loading = true;
    });

    final categories = await _categoryRepository.getActive();

    _categoryMap = {for (final category in categories) category.id!: category};

    final paymentModes = await _paymentModeRepository.getActive();

    _paymentModeMap = {
      for (final paymentMode in paymentModes) paymentMode.id!: paymentMode,
    };

    final all = await TransactionRepository.instance.getActive();

    final data = all.where((transaction) {
      return transaction.transactionDate.year == selectedMonth.year &&
          transaction.transactionDate.month == selectedMonth.month;
    }).toList();

    if (!mounted) return;

    setState(() {
      transactions = data;
      loading = false;
    });
  }

  Future<void> openEdit(TransactionModel transaction) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionEntryScreen(transaction: transaction),
      ),
    );

    if (updated == true) {
      await loadTransactions();
    }
  }

  void previousMonth() {
    setState(() {
      selectedMonth = MonthService.instance.previousMonth(selectedMonth);
    });

    loadTransactions();
  }

  void nextMonth() {
    if (MonthService.instance.isCurrentMonth(selectedMonth)) {
      return;
    }

    setState(() {
      selectedMonth = MonthService.instance.nextMonth(selectedMonth);
    });

    loadTransactions();
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Transaction'),
          content: const Text(
            'Are you sure you want to delete this transaction?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await TransactionRepository.instance.softDelete(transaction.id!);

    if (!mounted) return;

    await loadTransactions();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions"), centerTitle: true),

      body: Column(
        children: [
          MonthSelectorWidget(
            monthText: MonthService.instance.format(selectedMonth),
            onPrevious: previousMonth,
            onNext: nextMonth,
            isCurrentMonth: MonthService.instance.isCurrentMonth(selectedMonth),
          ),
          const Divider(height: 1),

          if (loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (transactions.isEmpty)
            const Expanded(child: EmptyTransactionWidget())
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: loadTransactions,
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final t = transactions[index];
                    final category = _categoryMap[t.categoryId];
                    final paymentMode = _paymentModeMap[t.paymentModeId];

                    final categoryName = category?.name ?? 'Unknown';
                    final paymentModeName = paymentMode?.name ?? 'Unknown';

                    bool showDate = true;

                    if (index > 0) {
                      final previous = transactions[index - 1];

                      showDate =
                          previous.transactionDate.day !=
                              t.transactionDate.day ||
                          previous.transactionDate.month !=
                              t.transactionDate.month ||
                          previous.transactionDate.year !=
                              t.transactionDate.year;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showDate)
                          TransactionDateHeader(date: t.transactionDate),
                        TransactionCardWidget(
                          transaction: t,
                          categoryName: categoryName,
                          paymentModeName: paymentModeName,
                          onEdit: () => openEdit(t),
                          onDelete: () => deleteTransaction(t),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
