import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import '../models/character_model.dart';
import '../models/race_model.dart';
import '../models/template_model.dart';

class FilePickerService {
  static const _channel = MethodChannel('file_picker');

  Future<Map<String, dynamic>?> pickRestoreFile() async {
    try {
      if (kIsWeb) {
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
      } else {
        final file = await _pickFileNative(fileExtension: '.json,.characterbook');
        if (file == null) return null;
        final jsonStr = await file.readAsString();
        if (jsonStr.isEmpty) return null;

        try {
          final decoded = jsonDecode(jsonStr);
          if (decoded is Map<String, dynamic>) {
            return decoded;
          }
          return null;
        } catch (e) {
          debugPrint('JSON decode error: $e');
          return null;
        }
      }
    } catch (e) {
      debugPrint('Restore file picker error: $e');
      return null;
    }
  }

  Future<File?> _pickFileNative({String? fileExtension}) async {
    try {
      final filePath = await _channel.invokeMethod<String>('pickFile', {
        'fileExtension': fileExtension,
      });
      if (filePath == null || filePath.isEmpty) return null;
      return File(filePath);
    } catch (e) {
      debugPrint('File picker error: $e');
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
        final file = await _pickFileNative(fileExtension: '.character');
        if (file == null) return null;
        jsonStr = await file.readAsString();
      }

      if (jsonStr.isEmpty) return null;

      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      return Character.fromJson(jsonMap);
    } catch (e) {
      throw Exception(e);
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
        final file = await _pickFileNative(fileExtension: '.race');
        if (file == null) return null;
        jsonStr = await file.readAsString();
      }

      if (jsonStr.isEmpty) return null;

      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      return Race.fromJson(jsonMap);
    } catch (e) {
      throw Exception(e);
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
        final file = await _pickFileNative(fileExtension: '.chax');
        if (file == null) return null;
        jsonStr = await file.readAsString();
      }

      if (jsonStr == null || jsonStr.isEmpty) {
        return null;
      }

      final jsonMap = jsonDecode(jsonStr) as Map<String, dynamic>;
      return QuestionnaireTemplate.fromJson(jsonMap);
    } catch (e) {
      throw Exception(e);
    }
  }
}