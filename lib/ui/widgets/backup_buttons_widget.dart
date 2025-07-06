import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/services/google_drive_service.dart';
import 'package:flutter/material.dart';

class BackupButtons extends StatefulWidget {
  final CloudBackupService cloudBackupService;

  const BackupButtons({super.key, required this.cloudBackupService});

  @override
  _BackupButtonsState createState() => _BackupButtonsState();
}

class _BackupButtonsState extends State<BackupButtons> {
  bool isProcessing = false;
  String? processingText;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        FilledButton.tonalIcon(
          icon: const Icon(Icons.cloud_upload),
          label: Text(s.createBackup),
          onPressed: isProcessing
              ? null
              : () async {
                  setState(() {
                    isProcessing = true;
                    processingText = s.creatingBackup;
                  });
                  await _handleBackupAction(
                    context,
                    widget.cloudBackupService.exportAllToCloud,
                  );
                  setState(() {
                    isProcessing = false;
                    processingText = null;
                  });
                },
        ),
        const SizedBox(height: 8),
        FilledButton.tonalIcon(
          icon: const Icon(Icons.cloud_download),
          label: Text(s.restoreData),
          onPressed: isProcessing
              ? null
              : () async {
                  setState(() {
                    isProcessing = true;
                    processingText = s.restoringBackup;
                  });
                  await _handleBackupAction(
                    context,
                    widget.cloudBackupService.importAllFromCloud,
                  );
                  setState(() {
                    isProcessing = false;
                    processingText = null;
                  });
                },
        ),
        if (isProcessing) ...[
          const SizedBox(height: 16),
          Column(
            children: [
              LinearProgressIndicator(
                color: colorScheme.primary,
                backgroundColor: colorScheme.primaryContainer,
              ),
              const SizedBox(height: 8),
              Text(
                processingText ?? s.processing,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _handleBackupAction(
    BuildContext context,
    Future Function(BuildContext) action,
  ) async {
    try {
      await action(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).operationCompleted),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).error}: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}