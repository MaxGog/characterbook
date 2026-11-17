import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'race_record.g.dart';

@HiveType(typeId: 3)
class RaceRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String biology;

  @HiveField(4)
  final String backstory;

  @HiveField(5)
  final Uint8List? logo;

  @HiveField(6, defaultValue: null)
  final String? folderId;

  @HiveField(7, defaultValue: const [])
  final List<String> tags;

  @HiveField(8, defaultValue: const [])
  final List<Uint8List> additionalImages;

  @HiveField(9)
  final DateTime lastEdited;

  @HiveField(10)
  final int? sortOrder;

  RaceRecord({
    required this.id,
    required this.name,
    required this.description,
    required this.biology,
    required this.backstory,
    required this.logo,
    required this.folderId,
    required this.tags,
    required this.additionalImages,
    required this.lastEdited,
    this.sortOrder,
  });

  RaceRecord copyWithSortOrder(int sortOrder) => RaceRecord(
        id: id,
        name: name,
        description: description,
        biology: biology,
        backstory: backstory,
        logo: logo,
        folderId: folderId,
        tags: tags,
        additionalImages: additionalImages,
        lastEdited: lastEdited,
        sortOrder: sortOrder,
      );
}
