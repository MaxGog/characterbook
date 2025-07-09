import 'dart:async';
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
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : null,
        ),
      );
    }
  }

  Future<void> _ensureBoxesAreOpen() async {
    if (!Hive.isBoxOpen('characters')) await Hive.openBox<Character>('characters');
    if (!Hive.isBoxOpen('notes')) await Hive.openBox<Note>('notes');
    if (!Hive.isBoxOpen('races')) await Hive.openBox<Race>('races');
    if (!Hive.isBoxOpen('templates')) await Hive.openBox<QuestionnaireTemplate>('templates');
  }

  Future<void> exportAllToFile(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final s = S.of(context);

    try {
      await _ensureBoxesAreOpen();
      final hasData = Hive.box<Character>('characters').isNotEmpty ||
          Hive.box<Note>('notes').isNotEmpty ||
          Hive.box<Race>('races').isNotEmpty ||
          Hive.box<QuestionnaireTemplate>('templates').isNotEmpty;

      if (!hasData) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Нет данных для экспорта'), backgroundColor: Colors.red),
        );
        return;
      }

      final backupData = {
        'characters': Hive.box<Character>('characters').values.map((e) => e.toJson()).toList(),
        'notes': Hive.box<Note>('notes').values.map((e) => e.toJson()).toList(),
        'races': Hive.box<Race>('races').values.map((e) => e.toJson()).toList(),
        'templates': Hive.box<QuestionnaireTemplate>('templates').values.map((e) => e.toJson()).toList(),
      };

      String backupJson;
      try {
        backupJson = await compute(_safeJsonEncode, backupData);
      } catch (e) {
        backupJson = jsonEncode(backupData);
      }

      if (kIsWeb) {
        final bytes = utf8.encode(backupJson);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'characterbook_backup_${DateTime.now().millisecondsSinceEpoch}.json')
          ..click();
        html.Url.revokeObjectUrl(url);
        
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(s.local_backup_success)),
        );
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'characterbook_backup_${DateTime.now().millisecondsSinceEpoch}.json';
        final file = File('${directory.path}/$fileName');
        
        await file.writeAsBytes(utf8.encode(backupJson));
        
        try {
          await Share.shareXFiles(
            [XFile(file.path)], 
            text: s.share_backup_file,
            subject: fileName,
          );
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(s.local_backup_success)),
          );
        } catch (e) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Файл сохранён: ${file.path}'),
            ),
          );
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('${s.local_backup_error}: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('${s.local_backup_error}: $e'),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint('Export error: $e');
    }
  }

  String _safeJsonEncode(dynamic data) => jsonEncode(data);

  Future<void> importFromFile(BuildContext context) async {
    try {
      String? jsonStr;

      if (kIsWeb) {
        final completer = Completer<String>();
        final uploadInput = html.FileUploadInputElement();
        uploadInput.accept = '.json';
        uploadInput.click();

        uploadInput.onChange.listen((e) {
          final files = uploadInput.files;
          if (files == null || files.isEmpty) return;

          final file = files[0];
          final reader = html.FileReader();
          reader.readAsText(file);
          reader.onLoadEnd.listen((e) {
            completer.complete(reader.result as String);
          });
        });

        jsonStr = await completer.future;
      } else {
        final file = await filePickerService.pickJsonFile();
        if (file == null) return;
        jsonStr = await file.readAsString();
      }

      if (jsonStr.isEmpty) {
        throw Exception(S.of(context).empty_file_error);
      }

      if (!context.mounted) return;

      final data = await compute(_parseJsonInIsolate, jsonStr);

      await _ensureBoxesAreOpen();
      
      final counts = {
        'characters': (data['characters'] as List?)?.length ?? 0,
        'notes': (data['notes'] as List?)?.length ?? 0,
        'races': (data['races'] as List?)?.length ?? 0,
        'templates': (data['templates'] as List?)?.length ?? 0,
      };

      await _clearAndImportBox<Race>('races', data['races'] ?? [], Race.fromJson);
      await _clearAndImportBox<QuestionnaireTemplate>('templates', data['templates'] ?? [], QuestionnaireTemplate.fromJson);
      await _clearAndImportBox<Character>('characters', data['characters'] ?? [], Character.fromJson);
      await _clearAndImportBox<Note>('notes', data['notes'] ?? [], Note.fromJson);

    
      _showSnackBar(
        context,
        S.of(context).local_restore_success(
          counts['characters'].toString(),
          counts['notes'].toString(),
          counts['races'].toString(),
          counts['templates'].toString(),
        )
      );
    } catch (e) {
      _showSnackBar(context, '${S.of(context).local_restore_error}: $e', isError: true);
    }
  }

  static Map<String, dynamic> _parseJsonInIsolate(String jsonStr) {
    return jsonDecode(jsonStr) as Map<String, dynamic>;
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