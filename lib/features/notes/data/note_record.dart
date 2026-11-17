import 'package:hive/hive.dart';

part 'note_record.g.dart';

@HiveType(typeId: 2)
class NoteRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5, defaultValue: [])
  final List<String> characterIds;

  @HiveField(6)
  final List<String> tags;

  @HiveField(7)
  final String? folderId;

  @HiveField(8)
  final int? sortOrder;

  NoteRecord({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.characterIds,
    required this.tags,
    required this.folderId,
    this.sortOrder,
  });

  NoteRecord copyWithSortOrder(int sortOrder) => NoteRecord(
        id: id,
        title: title,
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
        characterIds: characterIds,
        tags: tags,
        folderId: folderId,
        sortOrder: sortOrder,
      );
}
