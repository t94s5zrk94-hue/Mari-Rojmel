// ===============================================================
// Mari-Rojmel
// Account Screen
//
// Account Dashboard
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'edit_profile_screen.dart';
import '../repositories/account_repository.dart';
import '../../settings/screens/settings_screen.dart';
import 'backup_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, required this.repository});

  final IAccountRepository repository;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // ==========================================================
  // Constants
  // ==========================================================

  static const String _appVersion = 'v1.0.0';

  // ==========================================================
  // Navigation
  // ==========================================================

  Future<void> _openProfile() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(repository: widget.repository),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ==========================================================
  // Build
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.account),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context)!.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildSectionTitle(AppLocalizations.of(context)!.profile),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(AppLocalizations.of(context)!.profile),
                    subtitle: Text(
                      AppLocalizations.of(context)!.profileDescription,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _openProfile,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(AppLocalizations.of(context)!.version),
                subtitle: const Text(_appVersion),
                enabled: false,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(AppLocalizations.of(context)!.application),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: Text(AppLocalizations.of(context)!.appSettings),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.backup_outlined),
                    title: Text(AppLocalizations.of(context)!.backupRestore),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BackupScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(AppLocalizations.of(context)!.about),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AboutScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // Widgets
  // ==========================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
