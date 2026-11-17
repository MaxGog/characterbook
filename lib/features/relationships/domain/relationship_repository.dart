import 'package:characterbook/features/relationships/domain/relationship_model.dart';

abstract class RelationshipRepository {
  Stream<List<Relationship>> watchAll();
  Future<List<Relationship>> getAll();
  Future<Relationship?> getById(String id);
  Future<void> save(Relationship relationship);
  Future<void> delete(String id);
  Future<void> deleteForCharacter(String characterId);
  Future<void> clear();
}
