import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import '../models/characters/character_model.dart';
import '../models/race_model.dart';
import '../models/characters/template_model.dart';

class FilePickerService {
  static const _channel = MethodChannel('file_picker');

  Future<Map<String, dynamic>?> pickRestoreFile() async {
    try {
      if (kIsWeb) {
        return await _pickRestoreFileWeb();
      } else {
        return await _pickRestoreFileNative();
      }
    } catch (e) {
      debugPrint('Restore file picker error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _pickRestoreFileWeb() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.json,.characterbook';
    uploadInput.click();

    await uploadInput.onChange.first;
    final files = uploadInput.files;
    if (files == null || files.isEmpty) return null;

    final file = files[0];
    final reader = html.FileReader();
    reader.readAsText(file);
    await reader.onLoadEnd.first;
    final jsonStr = reader.result as String;

    if (jsonStr.isEmpty) return null;
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> _pickRestoreFileNative() async {
    try {
      final filePath =
          await _pickFileNative(fileExtension: '.json,.characterbook');
      if (filePath == null || filePath.isEmpty) {
        debugPrint('No file selected or empty file path');
        return null;
      }

      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('File does not exist: $filePath');
        return null;
      }

      final jsonStr = await file.readAsString();
      if (jsonStr.isEmpty) {
        debugPrint('File is empty');
        return null;
      }

      try {
        final decoded = jsonDecode(jsonStr);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          debugPrint('Decoded JSON is not a Map: ${decoded.runtimeType}');
          return null;
        }
      } catch (e) {
        debugPrint('JSON decode error: $e');
        return null;
      }
    } catch (e) {
      debugPrint('Native restore file picker error: $e');
      return null;
    }
  }

  Future<String?> _pickFileNative({String? fileExtension}) async {
    try {
      debugPrint('Requesting file pick with extension: $fileExtension');

      final result = await _channel.invokeMethod<String>('pickFile', {
        'fileExtension': fileExtension,
      });

      debugPrint('File picker result: $result');
      return result;
    } catch (e) {
      debugPrint('File picker channel error: $e');
      return null;
    }
  }

  Future<Character?> importCharacter() async {
    try {
      String? jsonStr;

      if (kIsWeb) {
        final uploadInput = html.FileUploadInputElement();
        uploadInput.accept = '.character';
        uploadInput.click();

        await uploadInput.onChange.first;
        final files = uploadInput.files;
        if (files == null || files.isEmpty) return null;

        final file = files[0];
        final reader = html.FileReader();
        reader.readAsText(file);
        await reader.onLoadEnd.first;
        jsonStr = reader.result as String;
      } else {
        final filePath = await _pickFileNative(fileExtension: '.character');
        if (filePath == null) return null;
        final file = File(filePath);
        jsonStr = await file.readAsString();
      }

      if (jsonStr.isEmpty) return null;

      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      return Character.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to import character: $e');
    }
  }

  Future<Race?> importRace() async {
    try {
      String? jsonStr;

      if (kIsWeb) {
        final uploadInput = html.FileUploadInputElement();
        uploadInput.accept = '.race';
        uploadInput.click();

        await uploadInput.onChange.first;
        final files = uploadInput.files;
        if (files == null || files.isEmpty) return null;

        final file = files[0];
        final reader = html.FileReader();
        reader.readAsText(file);
        await reader.onLoadEnd.first;
        jsonStr = reader.result as String;
      } else {
        final filePath = await _pickFileNative(fileExtension: '.race');
        if (filePath == null) return null;
        final file = File(filePath);
        jsonStr = await file.readAsString();
      }

      if (jsonStr.isEmpty) return null;

      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      return Race.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to import race: $e');
    }
  }

  Future<QuestionnaireTemplate?> importTemplate() async {
    try {
      String? jsonStr;

      if (kIsWeb) {
        final uploadInput = html.FileUploadInputElement();
        uploadInput.accept = '.chax';
        uploadInput.click();

        await uploadInput.onChange.first;
        final files = uploadInput.files;
        if (files == null || files.isEmpty) return null;

        final file = files[0];
        final reader = html.FileReader();
        reader.readAsText(file);
        await reader.onLoadEnd.first;
        jsonStr = reader.result as String?;
      } else {
        final filePath = await _pickFileNative(fileExtension: '.chax');
        if (filePath == null) return null;
        final file = File(filePath);
        jsonStr = await file.readAsString();
      }

      if (jsonStr == null || jsonStr.isEmpty) {
        return null;
      }

      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      return QuestionnaireTemplate.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to import template: $e');
    }
  }
}
