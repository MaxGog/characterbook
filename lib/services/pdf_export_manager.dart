import 'dart:async';

import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/data/models/character_model.dart';
import 'package:characterbook/data/models/race_model.dart';
import 'package:characterbook/services/file_share_service.dart';
import 'package:characterbook/services/pdf_export_serivce.dart';
import 'package:characterbook/ui/widgets/dialogs/error_dialog.dart';
import 'package:characterbook/ui/widgets/dialogs/loading_dialog.dart';
import 'package:characterbook/ui/widgets/dialogs/success_dialog.dart';
import 'package:flutter/material.dart';

class PdfExportManager {
  static Future<void> exportCharacterWithDialog(
    BuildContext context,
    Character character, {
    String? fileName,
    String? shareText,
  }) async {
    final s = S.of(context);
    await _exportWithDialog(
      context,
      () => PdfExportService.createForCharacter(
        character,
        _getLocalizationFromContext(context),
      ),
      fileName ?? '${character.name}.pdf',
      shareText ??
          s.character_share_text(character.name),
      s.character.toLowerCase(),
      s.character_exported(character.name),
    );
  }

  static Future<void> exportRaceWithDialog(
    BuildContext context,
    Race race, {
    String? fileName,
    String? shareText,
  }) async {
    final s = S.of(context);
    await _exportWithDialog(
      context,
      () => PdfExportService.createForRace(
        race,
        _getLocalizationFromContext(context),
      ),
      fileName ?? '${race.name}.pdf',
      shareText ?? s.race_share_text(race.name),
      s.race.toLowerCase(),
      s.race_exported(race.name),
    );
  }

  static Future<void> _exportWithDialog(
    BuildContext context,
    Future<PdfExportService> Function() createService,
    String fileName,
    String shareText,
    String entityType,
    String successMessage,
  ) async {
    final s = S.of(context);

    try {
      showLoadingDialog(
        context: context,
        message: s.creating_pdf,
      );

      final pdfService = await createService().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(
          s.pdf_creation_timeout,
        ),
      );

      final pdfBytes = await pdfService.generatePdf().timeout(
            const Duration(seconds: 60),
            onTimeout: () => throw TimeoutException(
              s.pdf_generation_timeout,
            ),
          );

      if (context.mounted) {
        hideLoadingDialog(context);
      }

      await FileShareService.shareFile(
        pdfBytes,
        fileName,
        text: shareText,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(
          s.file_sharing_timeout,
        ),
      );

      if (context.mounted) {
        showSuccessDialog(
          context: context,
          title: s.operationCompleted,
          message: successMessage,
        );
      }
    } on TimeoutException catch (e) {
      if (context.mounted) {
        hideLoadingDialog(context);
        showErrorDialog(
          context: context,
          title: s.timeout_error,
          message: '${s.operation_timeout}: ${e.message}',
        );
      }
    } catch (e) {
      if (context.mounted) {
        hideLoadingDialog(context);
        showErrorDialog(
          context: context,
          title: s.export_error,
          message: '${s.pdf_creation_failed}: ${e.toString()}',
        );
      }
    }
  }

  static PdfLocalizationData _getLocalizationFromContext(BuildContext context) {
    final s = S.of(context);

    final locale = Localizations.localeOf(context);

    if (locale.languageCode == 'en') {
      return PdfLocalizationData.english();
    } else {
      return PdfLocalizationData(
        serviceCreationError: s.service_creation_error,
        raceServiceCreationError: s.race_service_creation_error,
        unsupportedModelType: s.unsupported_model_type,
        pdfGenerationError: s.pdf_generation_error,
        fontLoadTimeout: s.font_load_timeout,
        settingsLoadError: s.settings_load_error,
        settingsSaveError: s.settings_save_error,
        characterProfileTitle: s.character_profile_title,
        raceProfileTitle: s.race_profile_title,
        basicInfo: s.basic_info,
        name: s.name,
        age: s.age,
        gender: s.gender,
        race: s.race,
        description: s.description,
        biography: s.biography,
        personality: s.personality,
        appearance: s.appearance,
        abilities: s.abilities,
        other: s.other,
        referenceImage: s.reference_image,
        customFields: s.custom_fields,
        additionalImages: s.additional_images,
        biology: s.biology,
        backstory: s.backstory,
      );
    }
  }
}
