// ===============================================================
// Mari-Rojmel
// User Profile Model
//
// Stores user profile information.
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/foundation.dart';

@immutable
class UserProfileModel {
  const UserProfileModel({
    this.id,
    required this.name,
    this.mobileNumber,
    this.email,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String name;
  final String? mobileNumber;
  final String? email;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfileModel copyWith({
    int? id,
    String? name,
    String? mobileNumber,
    String? email,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'mobile_number': mobileNumber,
      'email': email,
      'address': address,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory UserProfileModel.fromMap(Map<String, Object?> map) {
    return UserProfileModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      mobileNumber: map['mobile_number'] as String?,
      email: map['email'] as String?,
      address: map['address'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'UserProfileModel('
        'id: $id, '
        'name: $name, '
        'mobileNumber: $mobileNumber, '
        'email: $email, '
        'address: $address'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileModel &&
        other.id == id &&
        other.name == name &&
        other.mobileNumber == mobileNumber &&
        other.email == email &&
        other.address == address &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      mobileNumber,
      email,
      address,
      createdAt,
      updatedAt,
    );
  }
}
