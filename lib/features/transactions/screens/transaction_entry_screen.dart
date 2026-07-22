import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../../core/enums/transaction_type.dart';
import '../../categories/models/category_model.dart';
import '../../categories/screens/category_screen.dart';
import '../../payment_modes/models/payment_mode_model.dart';
import '../widgets/amount_field.dart';
import '../widgets/bill_attachment.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/date_field.dart';
import '../widgets/description_field.dart';
import '../widgets/payment_dropdown.dart';
import '../widgets/quick_entry_card.dart';
import '../widgets/save_transaction_button.dart';
import '../widgets/type_dropdown.dart';
import '../../parser/services/transaction_parser.dart';
import '../../../core/database/database_helper.dart';
import '../../categories/repositories/category_repository.dart';
import '../../payment_modes/screens/payment_mode_screen.dart';
import '../../payment_modes/repositories/payment_mode_repository.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_learning_repository.dart';
import '../services/transaction_service.dart';
import '../../../l10n/generated/app_localizations.dart';

class TransactionEntryScreen extends StatefulWidget {
  const TransactionEntryScreen({super.key, this.transaction});

  final TransactionModel? transaction;

  bool get isEdit => transaction != null;

  @override
  State<TransactionEntryScreen> createState() => _TransactionEntryScreenState();
}

class _TransactionEntryScreenState extends State<TransactionEntryScreen> {
  // ==========================================================
  // Controllers
  // ==========================================================
  final TextEditingController _quickEntryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // ==========================================================
  // Form State
  // ==========================================================
  TransactionType _selectedType = TransactionType.expense;
  CategoryModel? _selectedCategory;
  PaymentModeModel? _selectedPaymentMode;
  DateTime _selectedDate = DateTime.now();

  File? _billImage;
  final bool _isSaving = false;

  final List<CategoryModel> _categories = <CategoryModel>[];
  final List<PaymentModeModel> _paymentModes = <PaymentModeModel>[];

