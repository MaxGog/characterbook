import 'package:characterbook/features/characters/domain/custom_field_model.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/widgets/fields/custom_fields_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomFieldsEditor updates values without replacing inputs',
      (tester) async {
    List<CustomField>? updatedFields;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: CustomFieldsEditor(
            initialFields: [CustomField('', '')],
            verticalLayout: true,
            onFieldsChanged: (fields) => updatedFields = fields,
          ),
        ),
      ),
    );

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(2));
    final firstInputState =
        tester.state<EditableTextState>(find.byType(EditableText).first);

    await tester.enterText(fields.first, 'Field name');
    await tester.pump();
    expect(
      tester.state<EditableTextState>(find.byType(EditableText).first),
      same(firstInputState),
    );

    await tester.enterText(fields.last, 'Field value');
    await tester.pump();

    expect(updatedFields, [CustomField('Field name', 'Field value')]);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
