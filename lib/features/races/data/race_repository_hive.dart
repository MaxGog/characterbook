import 'package:characterbook/features/races/domain/race_model.dart';
import 'package:characterbook/core/storage/hive_box_repository.dart';
import 'package:characterbook/features/races/domain/race_repository.dart';
import 'package:characterbook/features/races/data/race_mapper.dart';
import 'package:characterbook/features/races/data/race_record.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RaceRepositoryHive extends HiveBoxRepository<Race, RaceRecord>
    implements RaceRepository {
  RaceRepositoryHive(Box<RaceRecord> box)
      : super(
          box: box,
          toEntity: const RaceMapper().toDomain,
          toRecord: const RaceMapper().toRecord,
          idOf: (race) => race.id,
          sortOrderOf: (record) => record.sortOrder,
          withSortOrder: (record, sortOrder) =>
              record.copyWithSortOrder(sortOrder),
        );

  @override
  Future<Race?> getById(String id) => super.getById(id);
}
