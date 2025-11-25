import 'package:characterbook/models/export_pdf_settings_model.dart';
import 'package:hive/hive.dart';

class ExportPdfSettingsService {
  static const String _boxName = 'export_pdf_settings';
  static const String _settingsKey = 'settings';

  Future<Box<ExportPdfSettings>> get _box =>
      Hive.openBox<ExportPdfSettings>(_boxName);

  Future<ExportPdfSettings> getSettings() async {
    final box = await _box;
    return box.get(_settingsKey) ?? ExportPdfSettings();
  }

  Future<void> saveSettings(ExportPdfSettings settings) async {
    final box = await _box;
    await box.put(_settingsKey, settings);
  }
}
