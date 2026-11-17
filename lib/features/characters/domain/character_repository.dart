import 'package:characterbook/features/characters/domain/character_model.dart';

abstract class CharacterRepository {
  Stream<List<Character>> watchAll();
  Future<List<Character>> getAll();
  Future<Character?> getById(String id);
  Future<void> save(Character character);
  Future<void> delete(String id);
  Future<void> reorder(int oldIndex, int newIndex);
  Future<void> clear();
}
