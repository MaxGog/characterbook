import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/services/backup_service.dart';
import 'package:characterbook/services/notification_service.dart';
import 'package:characterbook/ui/widgets/buttons/backup_buttons_widget.dart';
import 'package:characterbook/ui/widgets/sections/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackupSection extends StatelessWidget {
  const BackupSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final notificationService = Provider.of<NotificationService>(context);
    final cloudBackupService = CloudBackupService(notificationService: notificationService);

    return SettingsSection(
      title: s.backup,
      children: [
        Center(
          child: BackupButtons(cloudBackupService: cloudBackupService),
        ),
      ],
    );
  }
}