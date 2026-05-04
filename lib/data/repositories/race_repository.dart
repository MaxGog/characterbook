import 'package:characterbook/data/models/race_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

class RaceRepositoryHive implements RaceRepository {
  final Box<Race> _box;

  RaceRepositoryHive(this._box);

  @override
  Stream<List<Race>> watchAll() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList());
  }

  @override
  Future<List<Race>> getAll() async => _box.values.toList();

  @override
  Future<Race?> getById(String id) async =>
      _box.values.firstWhere((r) => r.id == id);

  @override
  Future<Race?> getByKey(dynamic key) async => _box.get(key);

  @override
  Future<dynamic> save(Race race, {dynamic key}) async {
    if (key != null) {
      await _box.put(key, race);
      return key;
    } else {
      return await _box.add(race);
    }
  }

  @override
  Future<void> delete(dynamic key) async => _box.delete(key);

  @override
  Future<void> reorder(int oldIndex, int newIndex) async {
    final items = _box.values.toList();
    if (oldIndex < 0 ||
        oldIndex >= items.length ||
        newIndex < 0 ||
        newIndex >= items.length) return;
    final updated = List<Race>.from(items);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    await _box.clear();
    await _box.addAll(updated);
  }

  @override
  Future<void> clear() async => _box.clear();
  
}
