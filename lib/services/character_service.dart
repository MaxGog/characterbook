import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/services/file_share_service.dart';
import 'package:characterbook/services/pdf_export_manager.dart';
import 'package:characterbook/ui/dialogs/error_dialog.dart';
import 'package:characterbook/ui/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CharacterService {
  static const String _boxName = 'characters';

  final Character? character;

  CharacterService.forDatabase() : character = null;

  CharacterService.forExport(this.character);

  Future<Box<Character>> get _box => Hive.openBox<Character>(_boxName);

  Future<int?> saveCharacter(Character character, {int? key}) async {
    try {
      final box = Hive.box<Character>('characters');
      if (key != null) {
        await box.put(key, character);
        return key;
      } else {
        return await box.add(character);
      }
    } catch (e) {
      throw Exception('Ошибка сохранения персонажа: ${e.toString()}');
    }
  }

  Future<void> deleteCharacter(Character character) async {
    try {
      final box = await _box;

      final key = box.keys.firstWhere(
        (k) => box.get(k)?.id == character.id,
        orElse: () => null,
      );

      if (key != null) {
        await box.delete(key);
      }
    } catch (e) {
      throw Exception('Ошибка удаления персонажа: ${e.toString()}');
    }
  }

  Future<List<Character>> getAllCharacters() async {
    try {
      final box = await _box;
      return box.values.toList();
    } catch (e) {
      throw Exception('Ошибка загрузки персонажей: ${e.toString()}');
    }
  }

  Future<void> exportToPdf(BuildContext context) async {
    if (character == null) {
      _showErrorDialog(
        context,
        'Ошибка экспорта',
        'Персонаж не установлен для экспорта',
      );
      return;
    }

    await PdfExportManager.exportCharacterWithDialog(
      context,
      character!,
      fileName: '${character!.name}.pdf',
      shareText: 'Характеристика персонажа ${character!.name}',
    );
  }

  Future<void> exportToJson(BuildContext context) async {
    if (character == null) {
      _showErrorDialog(
        context,
        'Ошибка экспорта',
        'Персонаж не установлен для экспорта',
      );
      return;
    }

    try {
      showLoadingDialog(
        context: context,
        message: S.of(context).creating_file,
      );

      final jsonStr = jsonEncode(character!.toJson());
      final fileName =
          '${character!.name}_${DateTime.now().millisecondsSinceEpoch}.character';

      await Future.delayed(const Duration(milliseconds: 100));

      if (context.mounted) {
        hideLoadingDialog(context);
      }

      await FileShareService.shareFile(
        Uint8List.fromList(jsonStr.codeUnits),
        fileName,
        text: 'Персонаж: ${character!.name}',
      ).timeout(
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
    } catch (e) {
      if (context.mounted) {
        hideLoadingDialog(context);
        _showErrorDialog(
          context,
          'Ошибка экспорта',
          'Не удалось экспортировать в JSON: ${e.toString()}',
        );
      }
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showErrorDialog(
          context: context,
          title: title,
          message: message,
        );
      }
    });
  }
}
