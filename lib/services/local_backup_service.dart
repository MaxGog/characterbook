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

  Future<void> restoreData() async {
    try {
      final jsonData = await filePickerService.pickRestoreFile();
      if (jsonData == null || jsonData is! Map<String, dynamic>) {
        debugPrint('Invalid backup file');
        return;
      }

      if (!_validateBackupStructure(jsonData)) {
        debugPrint('Invalid backup structure');
        return;
      }

      await _restoreBox<Character>('characters', jsonData['characters']);
      await _restoreBox<Note>('notes', jsonData['notes']);
      await _restoreBox<Race>('races', jsonData['races']);
      await _restoreBox<QuestionnaireTemplate>(
          'templates', jsonData['templates']);

      debugPrint('Restore completed successfully');
    } catch (e, stack) {
      debugPrint('Restore failed: $e\n$stack');
    }
  }

  bool _validateBackupStructure(Map<String, dynamic> data) {
    return data.containsKey('characters') &&
        data.containsKey('notes') &&
        data.containsKey('races') &&
        data.containsKey('templates');
  }

  Future<void> _restoreBox<T>(String boxName, List<dynamic>? items) async {
    if (items == null || items.isEmpty) return;

    debugPrint('Restoring $boxName (${items.length} items)');

    final box = await Hive.openBox<T>(boxName);

    await box.clear();

    for (final json in items) {
      try {
        final item = _createModel<T>(json as Map<String, dynamic>);
        if (item != null) {
          await box.add(item);
        }
      } catch (e) {
        debugPrint('Error creating $T from json: $e\nJson: $json');
      }
    }

    debugPrint('Successfully restored ${box.length} items to $boxName');
  }

  T? _createModel<T>(Map<String, dynamic> json) {
    try {
      switch (T) {
        case Character:
          return Character.fromJson(json) as T;
        case Note:
          return Note.fromJson(json) as T;
        case Race:
          return Race.fromJson(json) as T;
        case QuestionnaireTemplate:
          return QuestionnaireTemplate.fromJson(json) as T;
        default:
          return null;
      }
    } catch (e) {
      debugPrint('Error creating model: $e');
      return null;
    }
  }


  
}