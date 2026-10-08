import 'package:characterbook/data/models/character_model.dart';
import 'package:characterbook/data/models/note_model.dart';
import 'package:characterbook/data/models/race_model.dart';
import 'package:characterbook/data/models/relationship_model.dart';
import 'package:characterbook/data/models/template_model.dart';
import 'package:characterbook/data/repositories/character_repository.dart';
import 'package:characterbook/data/repositories/note_repository.dart';
import 'package:characterbook/data/repositories/race_repository.dart';
import 'package:characterbook/data/repositories/relationship_repository.dart';
import 'package:characterbook/data/repositories/template_repository.dart';

import '../domain/backup_repository.dart';

class RepositoryBackupRepository implements BackupRepository {
  final CharacterRepository _characterRepository;
  final NoteRepository _noteRepository;
  final RaceRepository _raceRepository;
  final TemplateRepository _templateRepository;
  final RelationshipRepository _relationshipRepository;

  RepositoryBackupRepository({
    required CharacterRepository characterRepository,
    required NoteRepository noteRepository,
    required RaceRepository raceRepository,
    required TemplateRepository templateRepository,
    required RelationshipRepository relationshipRepository,
  })  : _characterRepository = characterRepository,
        _noteRepository = noteRepository,
        _raceRepository = raceRepository,
        _templateRepository = templateRepository,
        _relationshipRepository = relationshipRepository;

  @override
  Future<Map<String, dynamic>> createBackup() async => {
        'characters': (await _characterRepository.getAll())
            .map((item) => item.toJson())
            .toList(),
        'notes': (await _noteRepository.getAll())
            .map((item) => item.toJson())
            .toList(),
        'races': (await _raceRepository.getAll())
            .map((item) => item.toJson())
            .toList(),
        'templates': (await _templateRepository.getAll())
            .map((item) => item.toJson())
            .toList(),
        'relationships': (await _relationshipRepository.getAll())
            .map((item) => item.toJson())
            .toList(),
      };

  @override
  Future<void> restoreBackup(Map<String, dynamic> data) async {
    final hasKnownData = const [
      'characters',
      'notes',
      'races',
      'templates',
      'relationships',
    ].any(data.containsKey);
    if (!hasKnownData) {
      throw const FormatException('The backup does not contain known data.');
    }

    final characters = _decodeItems(data['characters'], Character.fromJson);
    final notes = _decodeItems(data['notes'], Note.fromJson);
    final races = _decodeItems(data['races'], Race.fromJson);
    final templates =
        _decodeItems(data['templates'], QuestionnaireTemplate.fromJson);
    final relationships =
        _decodeItems(data['relationships'], Relationship.fromJson);

    await Future.wait([
      _characterRepository.clear(),
      _noteRepository.clear(),
      _raceRepository.clear(),
      _templateRepository.clear(),
      _relationshipRepository.clear(),
    ]);

    for (final item in characters) {
      await _characterRepository.save(item);
    }
    for (final item in notes) {
      await _noteRepository.save(item);
    }
    for (final item in races) {
      await _raceRepository.save(item);
    }
    for (final item in templates) {
      await _templateRepository.save(item);
    }
    for (final item in relationships) {
      await _relationshipRepository.save(item);
    }
  }

  List<T> _decodeItems<T>(
    dynamic rawItems,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (rawItems == null) return [];
    if (rawItems is! List) {
      throw const FormatException('A backup data section must be a list.');
    }

    final items = <T>[];
    for (final rawItem in rawItems) {
      if (rawItem is! Map<String, dynamic>) {
        throw const FormatException('A backup item must be a JSON object.');
      }
      items.add(fromJson(rawItem));
    }
    return items;
  }
}
