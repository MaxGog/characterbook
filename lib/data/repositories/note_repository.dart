import 'package:characterbook/data/models/note_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class NoteRepository {
  Stream<List<Note>> watchAll();
  Future<List<Note>> getAll();
  Future<Note?> getById(dynamic key);
  Future<dynamic> save(Note note, {dynamic key});
  Future<void> delete(dynamic key);
  Future<List<Note>> getNotesForCharacter(String characterId);
  Future<void> reorder(int oldIndex, int newIndex);
  Future<void> clear();
}

class NoteRepositoryHive implements NoteRepository {
  final Box<Note> _box;

  NoteRepositoryHive(this._box);

  @override
  Stream<List<Note>> watchAll() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList());
  }

  @override
  Future<List<Note>> getAll() async => _box.values.toList();

  @override
  Future<Note?> getById(dynamic key) async => _box.get(key);

  @override
  Future<dynamic> save(Note note, {dynamic key}) async {
    if (key != null) {
      await _box.put(key, note);
      return key;
    } else {
      return await _box.add(note);
    }
  }

  @override
  Future<void> delete(dynamic key) async => _box.delete(key);

  @override
  Future<List<Note>> getNotesForCharacter(String characterId) async =>
      _box.values
          .where((note) => note.characterIds.contains(characterId))
          .toList();

  @override
  Future<void> reorder(int oldIndex, int newIndex) async {
    final items = _box.values.toList();
    if (oldIndex < 0 ||
        oldIndex >= items.length ||
        newIndex < 0 ||
        newIndex >= items.length) {
      return;
    }
    final updated = List<Note>.from(items);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    await _box.clear();
    await _box.addAll(updated);
  }

  @override
  Future<void> clear() async => _box.clear();
}
