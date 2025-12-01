import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/services/file_share_service.dart';
import 'package:characterbook/ui/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
class NoteService {
  static const String _boxName = 'notes';

  final Note? note;

  NoteService.forDatabase() : note = null;

  NoteService.forExport(this.note);

  Future<Box<Note>> get _box => Hive.openBox<Note>(_boxName);

  Future<int?> saveNote(Note note, {int? key}) async {
    final box = await _box;
    if (key != null) {
      await box.put(key, note);
      return key;
    } else {
      return await box.add(note);
    }
  }

  Future<void> deleteNote(Note note) async {
    final box = await _box;

    final actualKey = box.keys.firstWhere(
      (k) => box.get(k)?.id == note.id,
      orElse: () => null,
    );

    if (actualKey != null) {
      await box.delete(actualKey);
    }
  }

  Future<List<Note>> getAllNotes() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> exportToJson(BuildContext context) async {
    if (note == null) throw Exception("Note is not set for export");

    bool isLoadingVisible = false;

    try {
      isLoadingVisible = true;
      showLoadingDialog(context: context, message: S.of(context).creating_file);
      await Future.delayed(const Duration(milliseconds: 50));

      final jsonStr = jsonEncode(note!.toJson());
      final fileName =
          '${note!.title}_${DateTime.now().millisecondsSinceEpoch}.note';

      if (context.mounted) {
        hideLoadingDialog(context);
        isLoadingVisible = false;
        await Future.delayed(const Duration(milliseconds: 200));
      }

      await FileShareService.shareFile(
        Uint8List.fromList(jsonStr.codeUnits),
        fileName,
        text: 'Заметка: ${note!.title}',
      );
    } catch (e) {
      if (isLoadingVisible && context.mounted) {
        hideLoadingDialog(context);
      }
      throw Exception('Ошибка экспорта в JSON: ${e.toString()}');
    }
  }

  Future<void> shareNote(BuildContext context, Note note) async {
    bool isLoadingVisible = false;

    try {
      isLoadingVisible = true;
      showLoadingDialog(context: context, message: S.of(context).creating_file);
      await Future.delayed(const Duration(milliseconds: 50));

      final jsonStr = jsonEncode(note.toJson());
      final fileName =
          '${note.title}_${DateTime.now().millisecondsSinceEpoch}.note';

      if (context.mounted) {
        hideLoadingDialog(context);
        isLoadingVisible = false;
        await Future.delayed(const Duration(milliseconds: 200));
      }

      await FileShareService.shareFile(
        Uint8List.fromList(jsonStr.codeUnits),
        fileName,
        text: 'Заметка: ${note.title}',
        subject: 'Заметка из CharacterBook',
      );
    } catch (e) {
      if (isLoadingVisible && context.mounted) {
        hideLoadingDialog(context);
      }
      throw Exception('Ошибка при шаринге заметки: ${e.toString()}');
    }
  }
}
