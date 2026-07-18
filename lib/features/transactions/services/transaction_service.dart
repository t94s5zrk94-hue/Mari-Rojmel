import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';
import '../../../core/database/database_helper.dart';
import '../repositories/transaction_learning_repository.dart';
import 'transaction_learning_service.dart';

class TransactionService {
  TransactionService._();

  static final TransactionService instance = TransactionService._();

  final TransactionRepository _repository = TransactionRepository.instance;

  final TransactionLearningService _learningService =
      TransactionLearningService(
        TransactionLearningRepository(DatabaseHelper.instance),
      );

  Future<bool> saveTransaction(TransactionModel transaction) async {
    return _repository.insert(transaction);
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    return _repository.getAll();
  }

  Future<TransactionModel?> getTransactionById(int id) async {
    return _repository.getById(id);
  }

  Future<bool> updateTransaction(TransactionModel transaction) async {
    return _repository.update(transaction);
  }

  Future<bool> deleteTransaction(int id) async {
    return _repository.softDelete(id);
  }

  Future<bool> restoreTransaction(int id) async {
    return _repository.restore(id);
  }

  Future<List<TransactionModel>> searchTransactions(String query) async {
    return _repository.search(query);
  }

  Future<List<TransactionModel>> getActiveTransactions() async {
    return _repository.getActive();
  }

  Future<List<TransactionModel>> getDeletedTransactions() async {
    return _repository.getDeleted();
  }

  // ==========================================================
  // Learning
  // ==========================================================

  Future<void> learnTransaction({
    required String originalInput,
    required int categoryId,
  }) async {
    await _learningService.learn(input: originalInput, categoryId: categoryId);
  }

  // ==========================================================
  // Save & Learn
  // ==========================================================

  Future<bool> saveAndLearn({
    required TransactionModel transaction,
    required String originalInput,
  }) async {
    final success = await saveTransaction(transaction);

    if (!success) {
      return false;
    }

    await learnTransaction(
      originalInput: originalInput,
      categoryId: transaction.categoryId,
    );

    return true;
  }
}
