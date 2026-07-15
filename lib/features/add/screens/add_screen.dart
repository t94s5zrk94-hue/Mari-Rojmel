import 'package:flutter/material.dart';

import '../../parser/services/parser_service.dart';
import '../../transactions/models/transaction_model.dart';
import '../../transactions/repositories/transaction_repository.dart';
import '../widgets/quick_entry_field.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> saveEntry() async {
    final text = controller.text.trim();

    if (text.isEmpty) {
      _showMessage('Please enter something');
      return;
    }

    final parsed = ParserService.parse(text);

    if (parsed == null) {
      _showMessage('Unable to understand entry');
      return;
    }

    final now = DateTime.now();

    final transaction = TransactionModel(
      id: null,
      amount: parsed.amount,
      transactionType: parsed.isIncome
          ? TransactionType.income
          : TransactionType.expense,
      categoryId: parsed.categoryId,
      paymentModeId: 1, // Default Cash Payment Mode
      transactionDate: now,
      note: parsed.description,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    try {
      final success =
          await TransactionRepository.instance.insert(
        transaction,
      );

      if (!success) {
        _showMessage('Failed to Save Transaction');
        return;
      }

      controller.clear();

      _showMessage(
        'Transaction Saved Successfully',
      );
    } catch (e) {
      debugPrint(e.toString());

      _showMessage(
        'Failed to Save Transaction',
      );
    }
  }
    void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          QuickEntryField(controller: controller),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: saveEntry,
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}