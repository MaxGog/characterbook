import 'backup_repository.dart';

class BackupManager {
  final BackupRepository _repository;

  BackupManager(this._repository);

  Future<Map<String, dynamic>> createBackup() => _repository.createBackup();

  bool containsData(Map<String, dynamic> data) =>
      data.values.any((value) => value is List && value.isNotEmpty);

  Future<void> restoreBackup(Map<String, dynamic> data) =>
      _repository.restoreBackup(data);
}

class EmptyBackupException implements Exception {
  const EmptyBackupException();

  @override
  String toString() => 'There is no data to back up.';
}
