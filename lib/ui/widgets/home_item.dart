import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/race_model.dart';

sealed class HomeItem {
  const HomeItem();
}

final class CharacterHomeItem extends HomeItem {
  final Character character;
  const CharacterHomeItem(this.character);
}

final class RaceHomeItem extends HomeItem {
  final Race race;
  const RaceHomeItem(this.race);
}
