import 'package:characterbook/models/characters/template_model.dart';
import 'package:characterbook/models/custom_field_model.dart';

QuestionnaireTemplate getDefaultRPGTemplate() {
  return QuestionnaireTemplate(
    name: 'Ролевой шаблон по умолчанию',
    standardFields: ['name', 'age', 'gender', 'race'],
    customFields: [
      CustomField('Биография', ''),
      CustomField('Характер', ''),
      CustomField('Внешность', ''),
      CustomField('Способности', ''),
      CustomField('Инвентарь', ''),
      CustomField('История', ''),
      CustomField('Цели', ''),
      CustomField('Другое', ''),
    ],
  );
}

QuestionnaireTemplate getMinimalTemplate() {
  return QuestionnaireTemplate(
    name: 'Минимальный шаблон',
    standardFields: ['name', 'age', 'gender', 'race'],
    customFields: [
      CustomField('Описание', ''),
    ],
  );
}

List<QuestionnaireTemplate> getDefaultTemplates() {
  return [
    getDefaultRPGTemplate(),
    getMinimalTemplate(),
  ];
}