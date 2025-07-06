import 'dart:convert';
import 'dart:typed_data';
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

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _exportDataToCloud<T>(
    BuildContext context,
    String boxName,
    String successMessage,
    String errorMessage,
    String fileNamePrefix,
  ) async {
    try {
      final box = Hive.box<T>(boxName);
      final items = box.values.toList();
      final jsonStr = jsonEncode(items.map((item) => (item as dynamic).toJson()).toList());

      await _exportToGoogleDrive(context, jsonStr, fileNamePrefix);

      _showSnackBar(context, successMessage);
    } catch (e) {
      _showSnackBar(context, '$errorMessage: $e', isError: true);
    }
  }

  Future<void> _importDataFromCloud<T>(
    BuildContext context,
    String boxName,
    String successMessage,
    String errorMessage,
    String fileNamePrefix,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final jsonStr = await _importFromGoogleDrive(context, fileNamePrefix);
      final box = Hive.box<T>(boxName);
      await box.clear();

      final List<dynamic> jsonList = jsonDecode(jsonStr);
      for (final json in jsonList) {
        await box.add(fromJson(json));
      }

      _showSnackBar(context, successMessage.replaceFirst('{}', jsonList.length.toString()));
    } catch (e) {
      _showSnackBar(context, '$errorMessage: $e', isError: true);
    }
  }

  Future<void> exportAllToCloud(BuildContext context) async {
    try {
      final backupData = {
        'characters': Hive.box<Character>('characters').values.toList(),
        'notes': Hive.box<Note>('notes').values.toList(),
        'races': Hive.box<Race>('races').values.toList(),
        'templates': Hive.box<QuestionnaireTemplate>('templates').values.toList(),
      };
      final backupJson = jsonEncode(backupData);

      await _exportToGoogleDrive(context, backupJson, 'characterbook_backup');

      _showSnackBar(context, S.of(context).cloud_backup_full_success);
    } catch (e) {
      _showSnackBar(context, '${S.of(context).cloud_backup_error}: $e', isError: true);
    }
  }

  Future<void> exportCharactersToCloud(BuildContext context) async {
    await _exportDataToCloud<Character>(
      context,
      'characters',
      S.of(context).cloud_backup_characters_success,
      S.of(context).cloud_backup_characters_error,
      'characters_backup',
    );
  }

  Future<void> exportNotesToCloud(BuildContext context) async {
    await _exportDataToCloud<Note>(
      context,
      'notes',
      S.of(context).operationCompleted,
      S.of(context).error,
      'notes_backup',
    );
  }

  Future<void> exportRacesToCloud(BuildContext context) async {
    await _exportDataToCloud<Race>(
      context,
      'races',
      S.of(context).operationCompleted,
      S.of(context).error,
      'races_backup',
    );
  }

  Future<void> exportTemplatesToCloud(BuildContext context) async {
    await _exportDataToCloud<QuestionnaireTemplate>(
      context,
      'templates',
      S.of(context).operationCompleted,
      S.of(context).error,
      'templates_backup',
    );
  }

  Future<void> importAllFromCloud(BuildContext context) async {
    try {
      final jsonStr = await _importFromGoogleDrive(context, 'characterbook_backup');
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
        S.of(context).cloud_restore_success(
          counts['characters'].toString(),
          counts['notes'].toString(),
          counts['races'].toString(),
          counts['templates'].toString(),
        ),
      );
    } catch (e) {
      _showSnackBar(context, '${S.of(context).cloud_restore_error}: $e', isError: true);
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

  Future<void> importCharactersFromCloud(BuildContext context) async {
    await _importDataFromCloud<Character>(
      context,
      'characters',
      S.of(context).character_imported('{}'),
      S.of(context).cloud_restore_error,
      'characters_backup',
      Character.fromJson,
    );
  }

  Future<void> importNotesFromCloud(BuildContext context) async {
    await _importDataFromCloud<Note>(
      context,
      'notes',
      S.of(context).operationCompleted,
      S.of(context).error,
      'notes_backup',
      Note.fromJson,
    );
  }

  Future<void> importRacesFromCloud(BuildContext context) async {
    await _importDataFromCloud<Race>(
      context,
      'races',
      S.of(context).race_imported('{}'),
      S.of(context).error,
      'races_backup',
      Race.fromJson,
    );
  }

  Future<void> importTemplatesFromCloud(BuildContext context) async {
    await _importDataFromCloud<QuestionnaireTemplate>(
      context,
      'templates',
      S.of(context).template_imported('{}'),
      S.of(context).error,
      'templates_backup',
      QuestionnaireTemplate.fromJson,
    );
  }

  Future<void> _exportToGoogleDrive(
    BuildContext context,
    String jsonStr,
    String prefix,
  ) async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) throw Exception(S.of(context).auth_cancelled);

      final client = await _googleSignIn.authenticatedClient();
      if (client == null) throw Exception(S.of(context).auth_client_error);

      _driveApi ??= drive.DriveApi(client);

      final fileMetadata = drive.File()
        ..name = '${prefix}_${DateTime.now().toIso8601String()}.json'
        ..mimeType = 'application/json';

      final bytes = Uint8List.fromList(utf8.encode(jsonStr));
      final media = drive.Media(Stream.value(bytes), bytes.length);

      await _driveApi!.files.create(
        fileMetadata,
        uploadMedia: media,
      );
    } catch (e) {
      throw Exception('${S.of(context).cloud_export_error}: $e');
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

  Future<Uint8List> _readStream(Stream<List<int>> stream) async {
    final bytesBuilder = BytesBuilder();
    await for (final chunk in stream) {
      bytesBuilder.add(chunk);
    }
    return bytesBuilder.toBytes();
  }
}