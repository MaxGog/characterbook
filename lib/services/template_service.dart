import 'dart:convert';
import 'dart:io';
import 'package:characterbook/services/default_templates.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/character_model.dart';
import '../models/template_model.dart';
import 'file_picker_service.dart';

class TemplateService {
  static const String _templatesBoxName = 'templates';
  static const String _fileExtension = '.chax';
  static bool _isInitialized = false;

  Future<void> initializeDefaultTemplates() async {
    final box = await _openTemplatesBox();
    if (!_isInitialized) {
      await _initializeDefaultTemplates(box);
      _isInitialized = true;
    }
  }

  Future<Box<QuestionnaireTemplate>> _openTemplatesBox() async {
    final box = await Hive.openBox<QuestionnaireTemplate>(_templatesBoxName);
    
    if (!_isInitialized && box.isEmpty) {
      await _initializeDefaultTemplates(box);
      _isInitialized = true;
    }
    
    return box;
  }

  Future<void> _initializeDefaultTemplates(Box<QuestionnaireTemplate> box) async {
    final defaultTemplates = getDefaultTemplates();
    for (final template in defaultTemplates) {
      await box.put(template.name, template);
    }
  }

  Future<void> saveTemplate(QuestionnaireTemplate template) async {
    final box = await _openTemplatesBox();
    await box.put(template.name, template);
  }

  Future<List<QuestionnaireTemplate>> getAllTemplates() async {
    final box = await _openTemplatesBox();
    return box.values.toList();
  }

  Future<void> deleteTemplate(String name) async {
    final box = await _openTemplatesBox();
    await box.delete(name);
  }

  Future<File> exportTemplate(QuestionnaireTemplate template) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${template.name}$_fileExtension');
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