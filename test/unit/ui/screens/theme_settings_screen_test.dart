import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/features/settings/data/theme_provider.dart';
import 'package:characterbook/features/settings/domain/settings_actions.dart';
import 'package:characterbook/features/settings/presentation/theme_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Theme settings screen builds', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ListenableProxyProvider<ThemeProvider, ThemeSettingsActions>(
            update: (_, settings, __) => settings,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const ThemeSettingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(ThemeSettingsScreen), findsOneWidget);
  });
}
