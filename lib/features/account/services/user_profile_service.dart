// ===============================================================
// Mari-Rojmel
// User Profile Service
//
// Business Logic Layer
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import '../models/user_profile_model.dart';

import '../repositories/user_profile_repository.dart';

class UserProfileService {
  const UserProfileService(this._repository);

  final IUserProfileRepository _repository;
  Future<UserProfileModel?> getProfile() {
    return _repository.getProfile();
  }

  Future<bool> hasProfile() {
    return _repository.hasProfile();
  }
  // ===============================================================
  // Validation
  // ===============================================================

  void _validate(UserProfileModel profile) {
    if (profile.name.trim().isEmpty) {
      throw const FormatException('Name is required.');
    }

    if (profile.name.trim().length > 100) {
      throw const FormatException('Name must not exceed 100 characters.');
    }

    if (profile.mobileNumber != null &&
        profile.mobileNumber!.trim().isNotEmpty) {
      final mobile = profile.mobileNumber!.trim();

      final mobileRegex = RegExp(r'^[6-9]\d{9}$');

      if (!mobileRegex.hasMatch(mobile)) {
        throw const FormatException('Enter a valid mobile number.');
      }
    }

    if (profile.email != null && profile.email!.trim().isNotEmpty) {
      final email = profile.email!.trim();

      final emailRegex = RegExp(
        r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
      );

      if (!emailRegex.hasMatch(email)) {
        throw const FormatException('Enter a valid email address.');
      }
    }
  }
  // ===============================================================
  // Save Profile
  // ===============================================================

  Future<bool> saveProfile(UserProfileModel profile) async {
    _validate(profile);

    final cleanedProfile = profile.copyWith(
      name: profile.name.trim(),
      mobileNumber: profile.mobileNumber?.trim(),
      email: profile.email?.trim(),
      address: profile.address?.trim(),
    );

    return _repository.saveProfile(cleanedProfile);
  }

  // ===============================================================
  // Update Profile
  // ===============================================================

  Future<bool> updateProfile(UserProfileModel profile) async {
    _validate(profile);

    final cleanedProfile = profile.copyWith(
      name: profile.name.trim(),
      mobileNumber: profile.mobileNumber?.trim(),
      email: profile.email?.trim(),
      address: profile.address?.trim(),
    );

    return _repository.updateProfile(cleanedProfile);
  }
  // ===============================================================
  // Delete Profile
  // ===============================================================

  Future<bool> deleteProfile() {
    return _repository.deleteProfile();
  }
}
