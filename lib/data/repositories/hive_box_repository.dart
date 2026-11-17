import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxRepository<T> {
  final Box<T> _box;

  HiveBoxRepository(Box<T> box) : _box = box;

  Stream<List<T>> watchAll() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList());
  }

  Future<List<T>> getAll() async => _box.values.toList();

  T? findByKey(dynamic key) => _box.get(key);

  Future<dynamic> save(T item, {dynamic key}) async {
    if (key == null) {
      return _box.add(item);
    }

    await _box.put(key, item);
    return key;
  }

  Future<void> delete(dynamic key) async => _box.delete(key);

  Future<void> reorder(int oldIndex, int newIndex) async {
    final items = _box.values.toList();
    if (oldIndex < 0 ||
        oldIndex >= items.length ||
        newIndex < 0 ||
        newIndex >= items.length) {
      return;
    }

    final updated = List<T>.from(items);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    await _box.clear();
    await _box.addAll(updated);
  }

  Future<void> clear() async => _box.clear();
}
