import 'dart:io';

import 'package:hive/hive.dart';
import 'package:characterbook/features/calendar/data/custom_event_record.dart';
import 'package:characterbook/features/characters/data/character_record.dart';
import 'package:characterbook/features/notes/data/note_record.dart';
import 'package:characterbook/features/races/data/race_record.dart';
import 'package:characterbook/features/relationships/data/relationship_record.dart';
import 'package:characterbook/features/sharing/data/export_pdf_settings_record.dart';
import 'package:characterbook/features/templates/data/template_record.dart';

String? _tempDirPath;

Future<void> setUpTestHive() async {
  final dir = Directory.systemTemp.createTempSync();
  _tempDirPath = dir.path;
  Hive.init(_tempDirPath!);

  registerHiveAdapters();
}

void registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CharacterRecordAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(NoteRecordAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(RaceRecordAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(TemplateRecordAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(CustomFieldRecordAdapter());
  }
  if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(RelationshipRecordAdapter());
  }
  if (!Hive.isAdapterRegistered(11)) {
    Hive.registerAdapter(ExportPdfSettingsRecordAdapter());
  }
  if (!Hive.isAdapterRegistered(13)) {
    Hive.registerAdapter(CustomEventRecordAdapter());
  }
}

Future<void> tearDownTestHive() async {
  if (_tempDirPath != null) {
    final dir = Directory(_tempDirPath!);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }
}
