import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/services/backup_service.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:characterbook/ui/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';

class BackupButtons extends StatefulWidget {
  final CloudBackupService cloudBackupService;
  final LocalBackupService localBackupService;

  BackupButtons({
    super.key, 
    required this.cloudBackupService,
  }) : localBackupService = LocalBackupService(
          filePickerService: FilePickerService(),
          notificationService: cloudBackupService.notificationService,
        );

  @override
  State<BackupButtons> createState() => _BackupButtonsState();
}

class _BackupButtonsState extends State<BackupButtons> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.tonal(
          onPressed: _isProcessing ? null : () => _showBackupDialog(context),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(s.backup),
        ),
        FilledButton.tonal(
          onPressed: _isProcessing ? null : () => _showRestoreDialog(context),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(s.restoreData),
        ),
      ],
    );
  }

  Future<void> _showBackupDialog(BuildContext context) async {
    final s = S.of(context);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.backup_options),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildListTile(
              icon: Icons.cloud_upload,
              title: s.backup_to_cloud,
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.file_upload,
              title: s.backup_to_file,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
        ],
      ),
    );

    if (!mounted) return;

    setState(() => _isProcessing = true);
    showLoadingDialog(context: context, message: S.of(context).processing);
    
    setState(() => _isProcessing = true);
    try {
      if (result == 'cloud') {
        await widget.cloudBackupService.exportData();
      } else if (result == 'local') {
        await widget.localBackupService.exportData();
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }

    hideLoadingDialog(context);
  }

  Future<void> _showRestoreDialog(BuildContext context) async {
    final s = S.of(context);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.restore_options),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildListTile(
              icon: Icons.cloud_download,
              title: s.restore_from_cloud,
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.file_download,
              title: s.restore_from_file,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
        ],
      ),
    );

    if (!mounted) return;
    
    setState(() => _isProcessing = true);
    showLoadingDialog(context: context, message: S.of(context).processing);

    await Future.delayed(const Duration(milliseconds: 50));
    try {
      if (result == 'cloud') {
        await widget.cloudBackupService.importData();
      } else if (result == 'local') {
        await widget.localBackupService.importData();
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
    hideLoadingDialog(context);
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
  }) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        minLeadingWidth: 24,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () => Navigator.pop(context, title == S.of(context).backup_to_cloud ? 'cloud' : 'local'),
      ),
    );
  }
}