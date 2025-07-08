import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;
import '../generated/l10n.dart';
import '../models/character_model.dart';
import '../models/note_model.dart';
import '../models/race_model.dart';
import '../models/template_model.dart';
import 'file_picker_service.dart';

class LocalBackupService {
  final FilePickerService filePickerService = FilePickerService();

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  Future<void> exportAllToFile(BuildContext context) async {
    try {
      final backupData = {
        'characters': Hive.box<Character>('characters').values.toList(),
        'notes': Hive.box<Note>('notes').values.toList(),
        'races': Hive.box<Race>('races').values.toList(),
        'templates': Hive.box<QuestionnaireTemplate>('templates').values.toList(),
      };
      final backupJson = jsonEncode(backupData);
      
      if (kIsWeb) {
        final bytes = utf8.encode(backupJson);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/characterbook_backup_${DateTime.now().toIso8601String()}.json');
        await file.writeAsString(backupJson);
        await Share.shareXFiles([XFile(file.path)], text: S.of(context).share_backup_file);
      }
      
      _showSnackBar(context, S.of(context).local_backup_success);
    } catch (e) {
      _showSnackBar(context, '${S.of(context).local_backup_error}: $e', isError: true);
    }
  }

  Future<void> importFromFile(BuildContext context) async {
    try {
      String? jsonStr;

      if (kIsWeb) {
        final uploadInput = html.FileUploadInputElement();
        uploadInput.accept = '.json';
        uploadInput.click();

        await uploadInput.onChange.first;
        final files = uploadInput.files;
        if (files == null || files.isEmpty) return;

        final file = files[0];
        final reader = html.FileReader();
        reader.readAsText(file);
        await reader.onLoadEnd.first;
        jsonStr = reader.result as String;
      } else {
        final file = await filePickerService.pickJsonFile();
        if (file == null) return;
        jsonStr = await file.readAsString();
      }

      if (jsonStr.isEmpty) {
        throw Exception(S.of(context).empty_file_error);
      }

      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      await _clearAndImportBox<Race>('races', data['races'] ?? [], Race.fromJson);
      await _clearAndImportBox<QuestionnaireTemplate>('templates', data['templates'] ?? [], QuestionnaireTemplate.fromJson);
      await _clearAndImportBox<Character>('characters', data['characters'] ?? [], Character.fromJson);
      await _clearAndImportBox<Note>('notes', data['notes'] ?? [], Note.fromJson);

      final counts = {
        'characters': (data['characters'] as List?)?.length ?? 0,
        'notes': (data['notes'] as List?)?.length ?? 0,
        'races': (data['races'] as List?)?.length ?? 0,
        'templates': (data['templates'] as List?)?.length ?? 0,
      };

      _showSnackBar(
        context,
        S.of(context).local_restore_success(
          counts['characters'].toString(),
          counts['notes'].toString(),
          counts['races'].toString(),
          counts['templates'].toString(),
        ),
      );
    } catch (e) {
      _showSnackBar(context, '${S.of(context).local_restore_error}: $e', isError: true);
    }
  }

  Future<void> _clearAndImportBox<T>(
    String boxName,
    List<dynamic> items,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final box = Hive.box<T>(boxName);
    await box.clear();
    for (final json in items) {
      await box.add(fromJson(json));
    }
  }
}