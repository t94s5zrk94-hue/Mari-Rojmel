// ===============================================================
// Mari-Rojmel
// Category Detector
//
// Detects category from tokenized transaction.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import '../../../core/enums/transaction_type.dart';
import '../../categories/models/category_model.dart';
import '../../categories/repositories/category_repository.dart';

class CategoryDetector {
  const CategoryDetector(this._repository);

  final CategoryRepository _repository;

  Future<CategoryModel?> detect(
    List<String> tokens, {
    TransactionType? transactionType,
  }) async {
    final categories = await _repository.getActive(
      transactionType: transactionType,
    );

    for (final token in tokens) {
      final normalized = token.trim().toLowerCase();

      for (final category in categories) {
        if (category.name.toLowerCase() == normalized) {
          return category;
        }
      }
    }

    return null;
  }
  // ===============================================================
  // Find By Id
  // ===============================================================

  Future<CategoryModel?> findById(int id) async {
    return _repository.getById(id);
  }

  Future<bool> hasCategory(
    List<String> tokens, {
    TransactionType? transactionType,
  }) async {
    return await detect(tokens, transactionType: transactionType) != null;
  }

  Future<String?> extractToken(
    List<String> tokens, {
    TransactionType? transactionType,
  }) async {
    final category = await detect(tokens, transactionType: transactionType);

    if (category == null) {
      return null;
    }

    return category.name;
  }
}
