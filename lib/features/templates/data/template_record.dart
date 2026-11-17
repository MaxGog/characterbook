import 'package:characterbook/features/characters/data/character_record.dart';
import 'package:hive/hive.dart';

part 'template_record.g.dart';

@HiveType(typeId: 4)
class TemplateRecord extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<String> standardFields;

  @HiveField(2)
  final List<CustomFieldRecord> customFields;

  @HiveField(3)
  final int? sortOrder;

  TemplateRecord({
    required this.name,
    required this.standardFields,
    required this.customFields,
    this.sortOrder,
  });
}
