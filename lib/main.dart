import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/handlers/file_handler.dart';
import 'package:characterbook/handlers/file_handler_wrapper.dart';
import 'package:characterbook/providers/locale_provider.dart';
import 'package:characterbook/providers/theme_provider.dart';
import 'package:characterbook/services/initialization_service.dart';
import 'package:characterbook/services/notification_service.dart';
import 'package:characterbook/ui/pages/app_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool hiveInitialized = false;
  try {
    hiveInitialized = await InitializationService.initializeHive();
  } catch (error) {
    debugPrint('Critical initialization error: $error');
  }

  await FileHandler.initialize();

  runApp(CharacterBookApp(hiveInitialized: hiveInitialized));
}

class CharacterBookApp extends StatelessWidget {
  final bool hiveInitialized;

  const CharacterBookApp({super.key, required this.hiveInitialized});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        Provider<NotificationService>(
          create: (_) =>
              NotificationService(GlobalKey<ScaffoldMessengerState>()),
        ),
      ],
      child: _AppContent(hiveInitialized: hiveInitialized),
    );
  }
}

class _AppContent extends StatefulWidget {
  final bool hiveInitialized;

  const _AppContent({required this.hiveInitialized});

  @override
  State<_AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<_AppContent> {
  bool _showErrorDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitializationStatus();
    });
  }

  void _checkInitializationStatus() {
    if (!widget.hiveInitialized && !_showErrorDialog) {
      setState(() {
        _showErrorDialog = true;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(S.of(context).initialization_error),
          content: Text(S.of(context).initialization_error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _showErrorDialog = false;
                });
              },
              child: Text(S.of(context).ok),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, LocaleProvider, NotificationService>(
      builder:
          (context, themeProvider, localeProvider, notificationService, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: notificationService.messengerKey,
          title: 'CharacterBook',
          locale: localeProvider.locale,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const FileHandlerWrapper(child: AppNavigationBar()),
        );
      },
    );
  }
}
