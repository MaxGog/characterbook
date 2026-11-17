import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/features/races/domain/race_model.dart';
import 'package:characterbook/features/sharing/application/pdf_export_actions.dart';
import 'package:characterbook/features/sharing/application/pdf_localization_data.dart';
import 'package:characterbook/features/sharing/data/pdf_export_service.dart';
import 'package:characterbook/features/sharing/domain/export_pdf_settings_actions.dart';

class PdfExportActionService implements PdfExportActions {
  final ExportPdfSettingsActions _settingsActions;

  PdfExportActionService(this._settingsActions);

  @override
  Future<PdfExportDocument> createForCharacter(
    Character character,
    PdfLocalizationData localization,
  ) =>
      PdfExportService.createForCharacter(
        character,
        localization,
        settingsActions: _settingsActions,
      );

  @override
  Future<PdfExportDocument> createForRace(
    Race race,
    PdfLocalizationData localization,
  ) =>
      PdfExportService.createForRace(
        race,
        localization,
        settingsActions: _settingsActions,
      );
}
