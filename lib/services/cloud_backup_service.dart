import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:hive/hive.dart';
import '../generated/l10n.dart';
import '../models/character_model.dart';
import '../models/note_model.dart';
import '../models/race_model.dart';
import '../models/template_model.dart';

class CloudBackupService {
  static const List<String> _scopes = [drive.DriveApi.driveFileScope];
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);
  drive.DriveApi? _driveApi;
  bool isProcessing = false;

  void _startProcessing() => isProcessing = true;
  void _endProcessing() => isProcessing = false;

  Future<void> _ensureBoxesAreOpen() async {
    if (!Hive.isBoxOpen('characters')) await Hive.openBox<Character>('characters');
    if (!Hive.isBoxOpen('notes')) await Hive.openBox<Note>('notes');
    if (!Hive.isBoxOpen('races')) await Hive.openBox<Race>('races');
    if (!Hive.isBoxOpen('templates')) await Hive.openBox<QuestionnaireTemplate>('templates');
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> exportAllToCloud(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final s = S.of(context);
    
    try {
      _startProcessing();
      
      await _ensureBoxesAreOpen();
      final backupData = {
        'characters': Hive.box<Character>('characters').values.map((e) => e.toJson()).toList(),
        'notes': Hive.box<Note>('notes').values.map((e) => e.toJson()).toList(),
        'races': Hive.box<Race>('races').values.map((e) => e.toJson()).toList(),
        'templates': Hive.box<QuestionnaireTemplate>('templates').values.map((e) => e.toJson()).toList(),
      };

      final backupJson = await compute(_jsonEncodeInIsolate, backupData);
      await _exportToGoogleDrive(context, backupJson, 'characterbook_backup');
      
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(s.cloud_backup_full_success)),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('${s.cloud_backup_error}: $e')),
      );
      debugPrint('Export error: $e');
    } finally {
      _endProcessing();
    }
  }

  static String _jsonEncodeInIsolate(Map<String, dynamic> data) {
    return jsonEncode(data);
  }

  Future<void> _exportToGoogleDrive(BuildContext context, String jsonStr, String prefix) async {
    try {
      final account = _googleSignIn.currentUser ?? await _googleSignIn.signIn();
      if (account == null) {
        debugPrint('Аутентификация отменена пользователем');
        if (context.mounted) {
          _showSnackBar(context, 'Вы не вошли в Google аккаунт', isError: true);
        }
        return;
      }

      final client = await _googleSignIn.authenticatedClient();
      if (client == null) {
        if (context.mounted) {
          _showSnackBar(context, 'Ошибка доступа к Google Drive', isError: true);
        }
        return;
      }

      if (jsonStr.isEmpty) {
        if (context.mounted) {
          _showSnackBar(context, 'Нет данных для сохранения', isError: true);
        }
        return;
      }

      final driveApi = drive.DriveApi(client);
      final fileName = '${prefix}_${DateTime.now().toIso8601String()}.json';

      await driveApi.files.create(
        drive.File()..name = fileName,
        uploadMedia: drive.Media(Stream.value(utf8.encode(jsonStr)), utf8.encode(jsonStr).length),
      );
      if (context.mounted) {
        _showSnackBar(context, 'Резервная копия создана в Google Drive');
      }
    } catch (e) {
      _showSnackBar(context, 'Ошибка: ${e.toString()}', isError: true);
    }
  }

  Future<String> _importFromGoogleDrive(
    BuildContext context,
    String prefix,
  ) async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) throw Exception(S.of(context).auth_cancelled);

      final client = await _googleSignIn.authenticatedClient();
      if (client == null) throw Exception(S.of(context).auth_client_error);

      _driveApi ??= drive.DriveApi(client);

      final files = await _driveApi!.files.list(
        q: "name contains '$prefix' and mimeType='application/json'",
        orderBy: 'createdTime desc',
        pageSize: 1,
      );

      if (files.files == null || files.files!.isEmpty) {
        throw Exception(S.of(context).cloud_backup_not_found);
      }

      final file = files.files!.first;
      final response = await _driveApi!.files.get(
        file.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final bytes = await _readStream(response.stream);
      return utf8.decode(bytes);
    } catch (e) {
      throw Exception('${S.of(context).cloud_import_error}: $e');
    }
  }

  Future<void> importAllFromCloud(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    try {
      _startProcessing();
      await _ensureBoxesAreOpen();
      
      final jsonStr = await _importFromGoogleDrive(context, 'characterbook_backup');
      
      final data = await compute(_jsonDecodeInIsolate, jsonStr);
      
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
        S.of(context).cloud_restore_success(
          counts['characters'].toString(),
          counts['notes'].toString(),
          counts['races'].toString(),
          counts['templates'].toString(),
        ),
      );
    } catch (e) {
      _showSnackBar(
        context, 
        '${S.of(context).cloud_restore_error}: $e'
      );
      debugPrint('Import error: $e');
    } finally {
      _endProcessing();
    }
  }

  static Map<String, dynamic> _jsonDecodeInIsolate(String jsonStr) {
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

  Future<Uint8List> _readStream(Stream<List<int>> stream) async {
    final bytesBuilder = BytesBuilder();
    await for (final chunk in stream) {
      bytesBuilder.add(chunk);
    }
    return bytesBuilder.toBytes();
  }
}

class _IsolateMessage<T> {
  final FutureOr<void> Function() computation;
  final SendPort sendPort;
  final SendPort errorPort;

  _IsolateMessage({
    required this.computation,
    required this.sendPort,
    required this.errorPort,
  });
}