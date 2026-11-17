import 'package:characterbook/features/templates/data/template_record.dart';
import 'package:characterbook/features/templates/domain/template_repository.dart';
import 'package:characterbook/features/templates/domain/default_templates.dart';
import 'package:characterbook/features/templates/data/template_mapper.dart';
import 'package:characterbook/features/templates/domain/template_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TemplateRepositoryHive implements TemplateRepository {
  final Box<TemplateRecord> _box;
  final TemplateMapper _mapper;

  TemplateRepositoryHive(
    this._box, {
    TemplateMapper mapper = const TemplateMapper(),
  }) : _mapper = mapper;

  @override
  Stream<List<QuestionnaireTemplate>> watchAll() async* {
    yield await getAll();
    yield* _box.watch().asyncMap((_) => getAll());
  }

  @override
  Future<List<QuestionnaireTemplate>> getAll() async =>
      _orderedRecords().map(_mapper.toDomain).toList(growable: false);

  @override
  Future<void> save(
    QuestionnaireTemplate template, {
    String? previousName,
  }) async {
    final records = _orderedRecords();
    final existingIndex = records.indexWhere(
      (record) =>
          record.name == template.name ||
          (previousName != null && record.name == previousName),
    );
    final sortOrder = existingIndex == -1 ? records.length : existingIndex;
    if (previousName != null && previousName != template.name) {
      await _box.delete(previousName);
    }
    await _box.put(
      template.name,
      _mapper.toRecord(template, sortOrder: sortOrder),
    );
  }

  @override
  Future<void> delete(String name) async => _box.delete(name);

  @override
  Future<void> initializeDefaultTemplates() async {
    if (_box.isNotEmpty) return;
    final templates = getDefaultTemplates();
    for (var index = 0; index < templates.length; index++) {
      final template = templates[index];
      await _box.put(
        template.name,
        _mapper.toRecord(template, sortOrder: index),
      );
    }
  }

  @override
  Future<void> reorder(int oldIndex, int newIndex) async {
    final records = _orderedRecords();
    if (oldIndex < 0 ||
        oldIndex >= records.length ||
        newIndex < 0 ||
        newIndex >= records.length ||
        oldIndex == newIndex) {
      return;
    }

    final record = records.removeAt(oldIndex);
    records.insert(newIndex, record);
    for (var index = 0; index < records.length; index++) {
      final item = _mapper.toDomain(records[index]);
      await _box.put(
        item.name,
        _mapper.toRecord(item, sortOrder: index),
      );
    }
  }

  @override
  Future<void> clear() async => _box.clear();

  List<TemplateRecord> _orderedRecords() {
    final records = _box.values.toList();
    final indexedRecords = records.asMap().entries.toList()
      ..sort((left, right) {
        final byOrder = (left.value.sortOrder ?? left.key)
            .compareTo(right.value.sortOrder ?? right.key);
        return byOrder != 0 ? byOrder : left.key.compareTo(right.key);
      });
    return indexedRecords.map((entry) => entry.value).toList();
  }
}
