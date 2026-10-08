import 'dart:convert';
import 'dart:io';
import 'package:characterbook/data/models/character_model.dart';
import 'package:characterbook/data/models/template_model.dart';
import 'package:characterbook/data/repositories/template_repository.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class TemplateService extends ChangeNotifier {
  final TemplateRepository _repository;

  TemplateService(this._repository);

  Future<void> initializeDefaultTemplates() =>
      _repository.initializeDefaultTemplates();

  Future<void> saveTemplate(QuestionnaireTemplate template) async {
    await _repository.save(template);
    notifyListeners();
  }

  Future<void> deleteTemplate(String name) async {
    await _repository.delete(name);
    notifyListeners();
  }

  Future<List<QuestionnaireTemplate>> getAllTemplates() => _repository.getAll();

  Future<File> exportTemplate(QuestionnaireTemplate template) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${template.name}.chax');
    await file.writeAsString(jsonEncode(template.toJson()));
    return file;
  }

  Future<QuestionnaireTemplate> importTemplate(File file) async {
    final content = await file.readAsString();
    final json = jsonDecode(content);
    return QuestionnaireTemplate.fromJson(json);
  }

  QuestionnaireTemplate createTemplateFromCharacter(
    String name,
    Character character,
    List<String> includedStandardFields,
  ) {
    return QuestionnaireTemplate(
      name: name,
      standardFields: includedStandardFields,
      customFields: character.customFields.map((f) => f.copyWith()).toList(),
    );
  }

  Future<QuestionnaireTemplate?> pickAndImportTemplate() async {
    try {
      return await FilePickerService().importTemplate();
    } catch (e) {
      throw Exception('Ошибка импорта шаблона: ${e.toString()}');
    }
  }

}
