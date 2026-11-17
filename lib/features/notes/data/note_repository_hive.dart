import 'package:characterbook/features/notes/domain/note_model.dart';
import 'package:characterbook/data/repositories/hive_box_repository.dart';
import 'package:characterbook/features/notes/domain/note_repository.dart';

class NoteRepositoryHive extends HiveBoxRepository<Note>
    implements NoteRepository {
  NoteRepositoryHive(super.box);

  @override
  Future<Note?> getById(dynamic key) async => super.findByKey(key);

  @override
  Future<List<Note>> getNotesForCharacter(String characterId) async =>
      (await getAll())
          .where((note) => note.characterIds.contains(characterId))
          .toList();
}
