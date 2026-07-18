import '../models/transaction_learning_model.dart';
import '../repositories/transaction_learning_repository.dart';
import 'amount_parser.dart';
import 'date_parser.dart';
import 'payment_mode_parser.dart';

class TransactionLearningService {
  TransactionLearningService(this._repository);

  final TransactionLearningRepository _repository;

  static const int _minKeywordLength = 2;

  static const Set<String> _ignoredKeywords = {
    '',
    'a',
    'an',
    'the',
    'to',
    'for',
    'and',
    'or',
    'of',
    'is',
    'are',
    'ના',
    'ની',
    'નું',
    'ને',
    'અને',
    'છે',
    'હતું',
    'થી',
    'પર',
  };

  Future<void> learn({required String input, required int categoryId}) async {
    final keyword = _extractKeyword(input);

    if (!_isValidKeyword(keyword)) {
      return;
    }

    final existing = await _repository.findByKeyword(keyword);

    if (existing != null) {
      await _repository.incrementUseCount(keyword);
      return;
    }

    final now = DateTime.now();
    final model = TransactionLearningModel(
      keyword: keyword,
      categoryId: categoryId,
      useCount: 1,
      lastUsedAt: now,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.saveLearning(model);
  }

  String _extractKeyword(String input) {
    var result = input.trim();
    result = AmountParser.removeAmount(result);
    result = DateParser.removeDate(result);
    result = PaymentModeParser.removePaymentMode(result);
    return _normalize(result);
  }

  String _normalize(String input) {
    final words = input
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .where((word) => !_ignoredKeywords.contains(word))
        .toList();

    return words.join(' ');
  }

  bool _isValidKeyword(String keyword) {
    if (keyword.isEmpty) return false;
    if (keyword.length < _minKeywordLength) return false;
    if (_ignoredKeywords.contains(keyword)) return false;
    if (RegExp(r'^[0-9\s]+$').hasMatch(keyword)) return false;
    return true;
  }
}
