import 'package:characterbook/features/sharing/domain/export_pdf_settings.dart';

abstract interface class ExportPdfSettingsActions {
  Future<ExportPdfSettings> getSettings();

  Future<void> saveSettings(ExportPdfSettings settings);
}
