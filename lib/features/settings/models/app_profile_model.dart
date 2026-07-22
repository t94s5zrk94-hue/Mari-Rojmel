import 'dart:convert';

/// User Profile Model
///
/// Stores application-level user preferences.
///
/// This model is persisted in SQLite and is also suitable
/// for JSON serialization during backup/restore.
class AppProfileModel {
  const AppProfileModel({
    this.id,
    required this.profileName,
    required this.accountType,
    required this.languageCode,
    required this.currencyCode,
    required this.dateFormat,
    required this.firstDayOfWeek,
    this.profilePhotoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// SQLite Primary Key
  final int? id;

  /// Profile Name
  final String profileName;

  /// personal | home
  final String accountType;

  /// gu | en
  final String languageCode;

  /// INR
  final String currencyCode;

  /// dd/MM/yyyy
  final String dateFormat;

  /// 1 = Monday
  /// 7 = Sunday
  final int firstDayOfWeek;

  /// Optional profile image path
  final String? profilePhotoPath;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Default Profile
  factory AppProfileModel.initial() {
    final now = DateTime.now();

    return AppProfileModel(
      profileName: '',
      accountType: 'personal',
      languageCode: 'gu',
      currencyCode: 'INR',
      dateFormat: 'dd/MM/yyyy',
      firstDayOfWeek: 1,
      profilePhotoPath: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  AppProfileModel copyWith({
    int? id,
    String? profileName,
    String? accountType,
    String? languageCode,
    String? currencyCode,
    String? dateFormat,
    int? firstDayOfWeek,
    String? profilePhotoPath,
    bool clearProfilePhoto = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppProfileModel(
      id: id ?? this.id,
      profileName: profileName ?? this.profileName,
      accountType: accountType ?? this.accountType,
      languageCode: languageCode ?? this.languageCode,
      currencyCode: currencyCode ?? this.currencyCode,
      dateFormat: dateFormat ?? this.dateFormat,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      profilePhotoPath: clearProfilePhoto
          ? null
          : profilePhotoPath ?? this.profilePhotoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// SQLite Map
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'profile_name': profileName,
      'account_type': accountType,
      'language_code': languageCode,
      'currency_code': currencyCode,
      'date_format': dateFormat,
      'first_day_of_week': firstDayOfWeek,
      'profile_photo_path': profilePhotoPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory AppProfileModel.fromMap(Map<String, Object?> map) {
    return AppProfileModel(
      id: map['id'] as int?,
      profileName: map['profile_name'] as String? ?? '',
      accountType: map['account_type'] as String? ?? 'personal',
      languageCode: map['language_code'] as String? ?? 'gu',
      currencyCode: map['currency_code'] as String? ?? 'INR',
      dateFormat: map['date_format'] as String? ?? 'dd/MM/yyyy',
      firstDayOfWeek: map['first_day_of_week'] as int? ?? 1,
      profilePhotoPath: map['profile_photo_path'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AppProfileModel.fromJson(String source) =>
      AppProfileModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  /// Validation
  bool get isValid {
    return profileName.trim().isNotEmpty &&
        (accountType == 'personal' || accountType == 'home') &&
        (languageCode == 'gu' || languageCode == 'en') &&
        currencyCode.isNotEmpty &&
        dateFormat.isNotEmpty &&
        firstDayOfWeek >= 1 &&
        firstDayOfWeek <= 7;
  }

  @override
  String toString() {
    return 'UserProfileModel('
        'id: $id, '
        'profileName: $profileName, '
        'accountType: $accountType, '
        'languageCode: $languageCode, '
        'currencyCode: $currencyCode, '
        'dateFormat: $dateFormat, '
        'firstDayOfWeek: $firstDayOfWeek, '
        'profilePhotoPath: $profilePhotoPath'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppProfileModel &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            profileName == other.profileName &&
            accountType == other.accountType &&
            languageCode == other.languageCode &&
            currencyCode == other.currencyCode &&
            dateFormat == other.dateFormat &&
            firstDayOfWeek == other.firstDayOfWeek &&
            profilePhotoPath == other.profilePhotoPath &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileName,
    accountType,
    languageCode,
    currencyCode,
    dateFormat,
    firstDayOfWeek,
    profilePhotoPath,
    createdAt,
    updatedAt,
  );
}
