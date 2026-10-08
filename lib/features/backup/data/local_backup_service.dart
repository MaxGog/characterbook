import 'dart:convert';

import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/features/backup/domain/backup_actions.dart';
import 'package:characterbook/features/backup/domain/backup_manager.dart';
import 'package:characterbook/services/file_share_service.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

class LocalBackupService implements LocalBackupActions {
  final BackupManager _backupManager;
  final FilePickerService _filePickerService;

  LocalBackupService({
    required BackupManager backupManager,
    required FilePickerService filePickerService,
  })  : _backupManager = backupManager,
        _filePickerService = filePickerService;

  @override
  Future<void> exportData() async {
    final backupData = await _backupManager.createBackup();
    if (!_backupManager.containsData(backupData)) {
      throw const EmptyBackupException();
    }

    final backupJson = jsonEncode(backupData);
    if (kIsWeb) {
      _exportForWeb(backupJson);
      return;
    }

    final fileName =
        'characterbook_backup_${DateTime.now().millisecondsSinceEpoch}.characterbook';
    await FileShareService.shareFile(
      Uint8List.fromList(utf8.encode(backupJson)),
      fileName,
      text: S.current.share_backup_file,
      subject: fileName,
    );
  }

  void _exportForWeb(String backupJson) {
    final bytes = utf8.encode(backupJson);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final fileName =
        'characterbook_backup_${DateTime.now().millisecondsSinceEpoch}.characterbook';
    final anchor = html.AnchorElement(href: url)
      ..download = fileName
      ..style.display = 'none';
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    Future<void>.delayed(const Duration(seconds: 1), () {
      html.Url.revokeObjectUrl(url);
    });
  }

  @override
  Future<void> importData() async {
    final data = await _filePickerService.pickRestoreFile();
    if (data == null) {
      throw FormatException(S.current.local_restore_error);
    }
    await _backupManager.restoreBackup(data);
  }
}
