import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/core/storage/hive_box_repository.dart';
import 'package:characterbook/features/characters/domain/character_repository.dart';
import 'package:characterbook/features/characters/data/character_mapper.dart';
import 'package:characterbook/features/characters/data/character_record.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CharacterRepositoryHive
    extends HiveBoxRepository<Character, CharacterRecord>
    implements CharacterRepository {
  final Box<CharacterRecord> _box;

  CharacterRepositoryHive(Box<CharacterRecord> box)
      : _box = box,
        super(
          box: box,
          toEntity: const CharacterMapper().toDomain,
          toRecord: const CharacterMapper().toRecord,
          idOf: (character) => character.id,
          sortOrderOf: (record) => record.sortOrder,
          withSortOrder: (record, sortOrder) =>
              record.copyWithSortOrder(sortOrder),
        );

  String? resolveLegacyKey(String legacyKey) {
    if (_box.values.any((character) => character.id == legacyKey)) {
      return legacyKey;
    }
    for (final entry in _box.toMap().entries) {
      if (entry.key.toString() == legacyKey) return entry.value.id;
    }
    return null;
  }
}
