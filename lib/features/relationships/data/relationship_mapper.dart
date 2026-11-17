import 'package:characterbook/features/relationships/domain/relationship_model.dart';
import 'package:characterbook/features/relationships/data/relationship_record.dart';

class RelationshipMapper {
  const RelationshipMapper();

  Relationship toDomain(RelationshipRecord record) => Relationship(
        id: record.id,
        character1Id: record.character1Id,
        character2Id: record.character2Id,
        name: record.name,
        description: record.description,
        created: record.created,
        lastEdited: record.lastEdited,
        type: record.type,
        directed: record.directed,
      );

  RelationshipRecord toRecord(Relationship relationship) => RelationshipRecord(
        id: relationship.id,
        character1Id: relationship.character1Id,
        character2Id: relationship.character2Id,
        name: relationship.name,
        description: relationship.description,
        created: relationship.created,
        lastEdited: relationship.lastEdited,
        type: relationship.type,
        directed: relationship.directed,
      );
}
