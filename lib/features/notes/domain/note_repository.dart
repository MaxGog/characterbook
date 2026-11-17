import 'package:characterbook/features/notes/domain/note_model.dart';

abstract class NoteRepository {
  Stream<List<Note>> watchAll();
  Future<List<Note>> getAll();
  Future<Note?> getById(dynamic key);
  Future<dynamic> save(Note note, {dynamic key});
  Future<void> delete(dynamic key);
  Future<List<Note>> getNotesForCharacter(String characterId);
  Future<void> reorder(int oldIndex, int newIndex);
  Future<void> clear();
}
