import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/data/repositories/hive_box_repository.dart';
import 'package:characterbook/features/characters/domain/character_repository.dart';

class CharacterRepositoryHive extends HiveBoxRepository<Character>
    implements CharacterRepository {
  CharacterRepositoryHive(super.box);
}
