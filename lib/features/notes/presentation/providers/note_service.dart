import 'package:characterbook/features/notes/domain/note_model.dart';
import 'package:characterbook/features/notes/domain/note_repository.dart';
import 'package:flutter/foundation.dart';

class NoteService extends ChangeNotifier {
  final NoteRepository _repository;

  NoteService(this._repository);

  Future<void> saveNote(Note note) async {
    await _repository.save(note);
    notifyListeners();
  }

  Future<void> deleteNote(Note note) async {
    await _repository.delete(note.id);
    notifyListeners();
  }

  Future<List<Note>> getAllNotes() => _repository.getAll();

  Future<List<Note>> getNotesForCharacter(String characterId) =>
      _repository.getNotesForCharacter(characterId);
}