  late final TransactionParser _transactionParser;
  final TransactionService _transactionService = TransactionService.instance;
  final CategoryRepository _categoryRepository = CategoryRepository(
    DatabaseHelper.instance,
  );

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _billImage = File(image.path);
    });
  }

  Future<void> _camera() async {
    await _pickImage(ImageSource.camera);
  }

  Future<void> _gallery() async {
    await _pickImage(ImageSource.gallery);
  }

  void _removeBill() {
    setState(() {
      _billImage = null;
    });
  }

  @override
  void initState() {
    super.initState();

    _transactionParser = TransactionParser(
      categoryRepository: CategoryRepository(DatabaseHelper.instance),
      paymentModeRepository: PaymentModeRepository(DatabaseHelper.instance),
      learningRepository: TransactionLearningRepository(
        DatabaseHelper.instance,
      ),
    );
    Future.microtask(() async {
      await _loadCategories();
      await _loadPaymentModes();
    });

    if (widget.isEdit) {
      _loadExistingTransaction();
    }
  }

  void _loadExistingTransaction() {
    final transaction = widget.transaction!;

    _amountController.text = transaction.amount.toStringAsFixed(0);

    _descriptionController.text = transaction.note;

    _selectedType = transaction.transactionType;

    _selectedDate = transaction.transactionDate;
  }

  @override
  void dispose() {
    _quickEntryController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ==========================================================
  // UI
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.isEdit
              ? AppLocalizations.of(context)!.editTransaction
              : AppLocalizations.of(context)!.addTransaction,
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    QuickEntryCard(
                      controller: _quickEntryController,
                      onChanged: _onQuickEntryChanged,
                    ),
                    const SizedBox(height: 20),

                    const SizedBox(height: 20),

                    const SizedBox(height: 20),

                    AmountField(controller: _amountController),

                    const SizedBox(height: 20),

                    TypeDropdown(
                      value: _selectedType,
                      onChanged: (TransactionType? value) async {
                        if (value == null) return;

                        setState(() {
                          _selectedType = value;
                          _selectedCategory = null;
                          // _selectedPaymentMode = null;
                        });

                        await _loadCategories();
                      },
                    ),

                    const SizedBox(height: 20),

                    CategoryDropdown(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      onAddCategory: _addCategory,
                    ),

                    const SizedBox(height: 20),

                    PaymentDropdown(
                      paymentModes: _paymentModes,
                      selectedPaymentMode: _selectedPaymentMode,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMode = value;
                        });
                      },
                      onAddPaymentMode: _addPaymentMode,
                    ),

                    const SizedBox(height: 20),

                    DateField(selectedDate: _selectedDate, onTap: _pickDate),

                    const SizedBox(height: 20),

                    DescriptionField(controller: _descriptionController),

                    const SizedBox(height: 20),

                    BillAttachment(
                      billImage: _billImage,
                      onCameraTap: _camera,
                      onGalleryTap: _gallery,
                      onRemoveTap: _removeBill,
                    ),

                    const SizedBox(height: 8),

                    SaveTransactionButton(
                      isSaving: _isSaving,
                      buttonText: widget.isEdit
                          ? AppLocalizations.of(context)!.updateTransaction
                          : AppLocalizations.of(context)!.saveTransaction,
                      onPressed: _saveTransaction,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveTransaction() async {
    try {
      if (_selectedCategory == null || _selectedPaymentMode == null) {
        return;
      }

      final amount = double.tryParse(_amountController.text.trim());

      final model = TransactionModel(
        id: null,
        amount: amount!,
        transactionType: _selectedType,
        categoryId: _selectedCategory!.id!,
        paymentModeId: _selectedPaymentMode!.id!,
        transactionDate: _selectedDate,
        note: _descriptionController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
      );

      bool success;

      if (widget.isEdit) {
        success = await _transactionService.updateTransaction(
          model.copyWith(
            id: widget.transaction!.id,
            createdAt: widget.transaction!.createdAt,
          ),
        );
      } else {
        success = await _transactionService.saveAndLearn(
          transaction: model,
          originalInput: _quickEntryController.text.trim(),
        );
      }

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
      }
    } catch (_) {
      return;
    }
  }

  Future<void> _onQuickEntryChanged(String value) async {
    if (value.trim().isEmpty) {
      return;
    }

    final parsed = await _transactionParser.parse(value);

    if (parsed.amount != null) {
      setState(() {
        _amountController.text = parsed.amount!.toStringAsFixed(0);
      });
    }

    if (parsed.transactionType != null) {
      setState(() {
        _selectedType = parsed.transactionType!;
      });

      await _loadCategories();
    }

    if (parsed.category != null) {
      final selected = _categories
          .where((e) => e.id == parsed.category!.id)
          .firstOrNull;

      if (selected != null) {
        setState(() {
          _selectedCategory = selected;
        });
      }
    }

    if (parsed.paymentMode != null) {
      setState(() {
        _selectedPaymentMode = parsed.paymentMode;
      });
    }
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryRepository.getActive(
      transactionType: _selectedType,
    );

    final defaultCategory = await _categoryRepository.getDefaultCategory(
      _selectedType,
    );

    if (!mounted) return;

    setState(() {
      _categories
        ..clear()
        ..addAll(categories);

      if (widget.isEdit) {
        _selectedCategory = _categories.cast<CategoryModel?>().firstWhere(
          (e) => e?.id == widget.transaction!.categoryId,
          orElse: () => null,
        );
      } else {
        _selectedCategory ??= _categories.cast<CategoryModel?>().firstWhere(
          (e) => e?.id == defaultCategory?.id,
          orElse: () => null,
        );
      }
    });
  }

  Future<void> _loadPaymentModes() async {
    final repository = PaymentModeRepository(DatabaseHelper.instance);

    final paymentModes = await repository.getActive();

    final defaultPayment = await repository.getDefaultPayment();

    if (!mounted) return;

    setState(() {
      _paymentModes
        ..clear()
        ..addAll(paymentModes);

      if (widget.isEdit) {
        _selectedPaymentMode = _paymentModes
            .cast<PaymentModeModel?>()
            .firstWhere(
              (e) => e?.id == widget.transaction!.paymentModeId,
              orElse: () => null,
            );
      } else {
        _selectedPaymentMode ??= _paymentModes
            .cast<PaymentModeModel?>()
            .firstWhere((e) => e?.id == defaultPayment?.id, orElse: () => null);
      }
    });
  }

  // ==========================================================
  // Logic Methods
  // ==========================================================
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _addPaymentMode() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentModeScreen(
          repository: PaymentModeRepository(DatabaseHelper.instance),
        ),
      ),
    );

    if (!mounted) return;

    await _loadPaymentModes();
  }

  Future<void> _addCategory() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(repository: _categoryRepository),
      ),
    );

    if (!mounted) return;

    await _loadCategories();
  }
}
