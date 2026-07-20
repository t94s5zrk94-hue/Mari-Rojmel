import 'package:flutter/material.dart';

import '../../categories/models/category_model.dart';
import '../../../l10n/generated/app_localizations.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
    required this.onAddCategory,
  });

  final List<CategoryModel> categories;

  final CategoryModel? selectedCategory;

  final ValueChanged<CategoryModel?> onChanged;

  final VoidCallback onAddCategory;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DropdownButtonFormField<CategoryModel>(
            initialValue: selectedCategory,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.categories,
              border: const OutlineInputBorder(),
            ),
            items: categories
                .map(
                  (category) => DropdownMenuItem<CategoryModel>(
                    value: category,
                    child: Text(category.name),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),

        const SizedBox(width: 8),

        IconButton(
          tooltip: AppLocalizations.of(context)!.addCategory,
          onPressed: onAddCategory,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
