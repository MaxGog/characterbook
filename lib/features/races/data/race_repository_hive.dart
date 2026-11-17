import 'package:characterbook/features/races/domain/race_model.dart';
import 'package:characterbook/data/repositories/hive_box_repository.dart';
import 'package:characterbook/features/races/domain/race_repository.dart';
import 'package:collection/collection.dart';

class RaceRepositoryHive extends HiveBoxRepository<Race>
    implements RaceRepository {
  RaceRepositoryHive(super.box);

  @override
  Future<Race?> getById(String id) async =>
      (await getAll()).firstWhereOrNull((race) => race.id == id);

  @override
  Future<Race?> getByKey(dynamic key) async => super.findByKey(key);
}
