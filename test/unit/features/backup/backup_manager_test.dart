import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/features/characters/data/character_record.dart';
import 'package:characterbook/features/notes/domain/note_model.dart';
import 'package:characterbook/features/notes/data/note_record.dart';
import 'package:characterbook/features/races/domain/race_model.dart';
import 'package:characterbook/features/races/data/race_record.dart';
import 'package:characterbook/features/templates/domain/template_model.dart';
import 'package:characterbook/features/templates/data/template_record.dart';
import 'package:characterbook/features/relationships/domain/relationship_model.dart';
import 'package:characterbook/features/relationships/data/relationship_record.dart';
import 'package:characterbook/features/characters/data/character_repository_hive.dart';
import 'package:characterbook/features/characters/domain/character_repository.dart';
import 'package:characterbook/features/notes/data/note_repository_hive.dart';
import 'package:characterbook/features/notes/domain/note_repository.dart';
import 'package:characterbook/features/races/data/race_repository_hive.dart';
import 'package:characterbook/features/races/domain/race_repository.dart';
import 'package:characterbook/features/templates/domain/template_repository.dart';
import 'package:characterbook/features/relationships/domain/relationship_repository.dart';
import 'package:characterbook/features/templates/data/template_repository_hive.dart';
import 'package:characterbook/features/relationships/data/relationship_repository_hive.dart';
import 'package:characterbook/features/backup/data/repository_backup_repository.dart';
import 'package:characterbook/features/backup/domain/backup_manager.dart';
import '../../../helpers/hive_test_utils.dart';

