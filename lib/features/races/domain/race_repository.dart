import 'package:characterbook/features/races/domain/race_model.dart';

abstract class RaceRepository {
  Stream<List<Race>> watchAll();
  Future<List<Race>> getAll();
  Future<Race?> getById(String id);
  Future<void> save(Race race);
  Future<void> delete(String id);
  Future<void> reorder(int oldIndex, int newIndex);
  Future<void> clear();
}
