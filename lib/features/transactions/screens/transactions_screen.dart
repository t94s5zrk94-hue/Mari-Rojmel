import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';
import '../services/month_service.dart';
import 'edit_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() =>
      _TransactionsScreenState();
}

class _TransactionsScreenState
    extends State<TransactionsScreen> {

  List<TransactionModel> transactions = [];

  bool loading = true;

  DateTime selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {

    setState(() {
      loading = true;
    });

    final all = await TransactionRepository.instance
        .getActive();

    final data = all.where((transaction) {
      return transaction.transactionDate.year ==
              selectedMonth.year &&
          transaction.transactionDate.month ==
              selectedMonth.month;
    }).toList();

    if (!mounted) return;

    setState(() {
      transactions = data;
      loading = false;
    });
  }

  Future<void> openEdit(
      TransactionModel transaction) async {

    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditTransactionScreen(
          transaction: transaction,
        ),
      ),
    );

    if (updated == true) {
      loadTransactions();
    }
  }

  void previousMonth() {

    setState(() {
      selectedMonth =
          MonthService.instance.previousMonth(
        selectedMonth,
      );
    });

    loadTransactions();
  }

  void nextMonth() {

    if (MonthService.instance
        .isCurrentMonth(selectedMonth)) {
      return;
    }

    setState(() {
      selectedMonth =
          MonthService.instance.nextMonth(
        selectedMonth,
      );
    });

    loadTransactions();
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Transactions"),
        centerTitle: true,
      ),

      body: Column(

        children: [

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Row(

              children: [

                IconButton(
                  onPressed: previousMonth,
                  icon: const Icon(
                    Icons.chevron_left,
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Text(
                      MonthService.instance
                          .format(selectedMonth),
                      style:
                          const TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: MonthService
                          .instance
                          .isCurrentMonth(
                              selectedMonth)
                      ? null
                      : nextMonth,
                  icon: const Icon(
                    Icons.chevron_right,
                  ),
                ),

              ],
            ),
          ),

          const Divider(height: 1),

          if (loading)
            const Expanded(
              child: Center(
                child:
                    CircularProgressIndicator(),
              ),
            )
          else if (transactions.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "No Transactions Found",
                ),
              ),
            )
          else
            Expanded(

                        child: RefreshIndicator(
                onRefresh: loadTransactions,
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final t = transactions[index];

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
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        if (showDate)
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(
                              16,
                              16,
                              16,
                              8,
                            ),
                            child: Text(
                              formatDate(
                                t.transactionDate,
                              ),
                              style:
                                  const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                        Card(
                          margin:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: ListTile(

                            leading: CircleAvatar(
                              backgroundColor:
                                  t.transactionType == TransactionType.income
                                      ? Colors.green
                                          .withValues(
                                              alpha: 0.15)
                                      : Colors.red
                                          .withValues(
                                              alpha: 0.15),
                              child: Icon(
                                t.transactionType == TransactionType.income
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color:
                                    t.transactionType == TransactionType.expense
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ),

                            title: Text(
                              t.note,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [

                                Text(
                                  'Mode: ${t.paymentModeId}'
                                ),

                                const SizedBox(
                                    height: 4),

                                Text(
                                  "₹ ${t.amount.toStringAsFixed(0)}",
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),

                            trailing: Row(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [

                                IconButton(
                                  tooltip: "Edit",
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    openEdit(t);
                                  },
                                ),

                                IconButton(
                                  tooltip: "Delete",
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {

                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Delete will be added in next step",
                                        ),
                                      ),
                                    );

                                  },
                                ),

                              ],
                            ),
                          ),
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