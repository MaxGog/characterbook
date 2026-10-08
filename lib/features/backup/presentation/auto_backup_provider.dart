import 'package:characterbook/features/backup/domain/backup_actions.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class AutoBackupProvider extends ChangeNotifier implements AutoBackupSettings {
  static const _settingKey = 'auto_cloud_backup';

  final Box<bool> _box;
  bool _isEnabled;

  AutoBackupProvider(Box<bool> box)
      : _box = box,
        _isEnabled = box.get(_settingKey, defaultValue: false) ?? false;

  @override
  bool get isEnabled => _isEnabled;

  @override
  Future<void> setEnabled(bool value) async {
    if (_isEnabled == value) return;
    await _box.put(_settingKey, value);
    _isEnabled = value;
    notifyListeners();
  }
}
