import 'dart:math';

import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/features/characters/domain/character_repository.dart';
import 'package:characterbook/features/relationships/domain/relationship_repository.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/foundation.dart';

class CharacterService extends ChangeNotifier {
  final CharacterRepository _repository;
  final RelationshipRepository _relationshipRepository;

  CharacterService(this._repository, this._relationshipRepository);

  Future<void> saveCharacter(Character character) async {
    await _repository.save(character);
    notifyListeners();
  }

  Future<void> deleteCharacter(Character character) async {
    await _relationshipRepository.deleteForCharacter(character.id);
    await _repository.delete(character.id);
    notifyListeners();
  }

  Future<List<Character>> getAllCharacters() => _repository.getAll();

  Future<Character?> getCharacterById(String id) => _repository.getById(id);

  Future<List<Character>> getCharactersByRaceId(String raceId) async {
    final all = await _repository.getAll();
    return all.where((character) => character.race?.id == raceId).toList();
  }

  Future<Character> duplicateCharacter(Character character) async {
    try {
      final duplicated = character.copyWith(
        id: _generateUniqueId(),
        name: '${character.name} (${S.current.copy})',
      );
      await _repository.save(duplicated);
      return duplicated;
    } catch (error) {
      throw Exception('${S.current.duplicate_error}: $error');
    }
  }

  String _generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = Random().nextInt(1000000);
    return '${timestamp}_$randomNum';
  }
}
