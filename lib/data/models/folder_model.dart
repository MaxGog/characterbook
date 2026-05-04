import 'dart:ui';

import 'package:hive/hive.dart';

part 'folder_model.g.dart';

@HiveType(typeId: 5)
class Folder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  FolderType type;

  @HiveField(3)
  String? parentId;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6, defaultValue: [])
  List<String> contentIds;

  @HiveField(7)
  int colorValue;

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