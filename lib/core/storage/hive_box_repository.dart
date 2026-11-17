import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxRepository<T, R> {
  final Box<R> _box;
  final T Function(R record) _toEntity;
  final R Function(T entity) _toRecord;
  final String Function(T entity) _idOf;
  final int? Function(R record) _sortOrderOf;
  final R Function(R record, int sortOrder) _withSortOrder;

  HiveBoxRepository({
    required Box<R> box,
    required T Function(R record) toEntity,
    required R Function(T entity) toRecord,
    required String Function(T entity) idOf,
    required int? Function(R record) sortOrderOf,
    required R Function(R record, int sortOrder) withSortOrder,
  })  : _box = box,
        _toEntity = toEntity,
        _toRecord = toRecord,
        _idOf = idOf,
        _sortOrderOf = sortOrderOf,
        _withSortOrder = withSortOrder;

  Stream<List<T>> watchAll() async* {
    yield await getAll();
    yield* _box.watch().asyncMap((_) => getAll());
  }

  Future<List<T>> getAll() async =>
      _orderedEntries().map((entry) => _toEntity(entry.value)).toList(
            growable: false,
          );

  Future<T?> getById(String id) async {
    final entry = _entryForId(id);
    return entry == null ? null : _toEntity(entry.value);
  }

  Future<void> save(T item) async {
    final entry = _entryForId(_idOf(item));
    var record = _toRecord(item);
    final orderedEntries = _orderedEntries();
    final existingIndex = entry == null
        ? -1
        : orderedEntries.indexWhere((candidate) => candidate.key == entry.key);
    final sortOrder = entry == null
        ? orderedEntries.length
        : _sortOrderOf(entry.value) ?? existingIndex;
    record = _withSortOrder(record, sortOrder);
    if (entry == null) {
      await _box.add(record);
    } else {
      await _box.put(entry.key, record);
    }
  }

  Future<void> delete(String id) async {
    final entry = _entryForId(id);
    if (entry != null) {
      await _box.delete(entry.key);
    }
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final entries = _orderedEntries();
    if (oldIndex < 0 ||
        oldIndex >= entries.length ||
        newIndex < 0 ||
        newIndex >= entries.length ||
        oldIndex == newIndex) {
      return;
    }

    final updated = List<MapEntry<dynamic, R>>.of(entries);
    final entry = updated.removeAt(oldIndex);
    updated.insert(newIndex, entry);
    for (var index = 0; index < updated.length; index++) {
      final entry = updated[index];
      final record = _withSortOrder(entry.value, index);
      await _box.put(entry.key, record);
    }
  }

  Future<void> clear() async => _box.clear();

  MapEntry<dynamic, R>? _entryForId(String id) {
    for (final entry in _box.toMap().entries) {
      if (_idOf(_toEntity(entry.value)) == id) return entry;
    }
    return null;
  }

  List<MapEntry<dynamic, R>> _orderedEntries() {
    final indexedEntries = _box.toMap().entries.toList().asMap().entries;
    final entries = indexedEntries.toList()
      ..sort((left, right) {
        final leftOrder = _sortOrderOf(left.value.value);
        final rightOrder = _sortOrderOf(right.value.value);
        final byOrder =
            (leftOrder ?? left.key).compareTo(rightOrder ?? right.key);
        return byOrder != 0 ? byOrder : left.key.compareTo(right.key);
      });
    return entries.map((entry) => entry.value).toList();
  }
}
