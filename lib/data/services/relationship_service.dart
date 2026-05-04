import 'package:characterbook/data/models/relationship_model.dart';
import 'package:characterbook/data/repositories/relationship_repository.dart';
import 'package:collection/collection.dart';

class RelationshipService {
  final RelationshipRepository _repository;

  RelationshipService(this._repository);

  Future<dynamic> saveRelationship(Relationship relationship, {dynamic key}) =>
      _repository.save(relationship, key: key);

  Future<void> deleteRelationship(Relationship relationship) =>
      _repository.delete(relationship.key);

  Future<List<Relationship>> getAllRelationships() => _repository.getAll();

  Future<Relationship?> getRelationshipByKey(int key) async {
    final all = await _repository.getAll();
    return all.firstWhereOrNull((r) => r.key == key);
  }

  Future<List<Relationship>> getRelationshipsForCharacter(
      String characterId) async {
    final all = await _repository.getAll();
    return all
        .where((r) =>
            r.character1Id == characterId || r.character2Id == characterId)
        .toList();
  }

  Future<bool> relationshipExists(String char1Id, String char2Id) async {
    final all = await _repository.getAll();
    return all.any((r) =>
        (r.character1Id == char1Id && r.character2Id == char2Id) ||
        (!r.directed &&
            r.character1Id == char2Id &&
            r.character2Id == char1Id));
  }

  Future<void> deleteRelationshipsForCharacter(String characterId) async {
    final relations = await getRelationshipsForCharacter(characterId);
    for (final rel in relations) {
      await deleteRelationship(rel);
    }
  }

  Stream<List<Relationship>> watchAll() => _repository.watchAll();
}
