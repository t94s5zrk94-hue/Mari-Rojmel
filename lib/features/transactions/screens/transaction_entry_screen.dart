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
import '../services/transaction_parser.dart';
import '../../../core/database/database_helper.dart';
import '../../categories/repositories/category_repository.dart';
import '../repositories/transaction_learning_repository.dart';
import '../../payment_modes/screens/payment_mode_screen.dart';
import '../../payment_modes/repositories/payment_mode_repository.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';

class TransactionEntryScreen extends StatefulWidget {
  const TransactionEntryScreen({super.key});

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
  bool _isSaving = false;

  final List<CategoryModel> _categories = <CategoryModel>[];
  final List<PaymentModeModel> _paymentModes = <PaymentModeModel>[];

  late final TransactionParser _transactionParser;
  final TransactionRepository _transactionRepository =
      TransactionRepository.instance;

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
      learningRepository: TransactionLearningRepository(
        DatabaseHelper.instance,
      ),
      categoryRepository: CategoryRepository(DatabaseHelper.instance),
    );

    _loadCategories();
    _loadPaymentModes();
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
      appBar: AppBar(title: const Text('Add Transaction')),
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
      debugPrint("===== SAVE START =====");

      if (_selectedCategory == null || _selectedPaymentMode == null) {
        debugPrint("Category or PaymentMode is null");
        return;
      }

      final amount = double.tryParse(_amountController.text.trim());

      debugPrint("Amount = $amount");
      debugPrint("Category = ${_selectedCategory!.id}");
      debugPrint("Payment = ${_selectedPaymentMode!.id}");

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

      debugPrint("Before Insert");

      final success = await _transactionRepository.insert(model);

      debugPrint("Insert Result = $success");

      if (!mounted) return;

      if (success) {
        debugPrint("Navigator Pop");
        Navigator.pop(context, true);
      }
    } catch (e, s) {
      debugPrint("SAVE ERROR = $e");
      debugPrint("$s");
    }
  }
  
  Future<void> _onQuickEntryChanged(String value) async {
    if (value.trim().isEmpty) {
      return;
    }

    final parsed = await _transactionParser.parse(value);

    debugPrint('Input : $value');
    debugPrint('Amount : ${parsed.amount}');

    if (parsed.amount != null) {
      setState(() {
        _amountController.text = parsed.amount!.toStringAsFixed(0);
      });
    }
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryRepository.getActive(
      transactionType: _selectedType,
    );

    if (!mounted) return;

    setState(() {
      _categories
        ..clear()
        ..addAll(categories);
    });
  }

  Future<void> _loadPaymentModes() async {
    final paymentModes = await PaymentModeRepository(
      DatabaseHelper.instance,
    ).getActive();

    if (!mounted) return;

    setState(() {
      _paymentModes
        ..clear()
        ..addAll(paymentModes);
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
    