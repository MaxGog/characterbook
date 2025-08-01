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
      String? filePath;
      
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        filePath = await _showNativeFileDialog(fileExtension: fileExtension);
      } else {
        filePath = await _channel.invokeMethod<String>('pickFile', {
          'fileExtension': fileExtension,
        });
      }
      
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

  static Future<String?> _showNativeFileDialog({String? fileExtension}) async {
    if (Platform.isWindows) {
      return await _showWindowsFileDialog(fileExtension: fileExtension);
    } else if (Platform.isMacOS) {
      return await _showMacOSFileDialog(fileExtension: fileExtension);
    } else if (Platform.isLinux) {
      return await _showLinuxFileDialog(fileExtension: fileExtension);
    }
    return null;
  }

  static Future<String?> _showWindowsFileDialog({String? fileExtension}) async {
    try {
      final result = await Process.run('powershell', [
        '-Command',
        '''
        Add-Type -AssemblyName System.Windows.Forms
        \$dialog = New-Object System.Windows.Forms.OpenFileDialog
        \$dialog.Title = "Select File"
        \$dialog.Filter = "Supported files (*.json, *.characterbook, *.character, *.race, *.chax)|*.json;*.characterbook;*.character;*.race;*.chax|All files (*.*)|*.*"
        \$dialog.Multiselect = \$false
        if (\$dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
          Write-Output \$dialog.FileName
        }
        '''
      ]);

      if (result.exitCode == 0 && result.stdout.toString().trim().isNotEmpty) {
        return result.stdout.toString().trim();
      }
      return null;
    } catch (e) {
      debugPrint('Windows file dialog error: $e');
      return null;
    }
  }

  static Future<String?> _showMacOSFileDialog({String? fileExtension}) async {
    try {
      List<String> arguments = [
        '-e',
        'tell application "System Events"',
        '-e', 'activate',
        '-e', 'set theFile to choose file with prompt "Select File"',
        '-e', 'POSIX path of theFile',
        '-e', 'end tell'
      ];

      final result = await Process.run('osascript', arguments);

      if (result.exitCode == 0 && result.stdout.toString().trim().isNotEmpty) {
        return result.stdout.toString().trim();
      }
      return null;
    } catch (e) {
      debugPrint('macOS file dialog error: $e');
      return null;
    }
  }

  static Future<String?> _showLinuxFileDialog({String? fileExtension}) async {
    try {
      final zenityCheck = await Process.run('which', ['zenity']);
      if (zenityCheck.exitCode != 0) {
        debugPrint('zenity not found, trying with kdialog');
        final kdialogCheck = await Process.run('which', ['kdialog']);
        if (kdialogCheck.exitCode != 0) {
          debugPrint('Neither zenity nor kdialog found');
          return null;
        }
        final result = await Process.run('kdialog', ['--getopenfilename']);
        if (result.exitCode == 0 && result.stdout.toString().trim().isNotEmpty) {
          return result.stdout.toString().trim();
        }
        return null;
      }

      final result = await Process.run('zenity', [
        '--file-selection',
        '--title=Select File',
        '--file-filter=Supported files (*.json *.characterbook *.character *.race *.chax) | *.json *.characterbook *.character *.race *.chax',
        '--file-filter=All files | *'
      ]);

      if (result.exitCode == 0 && result.stdout.toString().trim().isNotEmpty) {
        return result.stdout.toString().trim();
      }
      return null;
    } catch (e) {
      debugPrint('Linux file dialog error: $e');
      return null;
    }
  }
}