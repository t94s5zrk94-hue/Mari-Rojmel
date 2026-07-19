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

import 'package:flutter/material.dart';
import '../../../app/theme/theme_provider.dart';
import '../../../core/database/database_helper.dart';
import '../models/app_settings_model.dart';
import '../repositories/settings_repository.dart';
import '../services/settings_service.dart';

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
        appBar: AppBar(title: const Text('Settings')),
        body: Center(child: Text(_errorMessage!)),
      );
    }

    if (_settings == null) {
      return const Scaffold(body: Center(child: Text('Settings not found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader(title: 'Appearance'),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('Theme'),
              subtitle: Text(_themeText(_settings!.themeMode)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                debugPrint('THEME TILE TAPPED');
                _selectTheme();
              },
            ),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'Language'),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language_outlined),
              title: const Text('Language'),
              subtitle: Text(_languageText(_settings!.language)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'Regional'),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: const Text('Currency'),
              subtitle: Text(_settings!.currencySymbol),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.date_range_outlined),
              title: const Text('Date Format'),
              subtitle: Text(_dateFormatText(_settings!.dateFormat)),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'Notifications'),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              subtitle: const Text('Enable or Disable Notifications'),
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
          const _SectionHeader(title: 'About'),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('App Version'),
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
      builder: (context) => SimpleDialog(
        title: const Text('Select Theme'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, AppThemeMode.system),
            child: const Text('System'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, AppThemeMode.light),
            child: const Text('Light'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, AppThemeMode.dark),
            child: const Text('Dark'),
          ),
        ],
      ),
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
    switch (mode) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }

  String _languageText(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.gujarati:
        return 'Gujarati';
    }
  }

  String _dateFormatText(DateFormatType format) {
    switch (format) {
      case DateFormatType.ddMMyyyy:
        return 'dd/MM/yyyy';
      case DateFormatType.mmDDyyyy:
        return 'MM/dd/yyyy';
      case DateFormatType.yyyyMMdd:
        return 'yyyy-MM-dd';
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
