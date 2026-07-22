import 'package:flutter/material.dart';
import 'dart:io';
import '../../../app/app_spacing.dart';
import '../../../app/app_sizes.dart';
import '../../backup/services/backup_service.dart';

class RestoreScreen extends StatefulWidget {
  const RestoreScreen({super.key});

  @override
  State<RestoreScreen> createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen> {
  final BackupService _backupService = BackupService();

  List<FileSystemEntity> _backupFiles = [];

  bool _isLoading = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBackups();
  }

  Future<void> _loadBackups() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _backupFiles = await _backupService.getBackupFiles();
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

  Future<void> _confirmRestore(File file) async {
    debugPrint("STEP 1 - Restore Started");

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restore Backup'),
          content: const Text(
            'This will overwrite your current data.\n\nDo you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await _backupService.restoreBackup(file);
      debugPrint("STEP 2 - Restore Completed");

      await _loadBackups();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup restored successfully.')),
      );
    } catch (e, s) {
      debugPrint("RESTORE ERROR: $e");
      debugPrint("$s");

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restore Backup')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return ListView(
      padding: AppSpacing.cardPadding,
      children: [
        _buildWarningCard(),
        const SizedBox(height: 16),
        _buildRestoreHistoryCard(),
      ],
    );
  }

  Widget _buildWarningCard() {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Restore Warning',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Restoring a backup will overwrite the current application data.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestoreHistoryCard() {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Backups',
              style: TextStyle(
                fontSize: AppSizes.title,
                fontWeight: FontWeight.bold,
              ),
            ),
            FilledButton.icon(
              onPressed: _isLoading
                  ? null
                  : () async {
                      final file = await _backupService.pickBackupFile();

                      if (file == null) {
                        return;
                      }

                      await _confirmRestore(file);
                    },
              icon: const Icon(Icons.folder_open),
              label: const Text('Select Backup File'),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 12),

            if (_backupFiles.isEmpty)
              const Text('No backup found.')
            else
              ..._backupFiles.map(
                (file) => ListTile(
                  leading: const Icon(Icons.backup),
                  title: Text(file.path.split(Platform.pathSeparator).last),
                  trailing: IconButton(
                    icon: const Icon(Icons.restore),
                    onPressed: _isLoading
                        ? null
                        : () => _confirmRestore(file as File),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
