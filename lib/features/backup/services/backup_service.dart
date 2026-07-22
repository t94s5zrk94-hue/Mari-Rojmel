// ===============================================================
// Mari-Rojmel
// Backup Service
//
// JSON Backup Engine
// Part 1 / 4
//
// Production Ready
// ===============================================================
import 'dart:convert';
import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/database/database_constants.dart';
import '../../account/models/backup_model.dart';
import '../../../core/database/database_helper.dart';

import '../../categories/repositories/category_repository.dart';
import '../../payment_modes/repositories/payment_mode_repository.dart';
import '../../settings/repositories/settings_repository.dart';
import '../../transactions/repositories/transaction_repository.dart';

import '../../account/repositories/user_profile_repository.dart';

class BackupService {
  BackupService({DatabaseHelper? databaseHelper})
    : _categoryRepository = CategoryRepository(
        databaseHelper ?? DatabaseHelper.instance,
      ),
      _transactionRepository = TransactionRepository.instance,
      _paymentModeRepository = PaymentModeRepository(
        databaseHelper ?? DatabaseHelper.instance,
      ),
      _userProfileRepository = UserProfileRepository(
        databaseHelper ?? DatabaseHelper.instance,
      ),
      _settingsRepository = SettingsRepository(
        databaseHelper ?? DatabaseHelper.instance,
      );

  final CategoryRepository _categoryRepository;

  final TransactionRepository _transactionRepository;

  final PaymentModeRepository _paymentModeRepository;

  final UserProfileRepository _userProfileRepository;

  final SettingsRepository _settingsRepository;

  static const String _backupFolder = 'Mari-Rojmel';

  static const String _backupPrefix = 'mari_rojmel_backup';

  static const String _backupExtension = '.json';

  static const String backupVersion = '1.0.0';

  // ==========================================================
  // Backup Directory
  // ==========================================================

  Future<Directory> getBackupDirectory() async {
    Directory? root;

    if (Platform.isAndroid) {
      final directories = await getExternalStorageDirectories(
        type: StorageDirectory.downloads,
      );

      if (directories != null && directories.isNotEmpty) {
        root = directories.first;
      }
    }

    root ??= await getApplicationDocumentsDirectory();

    final directory = Directory(p.join(root.path, _backupFolder));

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory;
  }
  // ==========================================================
  // Backup File
  // ==========================================================

  Future<File> createBackupFile() async {
    final directory = await getBackupDirectory();

    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');

    return File(
      p.join(directory.path, '$_backupPrefix-$timestamp$_backupExtension'),
    );
  }

  // ==========================================================
  // Metadata
  // ==========================================================

