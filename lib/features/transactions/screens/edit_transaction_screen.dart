import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState
    extends State<EditTransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController notesController;

  late int paymentModeId;

  late TransactionType transactionType;

  late int categoryId;

  late DateTime transactionDate;

  bool saving = false;

  @override
    void initState() {
      super.initState();

      amountController = TextEditingController(
        text: widget.transaction.amount.toStringAsFixed(0),
      );

      notesController = TextEditingController(
        text: widget.transaction.note,
      );

      paymentModeId =
          widget.transaction.paymentModeId;

      transactionType =
          widget.transaction.transactionType;

      categoryId =
          widget.transaction.categoryId;

      transactionDate =
          widget.transaction.transactionDate;
    }
  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: transactionDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        transactionDate = picked;
      });
    }
  }

  Future<void> updateTransaction() async {
    if (amountController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      saving = true;
    });

    final transaction = widget.transaction.copyWith(
      amount: double.parse(amountController.text),
      categoryId: categoryId,
      transactionType: transactionType,
      paymentModeId: paymentModeId,
      transactionDate: transactionDate,
      note: notesController.text.trim(),
      updatedAt: DateTime.now(),
    );

    await TransactionRepository.instance.update(
      transaction,
    );

    if (!mounted) return;

    Navigator.pop(context, true);

        ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Transaction Updated Successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Transaction"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),

            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: paymentModeId,
              decoration: const InputDecoration(
                labelText: "Payment Mode",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text("Cash"),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text("UPI"),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text("Bank"),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  paymentModeId = value;
                });
              },
            ),

            const SizedBox(height: 16),

            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.grey),
              ),
              leading: const Icon(Icons.calendar_today),
              title: const Text("Transaction Date"),
              subtitle: Text(
                "${transactionDate.day}/${transactionDate.month}/${transactionDate.year}",
              ),
              trailing: const Icon(Icons.edit_calendar),
              onTap: selectDate,
            ),

            const SizedBox(height: 16),

            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [

                Expanded(
                  child: OutlinedButton(
                    onPressed: saving
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: FilledButton.icon(
                    onPressed:
                        saving ? null : updateTransaction,
                    icon: saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      saving
                          ? "Updating..."
                          : "Update",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}