import 'package:characterbook/features/calendar/data/custom_event_record.dart';
import 'package:characterbook/features/sharing/data/export_pdf_settings_record.dart';
import 'package:characterbook/features/relationships/data/relationship_record.dart';
import 'package:characterbook/features/templates/data/template_record.dart';
import 'package:characterbook/features/characters/data/character_record.dart';
import 'package:characterbook/features/notes/data/note_record.dart';
import 'package:characterbook/features/races/data/race_record.dart';
import 'package:characterbook/core/storage/hive_migration.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const _hiveDirectoryName = 'Characterbook data';
  static bool _isInitialized = false;

  static Box<CharacterRecord>? _characterBox;
  static Box<RaceRecord>? _raceBox;
  static Box<NoteRecord>? _noteBox;
  static Box<TemplateRecord>? _templateBox;
  static Box<ExportPdfSettingsRecord>? _settingsBox;
  static Box<RelationshipRecord>? _relationshipBox;
  static Box<CustomEventRecord>? _customEventBox;
  static Box<bool>? _appSettingsBox;

  static Box<CharacterRecord>? get characterBox => _characterBox;
  static Box<RaceRecord>? get raceBox => _raceBox;
  static Box<NoteRecord>? get noteBox => _noteBox;
  static Box<TemplateRecord>? get templateBox => _templateBox;
  static Box<ExportPdfSettingsRecord>? get settingsBox => _settingsBox;
  static Box<RelationshipRecord>? get relationshipBox => _relationshipBox;
  static Box<CustomEventRecord>? get customEventBox => _customEventBox;
  static Box<bool>? get appSettingsBox => _appSettingsBox;

  static Future<void> initializeAll() async {
    if (!_isInitialized) {
      await migrateLegacyHiveFiles();
      await Hive.initFlutter(_hiveDirectoryName);
      _registerAdapters();
      _isInitialized = true;
    }
    _characterBox = await _openBox<CharacterRecord>('characters');
    _raceBox = await _openBox<RaceRecord>('races');
    _noteBox = await _openBox<NoteRecord>('notes');
    _templateBox = await _openBox<TemplateRecord>('templates');
    _settingsBox = await _openBox<ExportPdfSettingsRecord>('pdf_settings');
    _relationshipBox = await _openBox<RelationshipRecord>('relationships');
    _customEventBox = await _openBox<CustomEventRecord>('custom_events');
    _appSettingsBox = await _openBox<bool>('app_settings');
  }

  static void setBoxesForTesting({
    Box<CharacterRecord>? characterBox,
    Box<RaceRecord>? raceBox,
    Box<NoteRecord>? noteBox,
    Box<TemplateRecord>? templateBox,
    Box<ExportPdfSettingsRecord>? settingsBox,
    Box<RelationshipRecord>? relationshipBox,
    Box<CustomEventRecord>? customEventBox,
    Box<bool>? appSettingsBox,
  }) {
    _characterBox = characterBox;
    _raceBox = raceBox;
    _noteBox = noteBox;
    _templateBox = templateBox;
    _settingsBox = settingsBox;
    _relationshipBox = relationshipBox;
    _customEventBox = customEventBox;
    _appSettingsBox = appSettingsBox;
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(CharacterRecordAdapter().typeId)) {
      Hive.registerAdapter(CharacterRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(NoteRecordAdapter().typeId)) {
      Hive.registerAdapter(NoteRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(RaceRecordAdapter().typeId)) {
      Hive.registerAdapter(RaceRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(TemplateRecordAdapter().typeId)) {
      Hive.registerAdapter(TemplateRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(CustomFieldRecordAdapter().typeId)) {
      Hive.registerAdapter(CustomFieldRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(ExportPdfSettingsRecordAdapter().typeId)) {
      Hive.registerAdapter(ExportPdfSettingsRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(RelationshipRecordAdapter().typeId)) {
      Hive.registerAdapter(RelationshipRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(CustomEventRecordAdapter().typeId)) {
      Hive.registerAdapter(CustomEventRecordAdapter());
    }
  }

  static Future<Box<T>> _openBox<T>(String name) => Hive.openBox<T>(name);

  static Future<Box<T>> openBox<T>(String name) async {
    return await Hive.openBox<T>(name);
  }

  static Future<void> deleteBox(String name) async {
    await Hive.deleteBoxFromDisk(name);
  }
}
