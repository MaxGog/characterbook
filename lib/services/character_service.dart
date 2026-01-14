import 'dart:async';
import 'dart:convert';
import 'dart:math';
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
  final Box<Character> _box = Hive.box<Character>(_boxName);

  final Character? character;

  CharacterService.forDatabase() : character = null;

  CharacterService.forExport(this.character);

  Future<int?> saveCharacter(Character character, {int? key}) async {
    try {
      if (key != null) {
        await _box.put(key, character);
        return key;
      }

      if (character.key != null) {
        await character.save();
        return character.key;
      }

      return await _box.add(character);
    } catch (e) {
      throw Exception('${S.current.save_error}: ${e.toString()}');
    }
  }

  Future<void> deleteCharacter(Character character) async {
    try {
      if (character.key != null) {
        await _box.delete(character.key);
      } else {
        final key = _findKeyByCharacter(character);
        if (key != null) {
          await _box.delete(key);
        }
      }
    } catch (e) {
      throw Exception('${S.current.delete_error}: ${e.toString()}');
    }
  }

  Future<Character?> duplicateCharacter(Character character) async {
    try {
      final duplicatedCharacter = Character.fromJson(character.toJson());

      duplicatedCharacter.id = _generateUniqueId();

      duplicatedCharacter.name = '${character.name} (Копия)';

      final now = DateTime.now();
      duplicatedCharacter.lastEdited = now;

      final newKey = await saveCharacter(duplicatedCharacter);

      return await getCharacterByKey(newKey!);
    } catch (e) {
      throw Exception('${"S.current.duplicate_error"}: ${e.toString()}');
    }
  }

  String _generateUniqueId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(1000000);
    return '${timestamp}_$randomNum';
  }

  int? _findKeyByCharacter(Character character) {
    for (final key in _box.keys) {
      final storedCharacter = _box.get(key);
      if (storedCharacter != null && storedCharacter.id == character.id) {
        return key as int;
      }
    }
    return null;
  }

  Future<List<Character>> getAllCharacters() async {
    try {
      return _box.values.toList();
    } catch (e) {
      throw Exception('${S.current.error}: ${e.toString()}');
    }
  }

  Future<Character?> getCharacterByKey(int key) async {
    try {
      return _box.get(key);
    } catch (e) {
      throw Exception('${S.current.error}: ${e.toString()}');
    }
  }

  Future<List<Character>> getCharactersByRaceId(String raceId) async {
    try {
      return _box.values
          .where((character) => character.race?.id == raceId)
          .toList();
    } catch (e) {
      throw Exception('${S.current.error}: ${e.toString()}');
    }
  }

  Future<void> exportToPdf(BuildContext context) async {
    if (character == null) {
      _showErrorDialog(
        context,
        S.current.export_error,
        S.current.export_error,
      );
      return;
    }

    await PdfExportManager.exportCharacterWithDialog(
      context,
      character!,
      fileName: '${character!.name}.pdf',
      shareText: S.current.character_exported(character!.name),
    );
  }

  Future<void> exportToJson(BuildContext context) async {
    if (character == null) {
      _showErrorDialog(
        context,
        S.current.export_error,
        S.current.export_error,
      );
      return;
    }

    try {
      showLoadingDialog(
        context: context,
        message: S.current.creating_file,
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
        text: '${S.current.character}: ${character!.name}',
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(
          S.current.export_error,
        ),
      );
    } on TimeoutException {
      if (context.mounted) {
        hideLoadingDialog(context);
        _showErrorDialog(
          context,
          S.current.export_error,
          S.current.export_error,
        );
      }
    } catch (e) {
      if (context.mounted) {
        hideLoadingDialog(context);
        _showErrorDialog(
          context,
          S.current.export_error,
          '${S.current.export_error}: ${e.toString()}',
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
