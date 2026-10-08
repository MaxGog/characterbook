import 'package:characterbook/data/models/note_model.dart';
import 'package:characterbook/data/repositories/note_repository.dart';
import 'package:flutter/foundation.dart';

class NoteService extends ChangeNotifier {
  final NoteRepository _repository;

  NoteService(this._repository);

  Future<dynamic> saveNote(Note note, {dynamic key}) async {
    final result = await _repository.save(note, key: key);
    notifyListeners();
    return result;
  }

  Future<void> deleteNote(Note note) async {
    await _repository.delete(note.key);
    notifyListeners();
  }

  Future<List<Note>> getAllNotes() => _repository.getAll();

  Future<List<Note>> getNotesForCharacter(String characterId) =>
      _repository.getNotesForCharacter(characterId);

}
