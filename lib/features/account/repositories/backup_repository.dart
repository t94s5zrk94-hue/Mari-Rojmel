// ===============================================================
// Mari-Rojmel
// Backup Repository
//
// Backup & Restore Repository
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import '../models/backup_model.dart';

// ===============================================================
// Repository Contract
// ===============================================================

abstract interface class IBackupRepository {
  Future<String> createBackup();

  Future<void> restoreBackup(String backupFilePath);

  Future<BackupModel> getBackupInfo();

  Future<bool> backupExists();

  Future<void> deleteBackup();
}

// ===============================================================
// Repository
// ===============================================================

class BackupRepository implements IBackupRepository {
  const BackupRepository();

  @override
  Future<String> createBackup() {
    throw UnimplementedError(
      'Backup implementation will be provided in BackupService.',
    );
  }

  @override
  Future<void> restoreBackup(String backupFilePath) {
    throw UnimplementedError(
      'Restore implementation will be provided in BackupService.',
    );
  }

  @override
  Future<BackupModel> getBackupInfo() {
    throw UnimplementedError('Backup information is not available.');
  }

  @override
  Future<bool> backupExists() async {
    return false;
  }

  @override
  Future<void> deleteBackup() {
    throw UnimplementedError(
      'Delete backup implementation will be provided in BackupService.',
    );
  }
}
