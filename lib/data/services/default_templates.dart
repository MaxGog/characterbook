import 'package:characterbook/data/models/template_model.dart';
import 'package:characterbook/data/models/custom_field_model.dart';

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

QuestionnaireTemplate getRPGExtendedTemplate() {
  return QuestionnaireTemplate(
    name: 'Расширенный ролевой шаблон',
    standardFields: ['name', 'age', 'gender', 'race'],
    customFields: [
      CustomField('Биография', ''),
      CustomField('Характер', ''),
      CustomField('Внешность', ''),
      CustomField('Способности', ''),
      CustomField('Слабости', ''),
      CustomField('Инвентарь', ''),
      CustomField('История', ''),
      CustomField('Цели', ''),
      CustomField('Мотивация', ''),
      CustomField('Отношения', ''),
      CustomField('Приметы', ''),
    ],
  );
}

QuestionnaireTemplate getDnDTemplate() {
  return QuestionnaireTemplate(
    name: 'Dungeons & Dragons',
    standardFields: ['name', 'age', 'gender', 'race'],
    customFields: [
      CustomField('Класс', ''),
      CustomField('Уровень', ''),
      CustomField('Сила', ''),
      CustomField('Ловкость', ''),
      CustomField('Телосложение', ''),
      CustomField('Интеллект', ''),
      CustomField('Мудрость', ''),
      CustomField('Харизма', ''),
      CustomField('Бонус мастерства', ''),
      CustomField('Класс доспеха', ''),
      CustomField('Здоровье', ''),
      CustomField('Максимальное здоровье', ''),
      CustomField('Временные здоровья', ''),
      CustomField('Скорость', ''),
      CustomField('Инвентарь', ''),
      CustomField('Заклинания', ''),
      CustomField('Умения и черты', ''),
      CustomField('Предыстория', ''),
      CustomField('Мировоззрение', ''),
      CustomField('Опыт', ''),
      CustomField('Пассивная мудрость (Внимательность)', ''),
      CustomField('Вдохновение', ''),
      CustomField('Другие умения и владения', ''),
    ],
  );
}

QuestionnaireTemplate getStorytellerTemplate() {
  return QuestionnaireTemplate(
    name: 'Шаблон для рассказчиков',
    standardFields: ['name', 'age', 'gender', 'race'],
    customFields: [
      CustomField('Роль в сюжете', ''),
      CustomField('Мотивация', ''),
      CustomField('Конфликты', ''),
      CustomField('Взаимоотношения', ''),
      CustomField('Внешность', ''),
      CustomField('Характер', ''),
      CustomField('Предыстория', ''),
      CustomField('Секреты', ''),
      CustomField('Сюжетные арки', ''),
      CustomField('Развитие персонажа', ''),
      CustomField('Ключевые моменты', ''),
      CustomField('Сеттинг', ''),
      CustomField('Темы и символы', ''),
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
    getRPGExtendedTemplate(),
    getDnDTemplate(),
    getStorytellerTemplate(),
    getMinimalTemplate(),
  ];
}