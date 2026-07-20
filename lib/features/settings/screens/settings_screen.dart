// ===============================================================
// Mari-Rojmel
// Settings Screen
//
// Application Settings
//
// Production Ready
// Flutter 3.x
// Material 3
// ===============================================================
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/theme_provider.dart';
import '../../../core/database/database_helper.dart';
import '../models/app_settings_model.dart';
import '../repositories/settings_repository.dart';
import '../services/settings_service.dart';
import '../../language/screens/language_screen.dart';
import '../../../core/localization/app_locale.dart';
import '../../../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsService _service;

  AppSettingsModel? _settings;

  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _service = SettingsService(SettingsRepository(DatabaseHelper.instance));

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _service.getSettings();

      if (!mounted) return;

      setState(() {
        _settings = settings;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('SETTINGS SCREEN BUILD');
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
        body: Center(child: Text(_errorMessage!)),
      );
    }

    if (_settings == null) {
      return Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context)!.settingsNotFound),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: AppLocalizations.of(context)!.appearance),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: Text(AppLocalizations.of(context)!.theme),
              subtitle: Text(_themeText(_settings!.themeMode)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                debugPrint('THEME TILE TAPPED');
                _selectTheme();
              },
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: AppLocalizations.of(context)!.language),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language_outlined),
              title: Text(AppLocalizations.of(context)!.language),
              subtitle: Text(
                languageController.state.appLocale == AppLocale.english
                    ? 'English'
                    : 'ગુજરાતી',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => LanguageScreen()));

                if (!mounted) return;

                final settings = await _service.getSettings();

                setState(() {
                  _settings = settings;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: AppLocalizations.of(context)!.regional),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: Text(AppLocalizations.of(context)!.currency),
              subtitle: Text(AppLocalizations.of(context)!.indianRupee),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.date_range_outlined),
              title: Text(AppLocalizations.of(context)!.dateFormat),
              subtitle: Text(AppLocalizations.of(context)!.defaultDateFormat),
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: AppLocalizations.of(context)!.notifications),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: Text(AppLocalizations.of(context)!.notifications),
              subtitle: Text(
                AppLocalizations.of(context)!.enableDisableNotifications,
              ),
              value: _settings!.notificationsEnabled,
              onChanged: (value) async {
                await _service.updateNotifications(value);

                final settings = await _service.getSettings();

                if (!mounted) return;

                setState(() {
                  _settings = settings;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: AppLocalizations.of(context)!.about),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(AppLocalizations.of(context)!.appVersion),
              subtitle: Text('v1.0.0'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTheme() async {
    final theme = await showDialog<AppThemeMode>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(context)!;

        return SimpleDialog(
          title: Text(l10n.selectTheme),
          children: [
            SimpleDialogOption(
              onPressed: () =>
                  Navigator.pop(dialogContext, AppThemeMode.system),
              child: Text(l10n.system),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, AppThemeMode.light),
              child: Text(l10n.light),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, AppThemeMode.dark),
              child: Text(l10n.dark),
            ),
          ],
        );
      },
    );

    if (theme == null) {
      return;
    }

    await _service.updateTheme(theme);

    themeController.setTheme(theme);

    final settings = await _service.getSettings();

    if (!mounted) {
      return;
    }

    setState(() {
      _settings = settings;
    });
  }

  String _themeText(AppThemeMode mode) {
    final l10n = AppLocalizations.of(context)!;

    switch (mode) {
      case AppThemeMode.system:
        return l10n.system;

      case AppThemeMode.light:
        return l10n.light;

      case AppThemeMode.dark:
        return l10n.dark;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
