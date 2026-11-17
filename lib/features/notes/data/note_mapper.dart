import 'package:characterbook/features/notes/data/note_record.dart';
import 'package:characterbook/features/notes/domain/note_model.dart';

class NoteMapper {
  const NoteMapper();

  Note toDomain(NoteRecord record, {List<String>? characterIds}) => Note(
        id: record.id,
        title: record.title,
        content: record.content,
        createdAt: record.createdAt,
        updatedAt: record.updatedAt,
        characterIds: characterIds ?? record.characterIds,
        tags: record.tags,
        folderId: record.folderId,
      );

  NoteRecord toRecord(Note note, {List<String>? characterIds}) => NoteRecord(
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        characterIds: characterIds ?? note.characterIds,
        tags: note.tags,
        folderId: note.folderId,
      );
}
