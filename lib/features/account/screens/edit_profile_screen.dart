// ===============================================================
// Mari-Rojmel
// Profile Screen
//
// User Profile Screen
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================

import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../models/user_profile_model.dart';
import '../repositories/account_repository.dart';
import '../../../app/app_spacing.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.repository});

  final IAccountRepository repository;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // ==========================================================
  // Form Key
  // ==========================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ==========================================================
  // Controllers
  // ==========================================================

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _mobileController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  // ==========================================================
  // Focus Nodes
  // ==========================================================

  final FocusNode _nameFocus = FocusNode();

  final FocusNode _mobileFocus = FocusNode();

  final FocusNode _emailFocus = FocusNode();

  final FocusNode _addressFocus = FocusNode();

  // ==========================================================
  // State
  // ==========================================================

  bool _isLoading = true;

  bool _isSaving = false;

  UserProfileModel? _profile;

  // ==========================================================
  // Init
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ==========================================================
  // Dispose
  // ==========================================================

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();

    _nameFocus.dispose();
    _mobileFocus.dispose();
    _emailFocus.dispose();
    _addressFocus.dispose();

    super.dispose();
  }

  // ==========================================================
  // Load Profile
  // ==========================================================

  Future<void> _loadProfile() async {
    final profile = await widget.repository.getProfile();

    if (!mounted) {
      return;
    }

    if (profile != null) {
      _profile = profile;

      _nameController.text = profile.name;
      _mobileController.text = profile.mobileNumber ?? '';
      _emailController.text = profile.email ?? '';
      _addressController.text = profile.address ?? '';
    }

    setState(() {
      _isLoading = false;
    });
  }

  // ==========================================================
  // Save Profile
  // ==========================================================

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final profile = UserProfileModel(
        id: 1,
        name: _nameController.text.trim(),
        mobileNumber: _mobileController.text.trim().isEmpty
            ? null
            : _mobileController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        createdAt: _profile?.createdAt,
        updatedAt: DateTime.now(),
      );

      final success = await widget.repository.hasProfile()
          ? await widget.repository.updateProfile(profile)
          : await widget.repository.saveProfile(profile);

      if (!mounted) {
        return;
      }

      if (success) {
        _profile = profile;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.profileSavedSuccessfully,
            ),
          ),
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // ==========================================================
  // Validators
  // ==========================================================

  String? _validateName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return AppLocalizations.of(context)!.nameRequired;
    }

    if (text.length < 2) {
      return AppLocalizations.of(context)!.validName;
    }

    return null;
  }

  String? _validateMobile(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return null;
    }

    final mobileRegExp = RegExp(r'^[0-9]{10}$');

    if (!mobileRegExp.hasMatch(text)) {
      return AppLocalizations.of(context)!.validMobileNumber;
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return null;
    }

    final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegExp.hasMatch(text)) {
      return AppLocalizations.of(context)!.validEmailAddress;
    }

    return null;
  }

  // ==========================================================
  // Build
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              onPressed: _isSaving ? null : _saveProfile,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(AppLocalizations.of(context)!.save),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: SingleChildScrollView(
                padding: AppSpacing.cardPadding,
                child: Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const CircleAvatar(
                          radius: 42,
                          child: Icon(Icons.person, size: 42),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.name,
                            hintText: AppLocalizations.of(
                              context,
                            )!.enterYourName,
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          validator: _validateName,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_mobileFocus);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _mobileController,
                          focusNode: _mobileFocus,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(
                              context,
                            )!.mobileNumber,
                            hintText: '9876543210',
                            prefixIcon: Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          textInputAction: TextInputAction.next,
                          maxLength: 10,
                          validator: _validateMobile,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_emailFocus);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.email,
                            hintText: 'example@email.com',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: _validateEmail,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_addressFocus);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _addressController,
                          focusNode: _addressFocus,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.address,
                            hintText: AppLocalizations.of(
                              context,
                            )!.enterYourAddress,
                            prefixIcon: Icon(Icons.home_outlined),
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          keyboardType: TextInputType.streetAddress,
                          autofillHints: const [
                            AutofillHints.fullStreetAddress,
                          ],
                          textInputAction: TextInputAction.done,
                          maxLines: 3,
                          minLines: 3,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
