import 'dart:typed_data';

import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/features/races/domain/race_model.dart';
import 'package:characterbook/features/sharing/application/pdf_localization_data.dart';

abstract interface class PdfExportDocument {
  Future<Uint8List> generatePdf();
}

abstract interface class PdfExportActions {
  Future<PdfExportDocument> createForCharacter(
    Character character,
    PdfLocalizationData localization,
  );

  Future<PdfExportDocument> createForRace(
    Race race,
    PdfLocalizationData localization,
  );
}
