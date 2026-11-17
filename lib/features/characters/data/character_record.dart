import 'dart:typed_data';

import 'package:characterbook/features/races/data/race_record.dart';
import 'package:hive/hive.dart';

part 'character_record.g.dart';

@HiveType(typeId: 1)
class CustomFieldRecord {
  @HiveField(0)
  final String key;

  @HiveField(1)
  final String value;

  const CustomFieldRecord({required this.key, required this.value});
}

@HiveType(typeId: 0)
class CharacterRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final String biography;

  @HiveField(5)
  final String personality;

  @HiveField(6)
  final String appearance;

  @HiveField(7)
  final Uint8List? imageBytes;

  @HiveField(8)
  final String abilities;

  @HiveField(9)
  final String other;

  @HiveField(10)
  final Uint8List? referenceImageBytes;

  @HiveField(11)
  final List<CustomFieldRecord> customFields;

  @HiveField(12)
  final List<Uint8List> additionalImages;

  @HiveField(13)
  final DateTime lastEdited;

  @HiveField(14)
  final RaceRecord? race;

  @HiveField(15)
  final String? folderId;

  @HiveField(16, defaultValue: [])
  final List<String> tags;

  @HiveField(17)
  final int? sortOrder;

  CharacterRecord({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.biography,
    required this.personality,
    required this.appearance,
    required this.imageBytes,
    required this.abilities,
    required this.other,
    required this.referenceImageBytes,
    required this.customFields,
    required this.additionalImages,
    required this.lastEdited,
    required this.race,
    required this.folderId,
    required this.tags,
    this.sortOrder,
  });

  CharacterRecord copyWithSortOrder(int sortOrder) => CharacterRecord(
        id: id,
        name: name,
        age: age,
        gender: gender,
        biography: biography,
        personality: personality,
        appearance: appearance,
        imageBytes: imageBytes,
        abilities: abilities,
        other: other,
        referenceImageBytes: referenceImageBytes,
        customFields: customFields,
        additionalImages: additionalImages,
        lastEdited: lastEdited,
        race: race,
        folderId: folderId,
        tags: tags,
        sortOrder: sortOrder,
      );
}
