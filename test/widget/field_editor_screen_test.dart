import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/screens/field_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrapWithMaterialApp(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: child,
  );
}

void main() {
  testWidgets('FieldEditorScreen returns trimmed values and autosaves',
      (tester) async {
    final savedResults = <FieldEditorResult>[];
    Future<FieldEditorResult?>? resultFuture;

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                resultFuture = Navigator.of(context).push<FieldEditorResult>(
                  MaterialPageRoute(
                    builder: (_) => FieldEditorScreen(
                      title: 'Field',
                      initialKey: 'Original key',
                      initialValue: 'Original value',
                      isTitleEditable: true,
                      onAutoSave: savedResults.add,
                    ),
                  ),
                );
              },
              child: const Text('Open field'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open field'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.first, ' Updated key ');
    await tester.enterText(fields.last, ' Updated value ');
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    final result = await resultFuture!;
    expect(result?.key, 'Updated key');
    expect(result?.value, 'Updated value');
    expect(savedResults.last.key, 'Updated key');
    expect(savedResults.last.value, 'Updated value');
  });

  testWidgets('FieldEditorScreen debounces autosave', (tester) async {
    final savedResults = <FieldEditorResult>[];

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        FieldEditorScreen(
          title: 'Field',
          initialKey: 'Name',
          initialValue: '',
          onAutoSave: savedResults.add,
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), ' Updated value ');
    await tester.pump(const Duration(milliseconds: 499));
    expect(savedResults, isEmpty);

    await tester.pump(const Duration(milliseconds: 1));
    expect(savedResults, hasLength(1));
    expect(savedResults.single.key, 'Name');
    expect(savedResults.single.value, 'Updated value');
  });
}
