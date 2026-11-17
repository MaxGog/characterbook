import 'package:characterbook/features/notes/domain/note_model.dart';
import 'package:characterbook/core/storage/hive_box_repository.dart';
import 'package:characterbook/features/notes/domain/note_repository.dart';
import 'package:characterbook/features/notes/data/note_mapper.dart';
import 'package:characterbook/features/notes/data/note_record.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteRepositoryHive extends HiveBoxRepository<Note, NoteRecord>
    implements NoteRepository {
  NoteRepositoryHive(
    Box<NoteRecord> box, {
    String? Function(String legacyCharacterKey)? resolveLegacyCharacterId,
  }) : super(
          box: box,
          toEntity: (record) => _toDomain(
            record,
            resolveLegacyCharacterId ?? _noLegacyId,
          ),
          toRecord: (note) => _toRecord(
            note,
            resolveLegacyCharacterId ?? _noLegacyId,
          ),
          idOf: (note) => note.id,
          sortOrderOf: (record) => record.sortOrder,
          withSortOrder: (record, sortOrder) =>
              record.copyWithSortOrder(sortOrder),
        );

  @override
  Future<Note?> getById(String id) => super.getById(id);

  @override
  Future<List<Note>> getNotesForCharacter(String characterId) async =>
      (await getAll())
          .where((note) => note.characterIds.contains(characterId))
          .toList();

  static String? _noLegacyId(String _) => null;

  static Note _toDomain(
    NoteRecord record,
    String? Function(String legacyCharacterKey) resolveLegacyCharacterId,
  ) {
    final characterIds = record.characterIds
        .map((id) => resolveLegacyCharacterId(id) ?? id)
        .toList();
    return const NoteMapper().toDomain(record, characterIds: characterIds);
  }

  static NoteRecord _toRecord(
    Note note,
    String? Function(String legacyCharacterKey) resolveLegacyCharacterId,
  ) {
    final characterIds = note.characterIds
        .map((id) => resolveLegacyCharacterId(id) ?? id)
        .toList();
    return const NoteMapper().toRecord(note, characterIds: characterIds);
  }
}
