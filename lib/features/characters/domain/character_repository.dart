import 'package:characterbook/features/characters/domain/character_model.dart';

abstract class CharacterRepository {
  Stream<List<Character>> watchAll();
  Future<List<Character>> getAll();
  Future<dynamic> save(Character character, {dynamic key});
  Future<void> delete(dynamic key);
  Future<void> reorder(int oldIndex, int newIndex);
  Future<void> clear();
}
