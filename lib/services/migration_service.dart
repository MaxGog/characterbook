import 'package:hive/hive.dart';
import 'package:characterbook/models/characters/character_model.dart';
import 'package:characterbook/models/characters/character_universal_model.dart';

class MigrationService {
  static Future<void> migrateCharactersToUniversal() async {
    final characterBox = await Hive.openBox<Character>('characters');
    final universalBox = await Hive.openBox<CharacterUniversal>('characters_universal');
    
    if (universalBox.isNotEmpty) return;
    
    for (final character in characterBox.values) {
      final universalCharacter = CharacterUniversal.fromV1(character);
      await universalBox.add(universalCharacter);
    }
    
    print('Мигрировано ${characterBox.length} персонажей в Universal модель');
  }

  static Future<bool> shouldUseUniversal() async {
    try {
      final universalBox = await Hive.openBox<CharacterUniversal>('characters_universal');
      return universalBox.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<int> getUniversalCharactersCount() async {
    try {
      final universalBox = await Hive.openBox<CharacterUniversal>('characters_universal');
      return universalBox.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> getLegacyCharactersCount() async {
    try {
      final legacyBox = await Hive.openBox<Character>('characters');
      return legacyBox.length;
    } catch (e) {
      return 0;
    }
  }
}