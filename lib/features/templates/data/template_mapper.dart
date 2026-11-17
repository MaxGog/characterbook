import 'package:characterbook/features/templates/domain/template_model.dart';
import 'package:characterbook/features/templates/data/template_record.dart';
import 'package:characterbook/features/characters/data/character_record.dart';
import 'package:characterbook/features/characters/domain/custom_field_model.dart';

class TemplateMapper {
  const TemplateMapper();

  QuestionnaireTemplate toDomain(TemplateRecord record) =>
      QuestionnaireTemplate(
        name: record.name,
        standardFields: record.standardFields,
        customFields: record.customFields
            .map((field) => CustomField(field.key, field.value))
            .toList(),
      );

  TemplateRecord toRecord(
    QuestionnaireTemplate template, {
    int? sortOrder,
  }) =>
      TemplateRecord(
        name: template.name,
        standardFields: template.standardFields,
        customFields: template.customFields
            .map((field) =>
                CustomFieldRecord(key: field.key, value: field.value))
            .toList(),
        sortOrder: sortOrder,
      );
}
