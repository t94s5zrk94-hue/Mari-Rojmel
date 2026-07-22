// ===============================================================
// Mari-Rojmel
// Backup Model
//
// Stores backup metadata.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/foundation.dart';

@immutable
class BackupModel {
  const BackupModel({
    required this.appName,
    required this.appVersion,
    required this.backupVersion,
    required this.createdAt,
    required this.totalCategories,
    required this.totalTransactions,
    required this.totalPaymentModes,
    required this.totalAccounts,
    required this.databaseVersion,
  });

  // ===============================================================
  // App Information
  // ===============================================================

  final String appName;
  final String appVersion;
  final String backupVersion;

  // ===============================================================
  // Backup Information
  // ===============================================================

  final DateTime createdAt;

  // ===============================================================
  // Statistics
  // ===============================================================

  final int totalCategories;
  final int totalTransactions;
  final int totalPaymentModes;
  final int totalAccounts;

  // ===============================================================
  // Database
  // ===============================================================

  final int databaseVersion;

  // ===============================================================
  // CopyWith
  // ===============================================================

  BackupModel copyWith({
    String? appName,
    String? appVersion,
    String? backupVersion,
    DateTime? createdAt,
    int? totalCategories,
    int? totalTransactions,
    int? totalPaymentModes,
    int? totalAccounts,
    int? databaseVersion,
  }) {
    return BackupModel(
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      backupVersion: backupVersion ?? this.backupVersion,
      createdAt: createdAt ?? this.createdAt,
      totalCategories: totalCategories ?? this.totalCategories,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      totalPaymentModes: totalPaymentModes ?? this.totalPaymentModes,
      totalAccounts: totalAccounts ?? this.totalAccounts,
      databaseVersion: databaseVersion ?? this.databaseVersion,
    );
  }

  // ===============================================================
  // To Map
  // ===============================================================

  Map<String, Object?> toMap() {
    return {
      'app_name': appName,
      'app_version': appVersion,
      'backup_version': backupVersion,
      'created_at': createdAt.toIso8601String(),
      'total_categories': totalCategories,
      'total_transactions': totalTransactions,
      'total_payment_modes': totalPaymentModes,
      'total_accounts': totalAccounts,
      'database_version': databaseVersion,
    };
  }

  // ===============================================================
  // From Map
  // ===============================================================

  factory BackupModel.fromMap(Map<String, Object?> map) {
    return BackupModel(
      appName: map['app_name'] as String,
      appVersion: map['app_version'] as String,
      backupVersion: map['backup_version'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      totalCategories: map['total_categories'] as int,
      totalTransactions: map['total_transactions'] as int,
      totalPaymentModes: map['total_payment_modes'] as int,
      totalAccounts: map['total_accounts'] as int,
      databaseVersion: map['database_version'] as int,
    );
  }

  // ===============================================================
  // JSON
  // ===============================================================

  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from(toMap());
  }

  factory BackupModel.fromJson(Map<String, dynamic> json) {
    return BackupModel.fromMap(json);
  }

  // ===============================================================
  // Equality
  // ===============================================================

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is BackupModel &&
        other.appName == appName &&
        other.appVersion == appVersion &&
        other.backupVersion == backupVersion &&
        other.createdAt == createdAt &&
        other.totalCategories == totalCategories &&
        other.totalTransactions == totalTransactions &&
        other.totalPaymentModes == totalPaymentModes &&
        other.totalAccounts == totalAccounts &&
        other.databaseVersion == databaseVersion;
  }

  @override
  int get hashCode {
    return Object.hash(
      appName,
      appVersion,
      backupVersion,
      createdAt,
      totalCategories,
      totalTransactions,
      totalPaymentModes,
      totalAccounts,
      databaseVersion,
    );
  }

  @override
  String toString() {
    return 'BackupModel('
        'appName: $appName, '
        'appVersion: $appVersion, '
        'backupVersion: $backupVersion, '
        'createdAt: $createdAt, '
        'totalCategories: $totalCategories, '
        'totalTransactions: $totalTransactions, '
        'totalPaymentModes: $totalPaymentModes, '
        'totalAccounts: $totalAccounts, '
        'databaseVersion: $databaseVersion'
        ')';
  }
}
