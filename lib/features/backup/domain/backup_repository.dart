abstract interface class BackupRepository {
  Future<Map<String, dynamic>> createBackup();

  Future<void> restoreBackup(Map<String, dynamic> data);
}
