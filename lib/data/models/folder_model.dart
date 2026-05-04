import 'dart:ui';
import 'package:hive/hive.dart';
import '../../core/base_entity.dart';
part 'folder_model.g.dart';

@HiveType(typeId: 5)
class Folder extends HiveObject implements BaseEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final FolderType type;
  @HiveField(3)
  final String? parentId;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final DateTime updatedAt;
  @HiveField(6)
  final List<String> contentIds;
  @HiveField(7)
  final int colorValue;

  Folder({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? contentIds,
    int? colorValue,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        contentIds = contentIds ?? [],
        colorValue = colorValue ?? 0xFF6200EE;

  Color get color => Color(colorValue);

  Folder copyWith({
    String? id,
    String? name,
    FolderType? type,
    String? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? contentIds,
    int? colorValue,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contentIds: contentIds ?? this.contentIds,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toString(),
        'parentId': parentId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'contentIds': contentIds,
        'colorValue': colorValue,
      };

  factory Folder.fromJson(Map<String, dynamic> json) => Folder(
        id: json['id'],
        name: json['name'],
        type: FolderType.values.firstWhere(
          (e) => e.toString() == json['type'],
          orElse: () => FolderType.character,
        ),
        parentId: json['parentId'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        contentIds: List<String>.from(json['contentIds'] ?? []),
        colorValue: json['colorValue'] ?? 0xFF6200EE,
      );
}

@HiveType(typeId: 6)
enum FolderType {
  @HiveField(0)
  character,
  @HiveField(1)
  race,
  @HiveField(2)
  note,
  @HiveField(3)
  template,
}
