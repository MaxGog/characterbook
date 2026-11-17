import 'package:characterbook/features/calendar/data/custom_event_record.dart';
import 'package:characterbook/features/calendar/domain/custom_event_repository.dart';
import 'package:characterbook/features/calendar/data/custom_event_mapper.dart';
import 'package:characterbook/features/calendar/domain/custom_event_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomEventRepositoryHive implements CustomEventRepository {
  final Box<CustomEventRecord> _box;
  final CustomEventMapper _mapper;

  CustomEventRepositoryHive(
    this._box, {
    CustomEventMapper mapper = const CustomEventMapper(),
  }) : _mapper = mapper;

  @override
  Stream<List<CustomEvent>> watchAll() async* {
    yield await getAll();
    yield* _box.watch().asyncMap((_) => getAll());
  }

  @override
  Future<List<CustomEvent>> getAll() async =>
      _box.values.map(_mapper.toDomain).toList(growable: false);

  @override
  Future<void> save(CustomEvent event) async =>
      _box.put(event.id, _mapper.toRecord(event));

  @override
  Future<void> delete(String id) async => _box.delete(id);

  @override
  Future<CustomEvent?> getById(String id) async {
    final record = _box.get(id);
    return record == null ? null : _mapper.toDomain(record);
  }
}
