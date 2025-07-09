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

  void _showSnackBar(BuildContext? context, String message, {bool isError = false}) {
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : null,
        ),
      );
    } else {
      debugPrint('SnackBar not shown: $message');
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
      final s = S.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      final intentData = await filePickerService.getRestoreFileData();
      if (intentData != null) {
        await _processRestoreData(context, intentData, s);
        return;
      }

      final file = await filePickerService.pickRestoreFile();
      if (file == null) return;

      String jsonStr;
      try {
        jsonStr = await file.readAsString();
      } catch (e) {
        if (context.mounted) {
          _showSnackBar(context, '${s.error}: ${e.toString()}', isError: true);
        }
        return;
      }

      if (jsonStr.isEmpty) {
        if (context.mounted) {
          _showSnackBar(context, s.empty_file_error, isError: true);
        }
        return;
      }

      final parsedData = await compute(_parseAndValidateJson, jsonStr);
      await _processRestoreData(context, parsedData, s);
    } catch (e) {
      debugPrint('Restore error: $e');
    }
  }

  static Map<String, dynamic> _parseAndValidateJson(String jsonStr) {
    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      
      if (!data.containsKey('characters') && 
          !data.containsKey('notes') && 
          !data.containsKey('races') && 
          !data.containsKey('templates')) {
        throw FormatException('Invalid backup file structure');
      }
      
      return data;
    } on FormatException catch (e) {
      throw FormatException('Invalid JSON format: ${e.message}');
    } catch (e) {
      throw Exception('Failed to parse JSON: $e');
    }
  }

  Future<void> _clearAndImportBox<T>(
    String boxName,
    List<dynamic> items,
    T Function(dynamic) fromJson,
  ) async {
    try {
      final box = Hive.box<T>(boxName);
      await box.clear();
      
      for (final json in items) {
        try {
          final item = fromJson(json);
          if (item != null) {
            await box.add(item);
          }
        } catch (e) {
          debugPrint('Failed to import item in $boxName: $e\nItem: $json');
        }
      }
    } catch (e) {
      debugPrint('Failed to import box $boxName: $e');
      rethrow;
    }
  }

  Future<void> _processRestoreData(
    BuildContext context,
    Map<String, dynamic> data,
    S s,
  ) async {
    await _ensureBoxesAreOpen();
    
    final counts = {
      'characters': (data['characters'] as List?)?.length ?? 0,
      'notes': (data['notes'] as List?)?.length ?? 0,
      'races': (data['races'] as List?)?.length ?? 0,
      'templates': (data['templates'] as List?)?.length ?? 0,
    };

    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.restore_from_file),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.restore_from_file),
            if (counts['characters']! > 0) Text('${s.characters}: ${counts['characters']}'),
            if (counts['notes']! > 0) Text('${s.posts}: ${counts['notes']}'),
            if (counts['races']! > 0) Text('${s.races}: ${counts['races']}'),
            if (counts['templates']! > 0) Text('${s.templates}: ${counts['templates']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(s.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(s.ok),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await _clearAndImportBox<Race>(
      'races', 
      data['races'] ?? [], 
      (json) => Race.fromJson(json as Map<String, dynamic>)
    );
    
    await _clearAndImportBox<QuestionnaireTemplate>(
      'templates', 
      data['templates'] ?? [], 
      (json) => QuestionnaireTemplate.fromJson(json as Map<String, dynamic>)
    );
    
    await _clearAndImportBox<Character>(
      'characters', 
      data['characters'] ?? [], 
      (json) => Character.fromJson(json as Map<String, dynamic>)
    );
    
    await _clearAndImportBox<Note>(
      'notes', 
      data['notes'] ?? [], 
      (json) => Note.fromJson(json as Map<String, dynamic>)
    );

    if (context.mounted) {
      _showSnackBar(
        context,
        s.local_restore_success(
          counts['characters'].toString(),
          counts['notes'].toString(),
          counts['races'].toString(),
          counts['templates'].toString(),
        )
      );
    }
  }
}