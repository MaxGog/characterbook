import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/custom_field_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    
    _registerAdapters();
    
    await _openBoxes();
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
  }

  static Future<void> _openBoxes() async {
    await Future.wait([
      Hive.openBox<Character>('characters'),
      Hive.openBox<Note>('notes'),
      Hive.openBox<Race>('races'),
      Hive.openBox<QuestionnaireTemplate>('templates'),
    ]);
  }

  static Future<void> closeBoxes() async {
    await Hive.close();
  }
}