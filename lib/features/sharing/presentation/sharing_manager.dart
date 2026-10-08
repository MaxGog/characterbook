import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:characterbook/data/models/character_model.dart';
import 'package:characterbook/data/models/note_model.dart';
import 'package:characterbook/data/models/race_model.dart';
import 'package:characterbook/data/models/template_model.dart';
import 'package:characterbook/features/sharing/data/file_share_service.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/widgets/dialogs/error_dialog.dart';
import 'package:characterbook/ui/widgets/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';

class SharingManager {
  static const _fileShareService = FileShareService();

  static Future<void> shareCharacterAsFile(Character character) {
    return _fileShareService.shareTextFile(
      jsonEncode(character.toJson()),
      '${character.name}.character',
      text: character.name,
    );
  }

  static Future<void> shareRaceAsFile(Race race) {
    return _fileShareService.shareTextFile(
      jsonEncode(race.toJson()),
      '${race.name}.race',
      text: race.name,
    );
  }

  static Future<void> shareNoteAsFile(Note note) {
    return _fileShareService.shareTextFile(
      jsonEncode(note.toJson()),
      '${note.title}_note.json',
      text: note.title,
    );
  }

  static Future<void> shareTemplateAsFile(QuestionnaireTemplate template) {
    return _fileShareService.shareTextFile(
      jsonEncode(template.toJson()),
      '${template.name}.chax',
      text: template.name,
    );
  }

  static Future<void> shareCharacterAsJson(
    BuildContext context,
    Character character,
  ) async {
    final s = S.current;
    try {
      showLoadingDialog(context: context, message: s.creating_file);
      final fileName =
          '${character.name}_${DateTime.now().millisecondsSinceEpoch}.character';
      if (context.mounted) hideLoadingDialog(context);
      await _fileShareService
          .shareFile(
            Uint8List.fromList(utf8.encode(jsonEncode(character.toJson()))),
            fileName,
            text: '${s.character}: ${character.name}',
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException(s.export_error),
          );
    } on TimeoutException {
      if (context.mounted) {
        hideLoadingDialog(context);
        _showErrorDialog(context, s.export_error, s.export_timeout);
      }
    } catch (error) {
      if (context.mounted) {
        hideLoadingDialog(context);
        _showErrorDialog(
          context,
          s.export_error,
          '${s.export_error}: $error',
        );
      }
    }
  }

  static Future<void> shareRaceAsJson(BuildContext context, Race race) async {
    try {
      showLoadingDialog(context: context, message: S.of(context).creating_file);
      final json = jsonEncode(race.toJson());
      final fileName =
          '${race.name}_${DateTime.now().millisecondsSinceEpoch}.race';
      if (context.mounted) hideLoadingDialog(context);
      await _fileShareService
          .shareFile(
            Uint8List.fromList(utf8.encode(json)),
            fileName,
            text: 'Раса: ${race.name}',
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException(
              'Экспорт в JSON занял слишком много времени',
            ),
          );
    } on TimeoutException {
      if (context.mounted) {
        hideLoadingDialog(context);
        _showErrorDialog(
          context,
          'Таймаут',
          'Экспорт в JSON занял слишком много времени',
        );
      }
    } catch (error) {
      if (context.mounted) {
        hideLoadingDialog(context);
        _showErrorDialog(
          context,
          'Ошибка экспорта',
          'Не удалось экспортировать в JSON: $error',
        );
      }
    }
  }

  static Future<void> shareNote(BuildContext context, Note note) async {
    var isLoadingVisible = false;
    try {
      isLoadingVisible = true;
      showLoadingDialog(context: context, message: S.of(context).creating_file);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final fileName =
          '${note.title}_${DateTime.now().millisecondsSinceEpoch}.note';
      if (context.mounted) {
        hideLoadingDialog(context);
        isLoadingVisible = false;
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }

      await _fileShareService.shareFile(
        Uint8List.fromList(utf8.encode(jsonEncode(note.toJson()))),
        fileName,
        text: 'Заметка: ${note.title}',
        subject: 'Заметка из CharacterBook',
      );
    } catch (error) {
      if (isLoadingVisible && context.mounted) hideLoadingDialog(context);
      throw Exception('Ошибка при шаринге заметки: $error');
    }
  }

  static Future<void> exportNoteAsJson(BuildContext context, Note note) async {
    var isLoadingVisible = false;
    try {
      isLoadingVisible = true;
      showLoadingDialog(context: context, message: S.of(context).creating_file);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final fileName =
          '${note.title}_${DateTime.now().millisecondsSinceEpoch}.note';
      if (context.mounted) {
        hideLoadingDialog(context);
        isLoadingVisible = false;
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }

      await _fileShareService.shareFile(
        Uint8List.fromList(utf8.encode(jsonEncode(note.toJson()))),
        fileName,
        text: 'Заметка: ${note.title}',
      );
    } catch (error) {
      if (isLoadingVisible && context.mounted) hideLoadingDialog(context);
      throw Exception('Ошибка экспорта в JSON: $error');
    }
  }

  static Future<void> shareTemplate(QuestionnaireTemplate template) async {
    try {
      await _fileShareService.shareFile(
        Uint8List.fromList(utf8.encode(jsonEncode(template.toJson()))),
        '${template.name}.chax',
        text: 'Шаблон персонажа: ${template.name}',
        subject: 'Шаблон персонажа',
      );
    } catch (error) {
      throw Exception('Ошибка при шаринге шаблона: $error');
    }
  }

  static void _showErrorDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showErrorDialog(context: context, title: title, message: message);
      }
    });
  }
}
