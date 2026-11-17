import 'package:characterbook/features/templates/domain/template_model.dart';

abstract class TemplateRepository {
  Stream<List<QuestionnaireTemplate>> watchAll();
  Future<List<QuestionnaireTemplate>> getAll();
  Future<void> save(
    QuestionnaireTemplate template, {
    String? previousName,
  });
  Future<void> delete(String name);
  Future<void> initializeDefaultTemplates();
  Future<void> reorder(int oldIndex, int newIndex);
  Future<void> clear();
}
