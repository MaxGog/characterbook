import 'package:characterbook/features/relationships/data/relationship_record.dart';
import 'package:characterbook/core/storage/hive_box_repository.dart';
import 'package:characterbook/features/relationships/domain/relationship_repository.dart';
import 'package:characterbook/features/relationships/domain/relationship_model.dart';
import 'package:characterbook/features/relationships/data/relationship_mapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RelationshipRepositoryHive
    extends HiveBoxRepository<Relationship, RelationshipRecord>
    implements RelationshipRepository {
  RelationshipRepositoryHive(Box<RelationshipRecord> box)
      : super(
          box: box,
          toEntity: const RelationshipMapper().toDomain,
          toRecord: const RelationshipMapper().toRecord,
          idOf: (relationship) => relationship.id,
          sortOrderOf: (record) => record.sortOrder,
          withSortOrder: (record, sortOrder) =>
              record.copyWithSortOrder(sortOrder),
        );

  @override
  Future<void> deleteForCharacter(String characterId) async {
    final relationships = await getAll();
    for (final relationship in relationships.where(
      (relationship) =>
          relationship.character1Id == characterId ||
          relationship.character2Id == characterId,
    )) {
      await delete(relationship.id);
    }
  }
}
