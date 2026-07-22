import 'dart:io';
import 'package:flutter/material.dart';
import '../models/backup_model.dart';
import '../../backup/services/backup_service.dart';
import 'restore_screen.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_spacing.dart';
import '../../../app/app_sizes.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _isLoading = false;
  final BackupService _backupService = BackupService();

  BackupModel? _lastBackup;
  List<FileSystemEntity> _backupFiles = [];

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadBackupInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore'), centerTitle: true),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: AppSpacing.cardPadding,
      children: [
        _buildErrorCard(),

        const SizedBox(height: 16),

        _buildBackupInfoCard(),

        const SizedBox(height: 16),

        _buildActionCard(),

        const SizedBox(height: 16),

        _buildHistoryCard(),
      ],
    );
  }

  Future<void> _loadBackupInformation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _backupFiles = await _backupService.getBackupFiles();
      _lastBackup = await _backupService.getBackupInfo();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createBackup() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _backupService.createBackup();

      await _loadBackupInformation();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup created successfully')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildErrorCard() {
    if (_errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: AppColors.error),
        ),
      ),
    );
  }

  Widget _buildBackupInfoCard() {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Backup Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text(
              'Create a backup before restoring or changing your data.',
            ),

            const SizedBox(height: 8),

            if (_lastBackup != null)
              Text('Last Backup : ${_lastBackup!.createdAt}'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard() {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _createBackup,
                icon: const Icon(Icons.backup),
                label: const Text('Create Backup'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RestoreScreen(),
                          ),
                        );
                      },
                icon: const Icon(Icons.restore),
                label: const Text('Restore Backup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Backup History',
              style: TextStyle(
                fontSize: AppSizes.title,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (_backupFiles.isEmpty)
              const Text('No backup found.')
            else
              ..._backupFiles.map(
                (file) => ListTile(
                  leading: const Icon(Icons.backup),
                  title: Text(file.path.split(Platform.pathSeparator).last),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await _backupService.deleteBackup(file as File);

                      await _loadBackupInformation();

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Backup deleted successfully'),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
