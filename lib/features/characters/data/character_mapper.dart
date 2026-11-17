import 'package:characterbook/features/characters/data/character_record.dart';
import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/features/characters/domain/custom_field_model.dart';
import 'package:characterbook/features/races/data/race_mapper.dart';

class CharacterMapper {
  const CharacterMapper();

  Character toDomain(CharacterRecord record) => Character(
        id: record.id,
        name: record.name,
        age: record.age,
        gender: record.gender,
        biography: record.biography,
        personality: record.personality,
        appearance: record.appearance,
        imageBytes: record.imageBytes,
        abilities: record.abilities,
        other: record.other,
        referenceImageBytes: record.referenceImageBytes,
        customFields: record.customFields
            .map((field) => CustomField(field.key, field.value))
            .toList(),
        additionalImages: record.additionalImages,
        lastEdited: record.lastEdited,
        race: record.race == null
            ? null
            : const RaceMapper().toDomain(record.race!),
        folderId: record.folderId,
        tags: record.tags,
      );

  CharacterRecord toRecord(Character character) => CharacterRecord(
        id: character.id,
        name: character.name,
        age: character.age,
        gender: character.gender,
        biography: character.biography,
        personality: character.personality,
        appearance: character.appearance,
        imageBytes: character.imageBytes,
        abilities: character.abilities,
        other: character.other,
        referenceImageBytes: character.referenceImageBytes,
        customFields: character.customFields
            .map((field) =>
                CustomFieldRecord(key: field.key, value: field.value))
            .toList(),
        additionalImages: character.additionalImages,
        lastEdited: character.lastEdited,
        race: character.race == null
            ? null
            : const RaceMapper().toRecord(character.race!),
        folderId: character.folderId,
        tags: character.tags,
      );
}
