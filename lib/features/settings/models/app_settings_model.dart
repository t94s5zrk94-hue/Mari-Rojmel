// ===============================================================
// Mari-Rojmel
// App Settings Model
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================
import '../../../core/database/database_constants.dart';
import 'dart:convert';

enum AppThemeMode { system, light, dark }

enum AppLanguage { english, gujarati }

enum DateFormatType { ddMMyyyy, mmDDyyyy, yyyyMMdd }

class AppSettingsModel {
  const AppSettingsModel({
    this.themeMode = AppThemeMode.system,
    this.language = AppLanguage.english,
    this.currencySymbol = '₹',
    this.dateFormat = DateFormatType.ddMMyyyy,
    this.notificationsEnabled = true,
    required this.createdAt,
    required this.updatedAt,
  });

  final AppThemeMode themeMode;
  final AppLanguage language;
  final String currencySymbol;
  final DateFormatType dateFormat;
  final bool notificationsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppSettingsModel copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
    String? currencySymbol,
    DateFormatType? dateFormat,
    bool? notificationsEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppSettingsModel(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      dateFormat: dateFormat ?? this.dateFormat,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.columnThemeMode: themeMode.name,
      DatabaseConstants.columnLanguage: language.name,
      DatabaseConstants.columnCurrencySymbol: currencySymbol,
      DatabaseConstants.columnDateFormat: dateFormat.name,
      DatabaseConstants.columnNotificationsEnabled: notificationsEnabled
          ? 1
          : 0,
      DatabaseConstants.createdAt: createdAt.toIso8601String(),
      DatabaseConstants.updatedAt: updatedAt.toIso8601String(),
    };
  }

  factory AppSettingsModel.fromMap(Map<String, dynamic> map) {
    return AppSettingsModel(
      themeMode: AppThemeMode.values.firstWhere(
        (e) => e.name == map[DatabaseConstants.columnThemeMode],
      ),
      language: AppLanguage.values.firstWhere(
        (e) => e.name == map[DatabaseConstants.columnLanguage],
      ),
      currencySymbol: map[DatabaseConstants.columnCurrencySymbol] as String,
      dateFormat: DateFormatType.values.firstWhere(
        (e) => e.name == map[DatabaseConstants.columnDateFormat],
      ),
      notificationsEnabled:
          (map[DatabaseConstants.columnNotificationsEnabled] as int) == 1,
      createdAt: DateTime.parse(map[DatabaseConstants.createdAt] as String),
      updatedAt: DateTime.parse(map[DatabaseConstants.updatedAt] as String),
    );
  }
  String toJson() => jsonEncode(toMap());

  factory AppSettingsModel.fromJson(String source) =>
      AppSettingsModel.fromMap(jsonDecode(source));

  @override
  bool operator ==(Object other) {
    return other is AppSettingsModel &&
        other.themeMode == themeMode &&
        other.language == language &&
        other.currencySymbol == currencySymbol &&
        other.dateFormat == dateFormat &&
        other.notificationsEnabled == notificationsEnabled &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    themeMode,
    language,
    currencySymbol,
    dateFormat,
    notificationsEnabled,
    createdAt,
    updatedAt,
  );
}