void main() {
  late BackupManager backupManager;
  late CharacterRepository characterRepo;
  late NoteRepository noteRepo;
  late RaceRepository raceRepo;
  late TemplateRepository templateRepo;
  late RelationshipRepository relationshipRepo;

  late Box<CharacterRecord> charBox;
  late Box<NoteRecord> noteBox;
  late Box<RaceRecord> raceBox;
  late Box<TemplateRecord> templateBox;
  late Box<RelationshipRecord> relBox;

  setUpAll(() async {
    await setUpTestHive();
  });

  setUp(() async {
    charBox = await Hive.openBox<CharacterRecord>('test_characters_backup');
    noteBox = await Hive.openBox<NoteRecord>('test_notes_backup');
    raceBox = await Hive.openBox<RaceRecord>('test_races_backup');
    templateBox = await Hive.openBox<TemplateRecord>('test_templates_backup');
    relBox =
        await Hive.openBox<RelationshipRecord>('test_relationships_backup');

    await charBox.clear();
    await noteBox.clear();
    await raceBox.clear();
    await templateBox.clear();
    await relBox.clear();

    characterRepo = CharacterRepositoryHive(charBox);
    noteRepo = NoteRepositoryHive(noteBox);
    raceRepo = RaceRepositoryHive(raceBox);
    templateRepo = TemplateRepositoryHive(templateBox);
    relationshipRepo = RelationshipRepositoryHive(relBox);

    backupManager = BackupManager(
      RepositoryBackupRepository(
        characterRepository: characterRepo,
        noteRepository: noteRepo,
        raceRepository: raceRepo,
        templateRepository: templateRepo,
        relationshipRepository: relationshipRepo,
      ),
    );
  });

  tearDown(() async {
    await charBox.close();
    await noteBox.close();
    await raceBox.close();
    await templateBox.close();
    await relBox.close();
  });

  tearDownAll(() async {
    await tearDownTestHive();
  });

  group('BackupManager', () {
    test('createBackup returns all data types including relationships',
        () async {
      final char = Character(id: 'c1', name: 'Hero');
      await characterRepo.save(char);

      final note = Note(id: 'n1', title: 'Note1', content: '', folderId: null);
      await noteRepo.save(note);

      final race = Race(id: 'r1', name: 'Elf');
      await raceRepo.save(race);

      final template =
          QuestionnaireTemplate(name: 'Basic', standardFields: ['name']);
      await templateRepo.save(template);

      final rel = Relationship(
          id: 'rel1', character1Id: 'c1', character2Id: 'c2', name: 'Friends');
      await relationshipRepo.save(rel);

      final data = await backupManager.createBackup();

      expect(
          data.keys,
          containsAll(
              ['characters', 'notes', 'races', 'templates', 'relationships']));
      expect(data['characters']!.length, 1);
      expect((data['characters']![0] as Map<String, dynamic>)['id'], 'c1');
      expect(data['notes']!.length, 1);
      expect(data['races']!.length, 1);
      expect(data['templates']!.length, 1);
      expect(data['relationships']!.length, 1);
      expect(
        (data['relationships']![0] as Map<String, dynamic>)['id'],
        'rel1',
      );
    });

    test('restoreBackup restores all types including relationships', () async {
      final char = Character(id: 'c1', name: 'Hero');
      await characterRepo.save(char);
      final note = Note(id: 'n1', title: 'Test', content: '', folderId: null);
      await noteRepo.save(note);
      final race = Race(id: 'r1', name: 'Dwarf');
      await raceRepo.save(race);
      final template = QuestionnaireTemplate(name: 'T1', standardFields: []);
      await templateRepo.save(template);
      final rel = Relationship(
          id: 'rel1', character1Id: 'c1', character2Id: 'c2', name: 'Friend');
      await relationshipRepo.save(rel);

      final rawData = await backupManager.createBackup();

      final jsonString = jsonEncode(rawData);
      final importData = jsonDecode(jsonString) as Map<String, dynamic>;

      await characterRepo.clear();
      await noteRepo.clear();
      await raceRepo.clear();
      await templateRepo.clear();
      await relationshipRepo.clear();

      await backupManager.restoreBackup(importData);

      final chars = await characterRepo.getAll();
      expect(chars.length, 1);
      expect(chars.first.name, 'Hero');

      final notes = await noteRepo.getAll();
      expect(notes.length, 1);
      expect(notes.first.title, 'Test');

      final races = await raceRepo.getAll();
      expect(races.length, 1);
      expect(races.first.name, 'Dwarf');

      final templates = await templateRepo.getAll();
      expect(templates.length, 1);
      expect(templates.first.name, 'T1');

      final relationships = await relationshipRepo.getAll();
      expect(relationships.length, 1);
      expect(relationships.first.name, 'Friend');
    });

    test('restoreBackup clears all data before restoring', () async {
      final charOld = Character(id: 'old', name: 'Old');
      await characterRepo.save(charOld);
      final relOld =
          Relationship(id: 'oldRel', character1Id: 'a', character2Id: 'b');
      await relationshipRepo.save(relOld);

      final newData = {
        'characters': [Character(id: 'new', name: 'New').toJson()],
        'notes': <Map>[],
        'races': <Map>[],
        'templates': <Map>[],
        'relationships': <Map>[],
      };

      await backupManager.restoreBackup(newData);

      final chars = await characterRepo.getAll();
      expect(chars.length, 1);
      expect(chars.first.name, 'New');

      final rels = await relationshipRepo.getAll();
      expect(rels.length, 0);
    });

    test(
        'restoreBackup handles missing relationships key gracefully for old backups',
        () async {
      final oldFormatData = {
        'characters': [Character(id: 'c1', name: 'OldHero').toJson()],
        'notes': [],
        'races': [],
        'templates': [],
      };

      final rel = Relationship(id: 'r1', character1Id: 'x', character2Id: 'y');
      await relationshipRepo.save(rel);

      await backupManager.restoreBackup(oldFormatData);

      final relationships = await relationshipRepo.getAll();
      expect(relationships.length, 0);

      final chars = await characterRepo.getAll();
      expect(chars.length, 1);
      expect(chars.first.name, 'OldHero');
    });

    test('restoreBackup with empty sections clears all', () async {
      await characterRepo.save(Character(id: '1', name: 'A'));
      await relationshipRepo.save(
        Relationship(id: 'r1', character1Id: '1', character2Id: '2'),
      );

      final emptyData = {
        'characters': [],
        'notes': [],
        'races': [],
        'templates': [],
        'relationships': [],
      };

      await backupManager.restoreBackup(emptyData);

      expect((await characterRepo.getAll()).length, 0);
      expect((await relationshipRepo.getAll()).length, 0);
    });

    test('restoreBackup rejects an unknown format without clearing data',
        () async {
      await characterRepo.save(Character(id: 'kept', name: 'Keep me'));

      expect(
        () => backupManager.restoreBackup({'unknown': []}),
        throwsFormatException,
      );

      expect((await characterRepo.getAll()).single.name, 'Keep me');
    });

    test('restoreBackup validates rows before clearing existing data',
        () async {
      await characterRepo.save(Character(id: 'kept', name: 'Keep me'));

      expect(
        () => backupManager.restoreBackup({
          'characters': ['not an object'],
        }),
        throwsFormatException,
      );

      expect((await characterRepo.getAll()).single.name, 'Keep me');
    });
  });
}
