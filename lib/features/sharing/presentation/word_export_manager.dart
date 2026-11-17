import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/features/races/domain/race_model.dart';
import 'package:characterbook/features/templates/domain/template_model.dart';
import 'package:characterbook/services/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/features/sharing/application/word_export_service.dart';
import 'package:characterbook/ui/widgets/dialogs/loading_dialog.dart';
import 'package:characterbook/core/file_share_actions.dart';
import 'package:provider/provider.dart';

class WordExportManager {
  static Future<void> exportCharacterWithDialog(
    BuildContext context,
    Character character,
  ) async {
    final s = S.of(context);
    try {
      showLoadingDialog(context: context, message: s.creating_file);

      final service = WordExportService(character);
      final bytes = await service.generate();

      if (context.mounted) hideLoadingDialog(context);

      await context.read<FileShareActions>().shareFile(
            bytes,
            '${character.name}.docx',
            text: s.character_share_text(character.name),
          );

      if (context.mounted) {
        AppNavigator.showSuccess(s.word_export_success);
      }
    } catch (e) {
      if (context.mounted) {
        hideLoadingDialog(context);
        AppNavigator.showError(
          '${s.word_export_error}: $e',
        );
      }
    }
  }

  static Future<void> exportRaceWithDialog(
    BuildContext context,
    Race race,
  ) async {
    final s = S.of(context);
    try {
      showLoadingDialog(context: context, message: s.creating_file);
      final service = RaceWordExportService(race);
      final bytes = await service.generate();
      if (context.mounted) hideLoadingDialog(context);

      await context.read<FileShareActions>().shareFile(
            bytes,
            '${race.name}.docx',
            text: 'Раса: ${race.name}',
          );

      if (context.mounted) {
        AppNavigator.showSuccess(s.word_export_success);
      }
    } catch (e) {
      if (context.mounted) {
        hideLoadingDialog(context);
        AppNavigator.showError('${s.word_export_error}: $e');
      }
    }
  }

  static Future<void> exportTemplateWithDialog(
    BuildContext context,
    QuestionnaireTemplate template,
  ) async {
    final s = S.of(context);
    try {
      showLoadingDialog(context: context, message: s.creating_file);
      final service = TemplateWordExportService(template);
      final bytes = await service.generate();
      if (context.mounted) hideLoadingDialog(context);

      await context.read<FileShareActions>().shareFile(
            bytes,
            '${template.name}.docx',
            text: 'Шаблон: ${template.name}',
          );

      if (context.mounted) {
        AppNavigator.showSuccess(s.word_export_success);
      }
    } catch (e) {
      if (context.mounted) {
        hideLoadingDialog(context);
        AppNavigator.showError('${s.word_export_error}: $e');
      }
    }
  }
}
