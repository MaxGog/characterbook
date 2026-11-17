import 'package:characterbook/features/templates/domain/template_model.dart';

abstract interface class TemplateImportActions {
  Future<QuestionnaireTemplate?> pickAndImportTemplate();
}
