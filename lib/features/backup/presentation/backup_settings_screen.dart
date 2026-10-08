import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/features/backup/domain/backup_manager.dart';
import 'package:characterbook/features/backup/presentation/auto_backup_provider.dart';
import 'package:characterbook/features/backup/presentation/backup_controller.dart';
import 'package:characterbook/services/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BackupSettingsScreen extends StatefulWidget {
  const BackupSettingsScreen({super.key});

  @override
  State<BackupSettingsScreen> createState() => _BackupSettingsScreenState();
}

class _BackupSettingsScreenState extends State<BackupSettingsScreen> {
  Future<void> _runBackup(
    Future<void> Function() action,
    String successMessage,
    String failureMessage,
  ) async {
    try {
      await action();
      if (mounted) AppNavigator.showSuccess(successMessage);
    } on EmptyBackupException {
      if (mounted) AppNavigator.showInfo(S.of(context).no_data_for_backup);
    } catch (e) {
      if (mounted) AppNavigator.showError('$failureMessage: $e');
    }
  }

  Future<void> _exportLocal() => _runBackup(
        context.read<BackupController>().exportLocalBackup,
        S.of(context).local_backup_success,
        S.of(context).local_backup_error,
      );

  Future<void> _exportCloud() => _runBackup(
        context.read<BackupController>().exportCloudBackup,
        S.of(context).cloud_backup_full_success,
        S.of(context).cloud_backup_error,
      );

  Future<void> _importLocal() async {
    final confirmed = await _showRestoreWarning();
    if (!mounted || confirmed != true) return;

    await _runBackup(
      context.read<BackupController>().importLocalBackup,
      S.of(context).local_restore_success,
      S.of(context).local_restore_error,
    );
  }

  Future<void> _importCloud() async {
    final confirmed = await _showRestoreWarning();
    if (!mounted || confirmed != true) return;

    await _runBackup(
      context.read<BackupController>().importCloudBackup,
      S.of(context).cloud_restore_success(0, 0, 0, 0, 0),
      S.of(context).cloud_restore_error,
    );
  }

  Future<bool?> _showRestoreWarning() {
    final s = S.of(context);
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.restore_warning_title),
        content: Text(s.restore_warning_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(s.restore_confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final controller = context.watch<BackupController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text(s.backup),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    _BackupInfoCard(),
                    const SizedBox(height: 16),
                    _AutoBackupToggle(),
                    const SizedBox(height: 16),
                    _BackupActionsCard(
                      controller: controller,
                      onExportLocal: _exportLocal,
                      onImportLocal: _importLocal,
                      onExportCloud: _exportCloud,
                      onImportCloud: _importCloud,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackupInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(s.backup_info_title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              s.backup_info_description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              s.backup_info_restore_warning,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AutoBackupToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AutoBackupProvider>();
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        secondary: Icon(Icons.cloud_sync, color: theme.colorScheme.primary),
        title: Text(S.of(context).auto_cloud_backup_title),
        subtitle: Text(S.of(context).auto_cloud_backup_subtitle),
        value: provider.isEnabled,
        onChanged: (val) async {
          final errorLabel = S.of(context).error;
          try {
            await provider.setEnabled(val);
          } catch (error) {
            AppNavigator.showError('$errorLabel: $error');
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _BackupActionsCard extends StatelessWidget {
  final BackupController controller;
  final VoidCallback onExportLocal;
  final VoidCallback onImportLocal;
  final VoidCallback onExportCloud;
  final VoidCallback onImportCloud;

  const _BackupActionsCard({
    required this.controller,
    required this.onExportLocal,
    required this.onImportLocal,
    required this.onExportCloud,
    required this.onImportCloud,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isExportingLocal =
        controller.isRunning(BackupOperation.localExport);
    final isImportingLocal =
        controller.isRunning(BackupOperation.localImport);
    final isExportingCloud =
        controller.isRunning(BackupOperation.cloudExport);
    final isImportingCloud =
        controller.isRunning(BackupOperation.cloudImport);

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.local_backup,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: controller.isBusy ? null : onExportLocal,
                    icon: isExportingLocal
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.file_upload),
                    label: Text(s.export_to_file),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: controller.isBusy ? null : onImportLocal,
                    icon: isImportingLocal
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.file_download),
                    label: Text(s.import_from_file),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(s.cloud_backup,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: controller.isBusy ? null : onExportCloud,
                    icon: isExportingCloud
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cloud_upload),
                    label: Text(s.export_to_cloud),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: controller.isBusy ? null : onImportCloud,
                    icon: isImportingCloud
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.cloud_download),
                    label: Text(s.import_from_cloud),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
