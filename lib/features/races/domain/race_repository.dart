import 'package:characterbook/features/races/domain/race_model.dart';

abstract class RaceRepository {
  Stream<List<Race>> watchAll();
  Future<List<Race>> getAll();
  Future<Race?> getById(String id);
  Future<Race?> getByKey(dynamic key);
  Future<dynamic> save(Race race, {dynamic key});
  Future<void> delete(dynamic key);
  Future<void> reorder(int oldIndex, int newIndex);
  Future<void> clear();
}
