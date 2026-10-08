abstract interface class LocalBackupActions {
  Future<void> exportData();

  Future<void> importData();
}

abstract interface class CloudBackupActions {
  Future<void> exportData();

  Future<void> importData();

  Future<void> autoExportIfSignedIn();
}

abstract interface class AutoBackupSettings {
  bool get isEnabled;

  Future<void> setEnabled(bool value);
}
