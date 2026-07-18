import 'package:flutter/material.dart';
import '../../../core/enums/transaction_type.dart';
import '../../../core/database/database_helper.dart';
import '../../categories/models/category_model.dart';
import '../../categories/repositories/category_repository.dart';

/// ==========================================================
/// Category Report Widget
///
/// Production Ready
/// Material 3
/// Responsive
/// ==========================================================
class CategoryReport extends StatefulWidget {
  const CategoryReport({super.key, required this.reportData});

  /// categoryId -> total amount
  final Map<int, double> reportData;

  @override
  State<CategoryReport> createState() => _CategoryReportState();
}

class _CategoryReportState extends State<CategoryReport> {
  late final CategoryRepository _categoryRepository;

  List<CategoryModel> _categories = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _categoryRepository = CategoryRepository(DatabaseHelper.instance);

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final result = await _categoryRepository.getActive();

    if (!mounted) return;

    setState(() {
      _categories = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.reportData.isEmpty) {
      return const Center(child: Text('No category report available.'));
    }

    final reportItems = widget.reportData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Report',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reportItems.length,

              separatorBuilder: (context, index) => const Divider(height: 20),

              itemBuilder: (context, index) {
                final item = reportItems[index];

                final category = _categories.firstWhere(
                  (element) => element.id == item.key,
                  orElse: () => _unknownCategory,
                );

                return _CategoryTile(category: category, amount: item.value);
              },
            ),
          ],
        ),
      ),
    );
  }

  static const CategoryModel _unknownCategory = CategoryModel(
    id: -1,
    name: 'Unknown Category',
    icon: '❓',
    color: 0xFF9E9E9E,
    transactionType: TransactionType.expense,
    isDefault: false,
    isActive: true,
    sortOrder: 9999,
  );
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.amount});

  final CategoryModel category;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final color = Color(category.color);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Text(category.icon, style: const TextStyle(fontSize: 18)),
      ),
      title: Text(category.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        _formatCurrency(amount),
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  String _formatCurrency(double value) {
    return '₹${value.toStringAsFixed(2)}';
  }
}
