import 'package:characterbook/features/templates/domain/template_import_actions.dart';
import 'package:characterbook/features/templates/domain/template_model.dart';

class TemplateFilePicker implements TemplateImportActions {
  final Future<QuestionnaireTemplate?> Function() _pickTemplate;

  TemplateFilePicker(this._pickTemplate);

  @override
  Future<QuestionnaireTemplate?> pickAndImportTemplate() => _pickTemplate();
}
