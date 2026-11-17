import 'package:characterbook/features/relationships/domain/relationship_model.dart';
import 'package:characterbook/features/relationships/domain/relationship_repository.dart';
import 'package:flutter/foundation.dart';

class RelationshipService extends ChangeNotifier {
  final RelationshipRepository _repository;

  RelationshipService(this._repository);

  Future<void> saveRelationship(Relationship relationship) async {
    await _repository.save(relationship);
    notifyListeners();
  }

  Future<void> deleteRelationship(Relationship relationship) async {
    await _repository.delete(relationship.id);
    notifyListeners();
  }

  Future<List<Relationship>> getAllRelationships() => _repository.getAll();

  Future<Relationship?> getRelationshipById(String id) =>
      _repository.getById(id);

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
    await _repository.deleteForCharacter(characterId);
    notifyListeners();
  }

  Stream<List<Relationship>> watchAll() => _repository.watchAll();
}
