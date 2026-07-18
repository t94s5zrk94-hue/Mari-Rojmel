// ===============================================================
// Mari-Rojmel
// Database Constants
//
// Centralized SQLite database configuration.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

class DatabaseConstants {
  const DatabaseConstants._();

  // ==========================================================
  // Database Constants
  // ==========================================================

  static const String databaseName = 'mari_rojmel.db';

  static const int databaseVersion = 5;

  // ==========================================================
  // Common Columns
  // ==========================================================

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String isDeleted = 'is_deleted';

  // ==========================================================
  // Tables
  // ==========================================================

  static const String transactionsTable = 'transactions';

  static const String categoriesTable = 'categories';

  static const String paymentModesTable = 'payment_modes';

  // ==========================================================
  // Transaction Columns
  // ==========================================================

  static const String amount = 'amount';

  static const String transactionType = 'transaction_type';

  static const String categoryId = 'category_id';

  static const String paymentModeId = 'payment_mode_id';

  static const String transactionDate = 'transaction_date';

  static const String note = 'note';

  // ==========================================================
  // Category Columns
  // ==========================================================

  static const String categoryName = 'name';

  static const String categoryIcon = 'icon';

  static const String categoryColor = 'color';

  static const String categorySortOrder = 'sort_order';

  static const String categoryIsDefault = 'is_default';

  static const String categoryIsActive = 'is_active';

  static const String categoryTransactionType = 'transaction_type';

  // ==========================================================
  // Payment Mode Columns
  // ==========================================================

  static const String paymentModeName = 'name';

  static const String paymentModeIcon = 'icon';

  static const String paymentModeColor = 'color';

  static const String paymentModeSortOrder = 'sort_order';

  static const String paymentModeIsDefault = 'is_default';

  static const String paymentModeIsActive = 'is_active';

  // ==========================================================
  // Transaction Learning Table
  // ==========================================================

  static const String transactionLearningTable = 'transaction_learning';

  static const String keyword = 'keyword';

  static const String useCount = 'use_count';

  static const String lastUsedAt = 'last_used_at';

  // ==========================================================
  // User Profile Table
  // ==========================================================

  static const String userProfileTable = 'user_profile';

  // Columns
  static const String columnUserId = 'id';
  static const String columnUserName = 'name';
  static const String columnUserMobileNumber = 'mobile_number';
  static const String columnUserEmail = 'email';
  static const String columnUserAddress = 'address';
  static const String columnUserCreatedAt = 'created_at';
  static const String columnUserUpdatedAt = 'updated_at';
}