  Future<Map<String, dynamic>> buildMetadata() async {
    return {
      'app_name': 'Mari-Rojmel',
      'backup_version': backupVersion,
      'database_version': DatabaseConstants.databaseVersion,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  // ==========================================================
  // Empty Backup Structure
  // ==========================================================

  Future<Map<String, dynamic>> createEmptyBackup() async {
    final metadata = await buildMetadata();

    return {
      'metadata': metadata,
      'categories': <Map<String, dynamic>>[],
      'transactions': <Map<String, dynamic>>[],
      'payment_modes': <Map<String, dynamic>>[],
      'user_profile': <Map<String, dynamic>>[],
      'settings': <Map<String, dynamic>>[],
      'transaction_learning': <Map<String, dynamic>>[],
    };
  }

  // ==========================================================
  // JSON Encoder
  // ==========================================================

  String encodeBackup(Map<String, dynamic> backup) {
    return const JsonEncoder.withIndent('  ').convert(backup);
  }

  // ==========================================================
  // Placeholder
  // ==========================================================

  Future<BackupModel> getBackupInfo() async {
    final files = await getBackupFiles();

    if (files.isEmpty) {
      return BackupModel(
        appName: 'Mari-Rojmel',
        appVersion: '1.0.0',
        backupVersion: backupVersion,
        createdAt: DateTime.now(),
        totalCategories: 0,
        totalTransactions: 0,
        totalPaymentModes: 0,
        totalAccounts: 0,
        databaseVersion: DatabaseConstants.databaseVersion,
      );
    }

    final latestFile = files.first as File;

    final backup = await readBackup(latestFile);

    final metadata = backup['metadata'] as Map<String, dynamic>;

    final categories = (backup['categories'] as List?) ?? [];
    final transactions = (backup['transactions'] as List?) ?? [];
    final paymentModes = (backup['payment_modes'] as List?) ?? [];
    final accounts = (backup['user_profile'] as List?) ?? [];

    return BackupModel(
      appName: metadata['app_name'] as String? ?? 'Mari-Rojmel',
      appVersion: '1.0.0',
      backupVersion: metadata['backup_version'] as String? ?? backupVersion,
      createdAt:
          DateTime.tryParse(metadata['created_at'] as String? ?? '') ??
          DateTime.now(),
      totalCategories: categories.length,
      totalTransactions: transactions.length,
      totalPaymentModes: paymentModes.length,
      totalAccounts: accounts.length,
      databaseVersion:
          metadata['database_version'] as int? ??
          DatabaseConstants.databaseVersion,
    );
  }

  Future<List<Map<String, dynamic>>> exportTransactions() async {
    final transactions = await _transactionRepository.getAll();

    return transactions.map((transaction) => transaction.toMap()).toList();
  }

  Future<List<Map<String, dynamic>>> exportCategories() async {
    final categories = await _categoryRepository.getActive();

    return categories.map((category) => category.toMap()).toList();
  }

  Future<List<Map<String, dynamic>>> exportPaymentModes() async {
    final paymentModes = await _paymentModeRepository.getActive();

    return paymentModes.map((paymentMode) => paymentMode.toMap()).toList();
  }

  Future<List<Map<String, dynamic>>> exportUserProfile() async {
    final profile = await _userProfileRepository.getProfile();

    if (profile == null) {
      return [];
    }

    return [profile.toMap()];
  }

  Future<List<Map<String, dynamic>>> exportSettings() async {
    final settings = await _settingsRepository.getSettings();

    return [settings.toMap()];
  }

  Future<Map<String, dynamic>> buildBackupJson() async {
    final backup = await createEmptyBackup();

    backup['transactions'] = await exportTransactions();

    backup['categories'] = await exportCategories();

    backup['payment_modes'] = await exportPaymentModes();

    backup['user_profile'] = await exportUserProfile();

    backup['settings'] = await exportSettings();

    return backup;
  }

  Future<BackupModel> createBackup() async {
    final backup = await buildBackupJson();

    final json = encodeBackup(backup);

    final file = await createTemporaryBackupFile();

    await file.writeAsString(json, flush: true);

    final savedPath = await saveBackupToDownloads(file);

    if (savedPath == null) {
      throw Exception('Backup save cancelled.');
    }

    await file.delete();

    final categories = backup['categories'] as List;
    final transactions = backup['transactions'] as List;
    final paymentModes = backup['payment_modes'] as List;
    final accounts = backup['user_profile'] as List;

    return BackupModel(
      appName: 'Mari-Rojmel',
      appVersion: '1.0.0',
      backupVersion: backupVersion,
      createdAt: DateTime.now(),
      totalCategories: categories.length,
      totalTransactions: transactions.length,
      totalPaymentModes: paymentModes.length,
      totalAccounts: accounts.length,
      databaseVersion: DatabaseConstants.databaseVersion,
    );
  }

  Future<List<FileSystemEntity>> getBackupFiles() async {
    final directory = await getBackupDirectory();

    if (!await directory.exists()) {
      return [];
    }

    final files = await directory.list().toList();

    files.sort((a, b) => b.path.compareTo(a.path));

    return files
        .where(
          (file) =>
              file is File &&
              file.path.toLowerCase().endsWith(_backupExtension),
        )
        .toList();
  }

  Future<bool> deleteBackup(File file) async {
    if (!await file.exists()) {
      return false;
    }

    await file.delete();

    return true;
  }

  Future<bool> backupExists(File file) async {
    return file.exists();
  }

  Future<Map<String, dynamic>> readBackup(File file) async {
    final jsonString = await file.readAsString();

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<bool> isValidBackup(File file) async {
    try {
      final backup = await readBackup(file);

      return backup.containsKey('metadata') &&
          backup.containsKey('transactions') &&
          backup.containsKey('categories') &&
          backup.containsKey('payment_modes') &&
          backup.containsKey('settings') &&
          backup.containsKey('user_profile');
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> restoreBackup(File file) async {
    if (!await backupExists(file)) {
      throw Exception('Backup file not found.');
    }

    final isValid = await isValidBackup(file);

    if (!isValid) {
      throw Exception('Invalid backup file.');
    }

    final backup = await readBackup(file);

    final categories = (backup['categories'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    await _categoryRepository.clearAll();

    await _categoryRepository.restoreAll(categories);

    final paymentModes = (backup['payment_modes'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    final mappedPaymentModes = paymentModes.map((e) {
      return {
        'id': e['id'],
        'name': e['name'] ?? e['payment_mode_name'],
        'icon': e['icon'],
        'color': e['color'],
        'sort_order': e['sort_order'],
        'is_default': e['is_default'],
        'is_active': e['is_active'],
        'created_at': e['created_at'],
        'updated_at': e['updated_at'],
      };
    }).toList();

    await _paymentModeRepository.clearAll();

    await _paymentModeRepository.restoreAll(mappedPaymentModes);

    final profileList = (backup['user_profile'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    if (profileList.isNotEmpty) {
      await _userProfileRepository.restoreProfile(profileList.first);
    }

    final settingsList = (backup['settings'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    if (settingsList.isNotEmpty) {
      await _settingsRepository.restoreSettings(settingsList.first);
    }

    final transactions = (backup['transactions'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    await _transactionRepository.clearAll();

    await _transactionRepository.restoreAll(transactions);

    return backup;
  }

  Future<File?> pickBackupFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) {
      return null;
    }

    return File(result.files.single.path!);
  }

  Future<File> createTemporaryBackupFile() async {
    final tempDir = await getTemporaryDirectory();

    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');

    final file = File(
      p.join(tempDir.path, '$_backupPrefix-$timestamp$_backupExtension'),
    );

    return file;
  }

  Future<String?> saveBackupToDownloads(File backupFile) async {
    final params = SaveFileDialogParams(
      sourceFilePath: backupFile.path,
      fileName: p.basename(backupFile.path),
    );

    return FlutterFileDialog.saveFile(params: params);
  }
}
