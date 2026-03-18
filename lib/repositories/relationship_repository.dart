import 'package:characterbook/models/relationship_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class RelationshipRepository {
  Stream<List<Relationship>> watchAll();
  Future<List<Relationship>> getAll();
  Future<dynamic> save(Relationship relationship, {dynamic key});
  Future<void> delete(dynamic key);
  Future<void> clear();
}

class RelationshipRepositoryHive implements RelationshipRepository {
  final Box<Relationship> _box;

  RelationshipRepositoryHive(this._box);

  @override
  Stream<List<Relationship>> watchAll() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList());
  }

  @override
  Future<List<Relationship>> getAll() async => _box.values.toList();

  @override
  Future<dynamic> save(Relationship relationship, {dynamic key}) async {
    if (key != null) {
      await _box.put(key, relationship);
      return key;
    } else {
      final newKey = await _box.add(relationship);
      return newKey;
    }
  }

  @override
  Future<void> delete(dynamic key) async => _box.delete(key);

  @override
  Future<void> clear() async => _box.clear();
}
