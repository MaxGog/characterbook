import 'package:characterbook/features/backup/domain/backup_actions.dart';
import 'package:flutter/foundation.dart';

enum BackupOperation {
  localExport,
  localImport,
  cloudExport,
  cloudImport,
}

class BackupController extends ChangeNotifier {
  final LocalBackupActions _localBackupService;
  final CloudBackupActions _cloudBackupService;
  final AutoBackupSettings _autoBackupSettings;

  BackupOperation? _activeOperation;

  BackupController({
    required LocalBackupActions localBackupService,
    required CloudBackupActions cloudBackupService,
    required AutoBackupSettings autoBackupSettings,
  })  : _localBackupService = localBackupService,
        _cloudBackupService = cloudBackupService,
        _autoBackupSettings = autoBackupSettings;

  BackupOperation? get activeOperation => _activeOperation;
  bool get isBusy => _activeOperation != null;

  bool isRunning(BackupOperation operation) => _activeOperation == operation;

  Future<void> exportLocalBackup() =>
      _run(BackupOperation.localExport, _localBackupService.exportData);

  Future<void> importLocalBackup() =>
      _run(BackupOperation.localImport, _localBackupService.importData);

  Future<void> exportCloudBackup() =>
      _run(BackupOperation.cloudExport, _cloudBackupService.exportData);

  Future<void> importCloudBackup() =>
      _run(BackupOperation.cloudImport, _cloudBackupService.importData);

  Future<void> runAutomaticBackup() async {
    if (!_autoBackupSettings.isEnabled) return;
    await _run(BackupOperation.cloudExport, _cloudBackupService.autoExportIfSignedIn);
  }

  Future<void> _run(
    BackupOperation operation,
    AsyncCallback action,
  ) async {
    if (isBusy) throw StateError('A backup operation is already in progress.');
    _activeOperation = operation;
    notifyListeners();
    try {
      await action();
    } finally {
      _activeOperation = null;
      notifyListeners();
    }
  }
}
