import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Mari Rojmel'**
  String get appName;

  /// Dashboard screen title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Reports screen title
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// Transaction count summary card
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionCount;

  /// Account screen title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Morning greeting
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get goodMorning;

  /// Afternoon greeting
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get goodAfternoon;

  /// Evening greeting
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get goodEvening;

  /// Dashboard welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// Current balance title
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// Income label
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// Expense label
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// Balance label
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Quick actions section
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Add transaction action
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// Categories action
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Payment modes action
  ///
  /// In en, this message translates to:
  /// **'Payment Modes'**
  String get paymentModes;

  /// Recent transactions title
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// Items suffix
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// Empty transactions message
  ///
  /// In en, this message translates to:
  /// **'No transactions found.'**
  String get noTransactionsFound;

  /// Empty note text
  ///
  /// In en, this message translates to:
  /// **'No Note'**
  String get noNote;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Dashboard load error
  ///
  /// In en, this message translates to:
  /// **'Unable to load dashboard'**
  String get unableToLoadDashboard;

  /// Delete transaction dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get deleteTransaction;

  /// Transactions screen title
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// Edit transaction screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @updateTransaction.
  ///
  /// In en, this message translates to:
  /// **'Update Transaction'**
  String get updateTransaction;

  /// Save transaction button
  ///
  /// In en, this message translates to:
  /// **'Save Transaction'**
  String get saveTransaction;

  /// Amount field label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Amount field hint
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Description field hint
  ///
  /// In en, this message translates to:
  /// **'Enter description (Optional)'**
  String get enterDescription;

  /// Transaction date field label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Transaction type field label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Tooltip for add category button
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// Tooltip for add payment mode button
  ///
  /// In en, this message translates to:
  /// **'Add Payment Mode'**
  String get addPaymentMode;

  /// Quick entry field label
  ///
  /// In en, this message translates to:
  /// **'Quick Entry'**
  String get quickEntry;

  /// Quick entry example
  ///
  /// In en, this message translates to:
  /// **'Example: 500 Milk'**
  String get quickEntryHint;

  /// Saving progress text
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Button to attach a bill image
  ///
  /// In en, this message translates to:
  /// **'Add Bill'**
  String get addBill;

  /// Button to remove the attached bill image
  ///
  /// In en, this message translates to:
  /// **'Remove Bill'**
  String get removeBill;

  /// Search category hint
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get searchCategories;

  /// Category search error
  ///
  /// In en, this message translates to:
  /// **'Search error.'**
  String get searchError;

  /// Category name field label
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// Validation message when category name is empty
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Edit category dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @categoryAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Category already exists.'**
  String get categoryAlreadyExists;

  /// No description provided for @categoryAdded.
  ///
  /// In en, this message translates to:
  /// **'Category added successfully.'**
  String get categoryAdded;

  /// No description provided for @categoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully.'**
  String get categoryUpdated;

  /// No description provided for @categoryUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to update category.'**
  String get categoryUpdateFailed;

  /// No description provided for @categoryAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to add category.'**
  String get categoryAddFailed;

  /// No description provided for @defaultCategoryProtected.
  ///
  /// In en, this message translates to:
  /// **'Default categories cannot be modified.'**
  String get defaultCategoryProtected;

  /// No description provided for @categoryNameTaken.
  ///
  /// In en, this message translates to:
  /// **'Category name already taken.'**
  String get categoryNameTaken;

  /// No description provided for @deleteCategoryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteCategoryConfirmation(Object name);

  /// Label shown for default categories
  ///
  /// In en, this message translates to:
  /// **'DEFAULT'**
  String get defaultLabel;

  /// Delete category dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @invalidCategory.
  ///
  /// In en, this message translates to:
  /// **'Invalid category.'**
  String get invalidCategory;

  /// Category deleted message
  ///
  /// In en, this message translates to:
  /// **'{name} deleted.'**
  String categoryDeleted(Object name);

  /// No description provided for @categoryRestored.
  ///
  /// In en, this message translates to:
  /// **'Category restored.'**
  String get categoryRestored;

  /// No description provided for @unableToRestoreCategory.
  ///
  /// In en, this message translates to:
  /// **'Unable to restore category.'**
  String get unableToRestoreCategory;

  /// No description provided for @defaultCategoryDeleteProtected.
  ///
  /// In en, this message translates to:
  /// **'Default categories cannot be deleted.'**
  String get defaultCategoryDeleteProtected;

  /// No description provided for @categoryDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete category.'**
  String get categoryDeleteFailed;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @protectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get protectedLabel;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @noCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No Categories Yet'**
  String get noCategoriesYet;

  /// No description provided for @createFirstCategory.
  ///
  /// In en, this message translates to:
  /// **'Create your first category to organize your income and expenses.'**
  String get createFirstCategory;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// No description provided for @unableToLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Unable to Load Categories'**
  String get unableToLoadCategories;

  /// No description provided for @categoryLoadError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading your categories.\nPlease try again.'**
  String get categoryLoadError;

  /// Payment mode name field label
  ///
  /// In en, this message translates to:
  /// **'Payment Mode Name'**
  String get paymentModeName;

  /// Payment mode name hint
  ///
  /// In en, this message translates to:
  /// **'e.g. Credit Card'**
  String get paymentModeNameHint;

  /// Search payment modes hint
  ///
  /// In en, this message translates to:
  /// **'Search payment modes...'**
  String get searchPaymentModes;

  /// Validation message
  ///
  /// In en, this message translates to:
  /// **'Payment mode name is required'**
  String get paymentModeRequired;

  /// Edit payment mode dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Payment Mode'**
  String get editPaymentMode;

  /// Delete payment mode dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Payment Mode'**
  String get deletePaymentMode;

  /// No description provided for @paymentModeAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Payment mode already exists.'**
  String get paymentModeAlreadyExists;

  /// No description provided for @paymentModeAdded.
  ///
  /// In en, this message translates to:
  /// **'Payment mode added successfully.'**
  String get paymentModeAdded;

  /// No description provided for @paymentModeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Payment mode updated successfully.'**
  String get paymentModeUpdated;

  /// No description provided for @paymentModeDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted.'**
  String paymentModeDeleted(Object name);

  /// No description provided for @paymentModeRestored.
  ///
  /// In en, this message translates to:
  /// **'Payment mode restored.'**
  String get paymentModeRestored;

  /// No description provided for @paymentModeAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to add payment mode.'**
  String get paymentModeAddFailed;

  /// No description provided for @paymentModeUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to update payment mode.'**
  String get paymentModeUpdateFailed;

  /// No description provided for @paymentModeDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete payment mode.'**
  String get paymentModeDeleteFailed;

  /// No description provided for @paymentModeRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to restore payment mode.'**
  String get paymentModeRestoreFailed;

  /// No description provided for @invalidPaymentMode.
  ///
  /// In en, this message translates to:
  /// **'Invalid payment mode.'**
  String get invalidPaymentMode;

  /// No description provided for @defaultPaymentModeProtected.
  ///
  /// In en, this message translates to:
  /// **'Default payment modes cannot be modified.'**
  String get defaultPaymentModeProtected;

  /// No description provided for @defaultPaymentModeDeleteProtected.
  ///
  /// In en, this message translates to:
  /// **'Default payment modes cannot be deleted.'**
  String get defaultPaymentModeDeleteProtected;

  /// No description provided for @deletePaymentModeConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deletePaymentModeConfirmation(Object name);

  /// No description provided for @unableToLoadPaymentModes.
  ///
  /// In en, this message translates to:
  /// **'Unable to Load Payment Modes'**
  String get unableToLoadPaymentModes;

  /// No description provided for @paymentModeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading your payment modes.\nPlease try again.'**
  String get paymentModeLoadError;

  /// No description provided for @noPaymentModesYet.
  ///
  /// In en, this message translates to:
  /// **'No Payment Modes Yet'**
  String get noPaymentModesYet;

  /// No description provided for @createFirstPaymentMode.
  ///
  /// In en, this message translates to:
  /// **'Create your first payment mode.'**
  String get createFirstPaymentMode;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @customRange.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get customRange;

  /// No description provided for @reportSummary.
  ///
  /// In en, this message translates to:
  /// **'Report Summary'**
  String get reportSummary;

  /// No description provided for @categoryReport.
  ///
  /// In en, this message translates to:
  /// **'Category Report'**
  String get categoryReport;

  /// No description provided for @paymentModeReport.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode Report'**
  String get paymentModeReport;

  /// No description provided for @noReportData.
  ///
  /// In en, this message translates to:
  /// **'No report data available'**
  String get noReportData;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select date range'**
  String get selectDateRange;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @unableToLoadReports.
  ///
  /// In en, this message translates to:
  /// **'Unable to load reports'**
  String get unableToLoadReports;

  /// No description provided for @reportFilter.
  ///
  /// In en, this message translates to:
  /// **'Report Filter'**
  String get reportFilter;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @noDateRangeSelected.
  ///
  /// In en, this message translates to:
  /// **'No date range selected'**
  String get noDateRangeSelected;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @totalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// No description provided for @totalTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get totalTransactions;

  /// No description provided for @highestIncome.
  ///
  /// In en, this message translates to:
  /// **'Highest Income'**
  String get highestIncome;

  /// No description provided for @highestExpense.
  ///
  /// In en, this message translates to:
  /// **'Highest Expense'**
  String get highestExpense;

  /// No description provided for @averageIncome.
  ///
  /// In en, this message translates to:
  /// **'Average Income'**
  String get averageIncome;

  /// No description provided for @averageExpense.
  ///
  /// In en, this message translates to:
  /// **'Average Expense'**
  String get averageExpense;

  /// No description provided for @noCategoryReportAvailable.
  ///
  /// In en, this message translates to:
  /// **'No category report available'**
  String get noCategoryReportAvailable;

  /// No description provided for @paymentModeReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode Report'**
  String get paymentModeReportTitle;

  /// No description provided for @noPaymentModeReportAvailable.
  ///
  /// In en, this message translates to:
  /// **'No payment mode report available.'**
  String get noPaymentModeReportAvailable;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get navAdd;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your personal information'**
  String get profileDescription;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestore;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'{title} will be available soon.'**
  String comingSoon(Object title);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @enterYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get enterYourAddress;

  /// No description provided for @validName.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name.'**
  String get validName;

  /// No description provided for @validMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number.'**
  String get validMobileNumber;

  /// No description provided for @validEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validEmailAddress;

  /// No description provided for @profileSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully.'**
  String get profileSavedSuccessfully;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(Object version);

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Gujarati Digital Expense & Income Manager'**
  String get appTagline;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Mari-Rojmel'**
  String get copyright;

  /// No description provided for @madeInIndia.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ in India'**
  String get madeInIndia;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @regional.
  ///
  /// In en, this message translates to:
  /// **'Regional'**
  String get regional;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get dateFormat;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enableDisableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable notifications'**
  String get enableDisableNotifications;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @settingsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Settings not found'**
  String get settingsNotFound;

  /// No description provided for @indianRupee.
  ///
  /// In en, this message translates to:
  /// **'₹ Indian Rupee (INR)'**
  String get indianRupee;

  /// No description provided for @defaultDateFormat.
  ///
  /// In en, this message translates to:
  /// **'dd/MM/yyyy (India)'**
  String get defaultDateFormat;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
