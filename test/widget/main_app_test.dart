import 'dart:io';
import 'package:characterbook/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:characterbook/features/characters/data/character_record.dart';
import 'package:characterbook/features/notes/data/note_record.dart';
import 'package:characterbook/features/races/data/race_record.dart';
import 'package:characterbook/features/templates/data/template_record.dart';
import 'package:characterbook/features/relationships/data/relationship_record.dart';
import 'package:characterbook/features/sharing/data/export_pdf_settings_record.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/features/backup/data/cloud_backup_service.dart';
import 'package:characterbook/features/backup/data/local_backup_service.dart';
import 'package:characterbook/features/backup/data/repository_backup_repository.dart';
import 'package:characterbook/features/backup/domain/backup_manager.dart';
import 'package:characterbook/features/backup/domain/backup_repository.dart';
import 'package:characterbook/features/backup/presentation/backup_settings_screen.dart';
import 'package:characterbook/core/storage/hive_service.dart';
import '../helpers/hive_test_utils.dart';

void main() {
  late Box<CharacterRecord> charBox;
  late Box<RaceRecord> raceBox;
  late Box<NoteRecord> noteBox;
  late Box<TemplateRecord> templateBox;
  late Box<ExportPdfSettingsRecord> settingsBox;
  late Box<RelationshipRecord> relBox;
  late Box<bool> appSettingsBox;
  late Box<CharacterRecord> charactersBox;

  setUp(() async {
    final dir = await Directory.systemTemp.createTemp('hive_test_main');
    Hive.init(dir.path);
    registerHiveAdapters();

    charBox = await Hive.openBox<CharacterRecord>('test_chars');
    raceBox = await Hive.openBox<RaceRecord>('test_races');
    noteBox = await Hive.openBox<NoteRecord>('test_notes');
    templateBox = await Hive.openBox<TemplateRecord>('test_templates');
    settingsBox =
        await Hive.openBox<ExportPdfSettingsRecord>('test_pdf_settings');
    relBox = await Hive.openBox<RelationshipRecord>('test_relationships');
    appSettingsBox = await Hive.openBox<bool>('test_app_settings');
    charactersBox = await Hive.openBox<CharacterRecord>('characters');

    HiveService.setBoxesForTesting(
      characterBox: charBox,
      raceBox: raceBox,
      noteBox: noteBox,
      templateBox: templateBox,
      settingsBox: settingsBox,
      relationshipBox: relBox,
      appSettingsBox: appSettingsBox,
    );
  });

  tearDown(() async {
    await charBox.close();
    await raceBox.close();
    await noteBox.close();
    await templateBox.close();
    await settingsBox.close();
    await relBox.close();
    await appSettingsBox.close();
    await charactersBox.close();
    for (final name in [
      'test_chars',
      'test_races',
      'test_notes',
      'test_templates',
      'test_pdf_settings',
      'test_relationships',
      'test_app_settings',
      'characters',
    ]) {
      Hive.deleteBoxFromDisk(name);
    }
    HiveService.setBoxesForTesting();
  });

  testWidgets('CharacterBookApp создаёт backup-модуль с репозиториями',
      (tester) async {
    await tester.pumpWidget(
      CharacterBookApp(hiveInitialized: true),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(MaterialApp));
    final backupRepository =
        Provider.of<BackupRepository>(context, listen: false);

    expect(backupRepository, isA<RepositoryBackupRepository>());
    expect(
      Provider.of<BackupManager>(context, listen: false),
      isA<BackupManager>(),
    );
  });

  testWidgets('LocalBackupService и CloudBackupService доступны',
      (tester) async {
    await tester.pumpWidget(
      CharacterBookApp(hiveInitialized: true),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(MaterialApp));

    final localBackup = Provider.of<LocalBackupService>(context, listen: false);
    final cloudBackup = Provider.of<CloudBackupService>(context, listen: false);

    expect(localBackup, isNotNull);
    expect(cloudBackup, isNotNull);
  });

  testWidgets('BackupSettingsScreen is hosted by the backup feature',
      (tester) async {
    await tester.pumpWidget(
      CharacterBookApp(hiveInitialized: true),
    );
    await tester.pumpAndSettle();

    final navigator =
        tester.state<NavigatorState>(find.byType(Navigator).first);
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => const BackupSettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BackupSettingsScreen), findsOneWidget);
    expect(find.text(S.current.auto_cloud_backup_title), findsOneWidget);
  });
}
