import 'package:characterbook/features/notes/domain/note_model.dart';

abstract class NoteRepository {
  Stream<List<Note>> watchAll();
  Future<List<Note>> getAll();
  Future<Note?> getById(String id);
  Future<void> save(Note note);
  Future<void> delete(String id);
  Future<List<Note>> getNotesForCharacter(String characterId);
  Future<void> reorder(int oldIndex, int newIndex);
  Future<void> clear();
}
