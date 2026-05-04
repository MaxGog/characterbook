import 'package:hive/hive.dart';

part 'relationship_model.g.dart';

@HiveType(typeId: 12)
class Relationship extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String character1Id;

  @HiveField(2)
  String character2Id;

  @HiveField(3)
  String name;

  @HiveField(4)
  String description;

  @HiveField(5)
  DateTime created;

  @HiveField(6)
  DateTime lastEdited;

  @HiveField(7)
  String? type;

  @HiveField(8)
  bool directed;

  Relationship({
    String? id,
    required this.character1Id,
    required this.character2Id,
    this.name = '',
    this.description = '',
    DateTime? created,
    DateTime? lastEdited,
    this.type,
    this.directed = false,
  })  : id = id ?? _generateUniqueId(),
        created = created ?? DateTime.now(),
        lastEdited = lastEdited ?? DateTime.now();

  static String _generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    return 'rel_${timestamp}_$random';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Relationship &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  void updateLastEdited() {
    lastEdited = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'character1Id': character1Id,
      'character2Id': character2Id,
      'name': name,
      'description': description,
      'created': created.toIso8601String(),
      'lastEdited': lastEdited.toIso8601String(),
      'type': type,
      'directed': directed,
    };
  }

  factory Relationship.fromJson(Map<String, dynamic> json) {
    return Relationship(
      id: json['id'],
      character1Id: json['character1Id'],
      character2Id: json['character2Id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      created: DateTime.parse(json['created']),
      lastEdited: DateTime.parse(json['lastEdited']),
      type: json['type'],
      directed: json['directed'] ?? false,
    );
  }

  Relationship copyWith({
    String? character1Id,
    String? character2Id,
    String? name,
    String? description,
    String? type,
    bool? directed,
  }) {
    return Relationship(
      id: id,
      character1Id: character1Id ?? this.character1Id,
      character2Id: character2Id ?? this.character2Id,
      name: name ?? this.name,
      description: description ?? this.description,
      created: created,
      lastEdited: DateTime.now(),
      type: type ?? this.type,
      directed: directed ?? this.directed,
    );
  }
}
