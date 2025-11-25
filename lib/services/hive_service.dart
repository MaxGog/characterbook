import 'package:characterbook/models/characters/character_model.dart';
import 'package:characterbook/models/characters/character_universal_model.dart';
import 'package:characterbook/models/custom_field_model.dart';
import 'package:characterbook/models/export_pdf_settings_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/characters/template_model.dart';
import 'package:characterbook/services/migration_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final Map<String, Box> _openBoxes = {};
  static bool _isInitialized = false;

  static Future<void> initHive() async {
    if (!_isInitialized) {
      await Hive.initFlutter();
      _registerAdapters();
      _isInitialized = true;
    }
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(CharacterAdapter().typeId)) {
      Hive.registerAdapter(CharacterAdapter());
    }
    if (!Hive.isAdapterRegistered(NoteAdapter().typeId)) {
      Hive.registerAdapter(NoteAdapter());
    }
    if (!Hive.isAdapterRegistered(RaceAdapter().typeId)) {
      Hive.registerAdapter(RaceAdapter());
    }
    if (!Hive.isAdapterRegistered(QuestionnaireTemplateAdapter().typeId)) {
      Hive.registerAdapter(QuestionnaireTemplateAdapter());
    }
    if (!Hive.isAdapterRegistered(CustomFieldAdapter().typeId)) {
      Hive.registerAdapter(CustomFieldAdapter());
    }
    if (!Hive.isAdapterRegistered(FolderAdapter().typeId)) {
      Hive.registerAdapter(FolderAdapter());
    }
    if (!Hive.isAdapterRegistered(FolderTypeAdapter().typeId)) {
      Hive.registerAdapter(FolderTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(ExportPdfSettingsAdapter().typeId)) {
      Hive.registerAdapter(ExportPdfSettingsAdapter());
    }
    if (!Hive.isAdapterRegistered(CharacterUniversalAdapter().typeId)) {
      Hive.registerAdapter(CharacterUniversalAdapter());
    }
    
  }

  static Future<Box<T>> getCharacterBox<T>() async {
    final useUniversal = await MigrationService.shouldUseUniversal();
    
    if (useUniversal) {
      return await getBox<T>('characters_universal');
    } else {
      return await getBox<T>('characters');
    }
  }

  static Future<List<dynamic>> getAllCharacters() async {
    final useUniversal = await MigrationService.shouldUseUniversal();
    
    if (useUniversal) {
      final box = await getBox<CharacterUniversal>('characters_universal');
      return box.values.toList();
    } else {
      final box = await getBox<Character>('characters');
      return box.values.toList();
    }
  }

  static Future<Box<T>> getBox<T>(String name) async {
    if (_openBoxes.containsKey(name)) {
      return _openBoxes[name]! as Box<T>;
    }
    
    final box = await Hive.openBox<T>(name);
    _openBoxes[name] = box;
    return box;
  }

  static Box<T>? getOpenBox<T>(String name) {
    return _openBoxes.containsKey(name) ? _openBoxes[name]! as Box<T> : null;
  }

  static Future<void> closeBox(String name) async {
    if (_openBoxes.containsKey(name)) {
      await _openBoxes[name]!.close();
      _openBoxes.remove(name);
    }
  }

  static Future<void> closeBoxes() async {
    await Future.wait(_openBoxes.values.map((box) => box.close()));
    _openBoxes.clear();
  }
}