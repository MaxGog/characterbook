import 'dart:math';

import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/data/services/relationship_service.dart';
import 'package:characterbook/features/characters/domain/character_repository.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class CharacterService extends ChangeNotifier {
  final CharacterRepository _repository;
  final RelationshipService _relationshipService;

  CharacterService(this._repository, this._relationshipService);

  Future<dynamic> saveCharacter(Character character, {int? key}) async {
    final result = await _repository.save(character, key: key);
    notifyListeners();
    return result;
  }

  Future<void> deleteCharacter(Character character) async {
    await _relationshipService.deleteRelationshipsForCharacter(character.id);
    await _repository.delete(character.key);
    notifyListeners();
  }

  Future<List<Character>> getAllCharacters() => _repository.getAll();

  Future<Character?> getCharacterByKey(int key) async {
    final all = await _repository.getAll();
    return all.firstWhereOrNull((character) => character.key == key);
  }

  Future<List<Character>> getCharactersByRaceId(String raceId) async {
    final all = await _repository.getAll();
    return all.where((character) => character.race?.id == raceId).toList();
  }

  Future<Character?> getCharacterById(String id) async {
    final all = await _repository.getAll();
    return all.firstWhereOrNull((character) => character.id == id);
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
