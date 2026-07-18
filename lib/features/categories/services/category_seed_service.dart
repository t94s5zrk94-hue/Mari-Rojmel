import '../models/category_model.dart';
import '../../../core/enums/transaction_type.dart';

class CategorySeedService {
  CategorySeedService._();

  static List<CategoryModel> getDefaultCategories() {
    return const [
      // ===========================
      // Income Categories
      // ===========================
      CategoryModel(
        id: null,
        name: 'Salary',
        icon: '💰',
        color: 0xFF4CAF50,
        transactionType: TransactionType.income,
        isDefault: true,
        isActive: true,
        sortOrder: 1,
      ),

      CategoryModel(
        id: null,
        name: 'Business',
        icon: '🏪',
        color: 0xFF009688,
        transactionType: TransactionType.income,
        isDefault: true,
        isActive: true,
        sortOrder: 2,
      ),

      CategoryModel(
        id: null,
        name: 'Interest',
        icon: '🏦',
        color: 0xFF3F51B5,
        transactionType: TransactionType.income,
        isDefault: true,
        isActive: true,
        sortOrder: 3,
      ),

      CategoryModel(
        id: null,
        name: 'Gift',
        icon: '🎁',
        color: 0xFFE91E63,
        transactionType: TransactionType.income,
        isDefault: true,
        isActive: true,
        sortOrder: 4,
      ),

      CategoryModel(
        id: null,
        name: 'Refund',
        icon: '↩️',
        color: 0xFF00BCD4,
        transactionType: TransactionType.income,
        isDefault: true,
        isActive: true,
        sortOrder: 5,
      ),

      CategoryModel(
        id: null,
        name: 'Other Income',
        icon: '➕',
        color: 0xFF8BC34A,
        transactionType: TransactionType.income,
        isDefault: true,
        isActive: true,
        sortOrder: 6,
      ),

      // ===========================
      // Expense Categories
      // ===========================
      CategoryModel(
        id: null,
        name: 'Food',
        icon: '🍽️',
        color: 0xFFFF9800,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 101,
      ),

      CategoryModel(
        id: null,
        name: 'Grocery',
        icon: '🛒',
        color: 0xFFFF5722,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 102,
      ),

      CategoryModel(
        id: null,
        name: 'Petrol / Diesel / CNG / EV Charging',
        icon: '⛽',
        color: 0xFF795548,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 103,
      ),

      CategoryModel(
        id: null,
        name: 'Medicine',
        icon: '💊',
        color: 0xFFF44336,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 104,
      ),

      CategoryModel(
        id: null,
        name: 'Electricity',
        icon: '⚡',
        color: 0xFFFFC107,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 105,
      ),

      CategoryModel(
        id: null,
        name: 'Mobile Recharge',
        icon: '📱',
        color: 0xFF2196F3,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 106,
      ),

      CategoryModel(
        id: null,
        name: 'Internet',
        icon: '🌐',
        color: 0xFF03A9F4,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 107,
      ),

      CategoryModel(
        id: null,
        name: 'Rent',
        icon: '🏠',
        color: 0xFF9C27B0,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 108,
      ),

      CategoryModel(
        id: null,
        name: 'Education',
        icon: '🎓',
        color: 0xFF673AB7,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 109,
      ),

      CategoryModel(
        id: null,
        name: 'Entertainment',
        icon: '🎬',
        color: 0xFFE91E63,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 110,
      ),

      CategoryModel(
        id: null,
        name: 'Shopping',
        icon: '🛍️',
        color: 0xFF9E9E9E,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 111,
      ),

      CategoryModel(
        id: null,
        name: 'Travel',
        icon: '✈️',
        color: 0xFF00ACC1,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 112,
      ),

      CategoryModel(
        id: null,
        name: 'EMI',
        icon: '💳',
        color: 0xFF607D8B,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 113,
      ),

      CategoryModel(
        id: null,
        name: 'Insurance',
        icon: '🛡️',
        color: 0xFF5D4037,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 114,
      ),

      CategoryModel(
        id: null,
        name: 'Donation',
        icon: '🙏',
        color: 0xFF8BC34A,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 115,
      ),

      CategoryModel(
        id: null,
        name: 'Other Expense',
        icon: '📦',
        color: 0xFF607D8B,
        transactionType: TransactionType.expense,
        isDefault: true,
        isActive: true,
        sortOrder: 116,
      ),
    ];
  }
}
