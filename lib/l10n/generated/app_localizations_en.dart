// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mari Rojmel';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get reports => 'Reports';

  @override
  String get transactionCount => 'Transactions';

  @override
  String get account => 'Account';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get goodMorning => 'Morning';

  @override
  String get goodAfternoon => 'Afternoon';

  @override
  String get goodEvening => 'Evening';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get balance => 'Balance';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get categories => 'Categories';

  @override
  String get paymentModes => 'Payment Modes';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get items => 'items';

  @override
  String get noTransactionsFound => 'No transactions found.';

  @override
  String get noNote => 'No Note';

  @override
  String get retry => 'Retry';

  @override
  String get unableToLoadDashboard => 'Unable to load dashboard';

  @override
  String get deleteTransaction => 'Delete Transaction';

  @override
  String get transactions => 'Transactions';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get updateTransaction => 'Update Transaction';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get amount => 'Amount';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get description => 'Description';

  @override
  String get enterDescription => 'Enter description (Optional)';

  @override
  String get date => 'Date';

  @override
  String get type => 'Type';

  @override
  String get addCategory => 'Add Category';

  @override
  String get addPaymentMode => 'Add Payment Mode';

  @override
  String get quickEntry => 'Quick Entry';

  @override
  String get quickEntryHint => 'Example: 500 Milk';

  @override
  String get saving => 'Saving...';

  @override
  String get addBill => 'Add Bill';

  @override
  String get removeBill => 'Remove Bill';

  @override
  String get searchCategories => 'Search categories...';

  @override
  String get searchError => 'Search error.';

  @override
  String get categoryName => 'Category Name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get categoryAlreadyExists => 'Category already exists.';

  @override
  String get categoryAdded => 'Category added successfully.';

  @override
  String get categoryUpdated => 'Category updated successfully.';

  @override
  String get categoryUpdateFailed => 'Unable to update category.';

  @override
  String get categoryAddFailed => 'Unable to add category.';

  @override
  String get defaultCategoryProtected =>
      'Default categories cannot be modified.';

  @override
  String get categoryNameTaken => 'Category name already taken.';

  @override
  String deleteCategoryConfirmation(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get defaultLabel => 'DEFAULT';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String get delete => 'Delete';

  @override
  String get invalidCategory => 'Invalid category.';

  @override
  String categoryDeleted(Object name) {
    return '$name deleted.';
  }

  @override
  String get categoryRestored => 'Category restored.';

  @override
  String get unableToRestoreCategory => 'Unable to restore category.';

  @override
  String get defaultCategoryDeleteProtected =>
      'Default categories cannot be deleted.';

  @override
  String get categoryDeleteFailed => 'Unable to delete category.';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get protectedLabel => 'Protected';

  @override
  String get actions => 'Actions';

  @override
  String get edit => 'Edit';

  @override
  String get noCategoriesYet => 'No Categories Yet';

  @override
  String get createFirstCategory =>
      'Create your first category to organize your income and expenses.';

  @override
  String get undo => 'UNDO';

  @override
  String get unableToLoadCategories => 'Unable to Load Categories';

  @override
  String get categoryLoadError =>
      'Something went wrong while loading your categories.\nPlease try again.';

  @override
  String get paymentModeName => 'Payment Mode Name';

  @override
  String get paymentModeNameHint => 'e.g. Credit Card';

  @override
  String get searchPaymentModes => 'Search payment modes...';

  @override
  String get paymentModeRequired => 'Payment mode name is required';

  @override
  String get editPaymentMode => 'Edit Payment Mode';

  @override
  String get deletePaymentMode => 'Delete Payment Mode';

  @override
  String get paymentModeAlreadyExists => 'Payment mode already exists.';

  @override
  String get paymentModeAdded => 'Payment mode added successfully.';

  @override
  String get paymentModeUpdated => 'Payment mode updated successfully.';

  @override
  String paymentModeDeleted(Object name) {
    return '$name deleted.';
  }

  @override
  String get paymentModeRestored => 'Payment mode restored.';

  @override
  String get paymentModeAddFailed => 'Unable to add payment mode.';

  @override
  String get paymentModeUpdateFailed => 'Unable to update payment mode.';

  @override
  String get paymentModeDeleteFailed => 'Unable to delete payment mode.';

  @override
  String get paymentModeRestoreFailed => 'Unable to restore payment mode.';

  @override
  String get invalidPaymentMode => 'Invalid payment mode.';

  @override
  String get defaultPaymentModeProtected =>
      'Default payment modes cannot be modified.';

  @override
  String get defaultPaymentModeDeleteProtected =>
      'Default payment modes cannot be deleted.';

  @override
  String deletePaymentModeConfirmation(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get unableToLoadPaymentModes => 'Unable to Load Payment Modes';

  @override
  String get paymentModeLoadError =>
      'Something went wrong while loading your payment modes.\nPlease try again.';

  @override
  String get noPaymentModesYet => 'No Payment Modes Yet';

  @override
  String get createFirstPaymentMode => 'Create your first payment mode.';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get thisMonth => 'This Month';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get thisYear => 'This Year';

  @override
  String get customRange => 'Custom Range';

  @override
  String get reportSummary => 'Report Summary';

  @override
  String get categoryReport => 'Category Report';

  @override
  String get paymentModeReport => 'Payment Mode Report';

  @override
  String get noReportData => 'No report data available';

  @override
  String get selectDateRange => 'Select date range';

  @override
  String get fromDate => 'From Date';

  @override
  String get toDate => 'To Date';

  @override
  String get exportReport => 'Export Report';

  @override
  String get unableToLoadReports => 'Unable to load reports';

  @override
  String get reportFilter => 'Report Filter';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get custom => 'Custom';

  @override
  String get noDateRangeSelected => 'No date range selected';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get totalExpense => 'Total Expense';

  @override
  String get netBalance => 'Net Balance';

  @override
  String get totalTransactions => 'Transactions';

  @override
  String get highestIncome => 'Highest Income';

  @override
  String get highestExpense => 'Highest Expense';

  @override
  String get averageIncome => 'Average Income';

  @override
  String get averageExpense => 'Average Expense';

  @override
  String get noCategoryReportAvailable => 'No category report available';

  @override
  String get paymentModeReportTitle => 'Payment Mode Report';

  @override
  String get noPaymentModeReportAvailable =>
      'No payment mode report available.';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navReports => 'Reports';

  @override
  String get navAdd => 'Add';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navAccount => 'Account';

  @override
  String get profile => 'Profile';

  @override
  String get profileDescription => 'Manage your personal information';

  @override
  String get version => 'Version';

  @override
  String get application => 'Application';

  @override
  String get appSettings => 'App Settings';

  @override
  String get backupRestore => 'Backup & Restore';

  @override
  String get about => 'About';

  @override
  String get refresh => 'Refresh';

  @override
  String comingSoon(Object title) {
    return '$title will be available soon.';
  }

  @override
  String get name => 'Name';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get email => 'Email';

  @override
  String get address => 'Address';

  @override
  String get enterYourAddress => 'Enter your address';

  @override
  String get validName => 'Enter a valid name.';

  @override
  String get validMobileNumber => 'Enter a valid mobile number.';

  @override
  String get validEmailAddress => 'Enter a valid email address.';

  @override
  String get profileSavedSuccessfully => 'Profile saved successfully.';

  @override
  String versionLabel(Object version) {
    return 'Version $version';
  }

  @override
  String get appTagline => 'Gujarati Digital Expense & Income Manager';

  @override
  String get developer => 'Developer';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get shareApp => 'Share App';

  @override
  String get rateApp => 'Rate App';

  @override
  String get copyright => '© 2026 Mari-Rojmel';

  @override
  String get madeInIndia => 'Made with ❤️ in India';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get regional => 'Regional';

  @override
  String get currency => 'Currency';

  @override
  String get dateFormat => 'Date Format';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableDisableNotifications => 'Enable or disable notifications';

  @override
  String get appVersion => 'App Version';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get settingsNotFound => 'Settings not found';

  @override
  String get indianRupee => '₹ Indian Rupee (INR)';

  @override
  String get defaultDateFormat => 'dd/MM/yyyy (India)';
}
