import 'package:characterbook/features/templates/domain/template_model.dart';
import 'package:characterbook/features/templates/domain/template_repository.dart';
import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/features/templates/domain/template_import_actions.dart';

class TemplateService {
  final TemplateRepository _repository;
  final TemplateImportActions _importActions;

  TemplateService(this._repository, this._importActions);

  Future<void> initializeDefaultTemplates() =>
      _repository.initializeDefaultTemplates();

  Future<void> saveTemplate(QuestionnaireTemplate template) =>
      _repository.save(template);

  Future<void> deleteTemplate(String name) => _repository.delete(name);

  Future<List<QuestionnaireTemplate>> getAllTemplates() =>
      _repository.getAll();

  QuestionnaireTemplate createTemplateFromCharacter(
    String name,
    Character character,
    List<String> includedStandardFields,
  ) =>
      QuestionnaireTemplate(
        name: name,
        standardFields: includedStandardFields,
        customFields: character.customFields.map((field) => field.copyWith()).toList(),
      );

  Future<QuestionnaireTemplate?> pickAndImportTemplate() =>
      _importActions.pickAndImportTemplate();
}
