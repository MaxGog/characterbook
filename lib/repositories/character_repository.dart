import 'package:characterbook/models/character_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class CharacterRepository {
  Stream<List<Character>> watchAll();
  Future<List<Character>> getAll();
  Future<dynamic> save(Character character, {dynamic key});
  Future<void> delete(dynamic key);
  Future<void> reorder(int oldIndex, int newIndex);
  Future<void> clear();
}

class CharacterRepositoryHive implements CharacterRepository {
  final Box<Character> _box;

  CharacterRepositoryHive(this._box);

  @override
  Stream<List<Character>> watchAll() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList());
  }

  @override
  Future<List<Character>> getAll() async => _box.values.toList();

  @override
  Future<dynamic> save(Character character, {dynamic key}) async {
    if (key != null) {
      await _box.put(key, character);
      return key;
    } else {
      final newKey = await _box.add(character);
      return newKey;
    }
  }

  @override
  Future<void> delete(dynamic key) async => _box.delete(key);

  @override
  Future<void> reorder(int oldIndex, int newIndex) async {
    final items = _box.values.toList();
    if (oldIndex < 0 ||
        oldIndex >= items.length ||
        newIndex < 0 ||
        newIndex >= items.length) {
      return;
    }
    final updated = List<Character>.from(items);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    await _box.clear();
    await _box.addAll(updated);
  }

  @override
  Future<void> clear() async => _box.clear();
}
