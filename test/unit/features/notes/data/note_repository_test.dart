import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:characterbook/features/notes/domain/note_model.dart';
import 'package:characterbook/features/notes/data/note_repository_hive.dart';
import 'package:characterbook/features/notes/data/note_record.dart';
import 'package:characterbook/features/notes/domain/note_repository.dart';

import '../../../../helpers/hive_test_utils.dart';

void main() {
  late NoteRepository repository;
  late Box<NoteRecord> box;

  setUpAll(() async {
    await setUpTestHive();
  });

  setUp(() async {
    box = await Hive.openBox<NoteRecord>('test_notes');
    await box.clear();
    repository = NoteRepositoryHive(box);
  });

  tearDown(() async {
    await box.close();
  });

  tearDownAll(() async {
    await tearDownTestHive();
  });

  group('NoteRepository', () {
    test('save() adds note to box', () async {
      final note = Note(
        title: 'First note',
        content: 'Hello',
        folderId: null,
      );
      await repository.save(note);
      expect(box.values.length, 1);
      expect(box.values.single.title, 'First note');
    });

    test('save() updates existing note', () async {
      final original = Note(
        id: 'note-1',
        title: 'Original',
        content: '...',
        folderId: null,
      );
      await repository.save(original);

      final updated = Note(
        id: 'note-1',
        title: 'Updated',
        content: 'New content',
        folderId: null,
      );
      await repository.save(updated);

      expect(box.values.single.title, 'Updated');
      expect(box.values.length, 1);
    });

    test('delete() removes note', () async {
      final note = Note(title: 'To delete', content: '', folderId: null);
      await repository.save(note);
      await repository.delete(note.id);
      expect(box.isEmpty, isTrue);
    });

    test('getAll() returns all notes', () async {
      final note1 = Note(title: 'A', content: '', folderId: null);
      final note2 = Note(title: 'B', content: '', folderId: null);

      await repository.save(note1);
      await repository.save(note2);

      final all = await repository.getAll();
      expect(all.length, 2);
      expect(all.map((n) => n.title), containsAll(['A', 'B']));
    });

    test('getNotesForCharacter() filters by characterId', () async {
      final note1 = Note(
        title: 'Note 1',
        content: '',
        characterIds: ['char1'],
        folderId: null,
      );
      final note2 = Note(
        title: 'Note 2',
        content: '',
        characterIds: ['char2'],
        folderId: null,
      );
      await repository.save(note1);
      await repository.save(note2);

      final forChar1 = await repository.getNotesForCharacter('char1');
      expect(forChar1.length, 1);
      expect(forChar1.first.title, 'Note 1');
    });

    test('clear() removes all notes', () async {
      final note1 = Note(title: '1', content: '', folderId: null);
      final note2 = Note(title: '2', content: '', folderId: null);
      await repository.save(note1);
      await repository.save(note2);
      await repository.clear();
      expect(await repository.getAll(), isEmpty);
    });

    test('reorder() changes order', () async {
      final noteA = Note(id: 'a', title: 'A', content: '', folderId: null);
      final noteB = Note(id: 'b', title: 'B', content: '', folderId: null);
      final noteC = Note(id: 'c', title: 'C', content: '', folderId: null);

      await repository.save(noteA);
      await repository.save(noteB);
      await repository.save(noteC);

      await repository.reorder(0, 2);
      final ordered = await repository.getAll();
      expect(ordered[0].title, 'B');
      expect(ordered[1].title, 'C');
      expect(ordered[2].title, 'A');
    });
  });
}
