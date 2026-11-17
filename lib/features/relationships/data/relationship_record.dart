import 'package:hive/hive.dart';

part 'relationship_record.g.dart';

@HiveType(typeId: 12)
class RelationshipRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String character1Id;

  @HiveField(2)
  final String character2Id;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final DateTime created;

  @HiveField(6)
  final DateTime lastEdited;

  @HiveField(7)
  final String? type;

  @HiveField(8)
  final bool directed;

  @HiveField(9)
  final int? sortOrder;

  RelationshipRecord({
    required this.id,
    required this.character1Id,
    required this.character2Id,
    required this.name,
    required this.description,
    required this.created,
    required this.lastEdited,
    required this.type,
    required this.directed,
    this.sortOrder,
  });

  RelationshipRecord copyWithSortOrder(int sortOrder) => RelationshipRecord(
        id: id,
        character1Id: character1Id,
        character2Id: character2Id,
        name: name,
        description: description,
        created: created,
        lastEdited: lastEdited,
        type: type,
        directed: directed,
        sortOrder: sortOrder,
      );
}
