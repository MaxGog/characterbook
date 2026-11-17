import 'package:characterbook/features/characters/presentation/providers/character_service.dart';
import 'package:characterbook/features/races/presentation/providers/race_service.dart';

class MockCharacterService implements CharacterService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockRaceService implements RaceService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
