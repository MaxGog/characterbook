import 'package:flutter/material.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/services/cloud_backup_service.dart';
import 'package:characterbook/services/local_backup_service.dart';

class BackupButtons extends StatelessWidget {
  final CloudBackupService cloudBackupService;
  final LocalBackupService localBackupService = LocalBackupService();

  BackupButtons({super.key, required this.cloudBackupService});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    Theme.of(context);
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.tonal(
          onPressed: () => _showBackupDialog(context),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(s.backup),
        ),
        FilledButton.tonal(
          onPressed: () => _showRestoreDialog(context),
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

  void _showBackupDialog(BuildContext context) {
    final s = S.of(context);
    Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.backup_options),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildListTile(
              context,
              icon: Icons.cloud_upload,
              title: s.backup_to_cloud,
              onTap: () {
                Navigator.pop(context);
                cloudBackupService.exportAllToCloud(context);
              },
            ),
            const Divider(height: 1),
            _buildListTile(
              context,
              icon: Icons.file_upload,
              title: s.backup_to_file,
              onTap: () {
                Navigator.pop(context);
                localBackupService.exportAllToFile(context);
              },
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
  }

  void _showRestoreDialog(BuildContext context) {
    final s = S.of(context);
    Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.restore_options),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildListTile(
              context,
              icon: Icons.cloud_download,
              title: s.restore_from_cloud,
              onTap: () {
                Navigator.pop(context);
                cloudBackupService.importAllFromCloud(context);
              },
            ),
            const Divider(height: 1),
            _buildListTile(
              context,
              icon: Icons.file_download,
              title: s.restore_from_file,
              onTap: () {
                Navigator.pop(context);
                localBackupService.restoreData();
              },
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
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
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
        onTap: onTap,
      ),
    );
  }
}