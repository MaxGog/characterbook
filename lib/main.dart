import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/handlers/file_handler.dart';
import 'package:characterbook/handlers/file_handler_wrapper.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/providers/locale_provider.dart';
import 'package:characterbook/providers/theme_provider.dart';
import 'package:characterbook/services/initialization_service.dart';
import 'package:characterbook/services/notification_service.dart';
import 'package:characterbook/ui/pages/app_navigation_bar.dart';
import 'package:characterbook/ui/pages/settings_page.dart';
import 'package:characterbook/ui/widgets/desktop/desktop_app_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Future.wait([
      InitializationService.initializeWindowManager(),
      InitializationService.initializeHive().then((success) {
      }),
    ]);
  } catch (error) {
    debugPrint('Critical initialization error: $error');
  }

  FileHandler.initialize();

  runApp(CharacterBookApp());
}

class CharacterBookApp extends StatelessWidget {
  const CharacterBookApp({super.key});

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
      child: const _AppContent(),
    );
  }
}

class _AppContent extends StatefulWidget {
  const _AppContent();

  @override
  State<_AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<_AppContent>
    with WidgetsBindingObserver, WindowListener {
  final bool _hiveInitializedSuccessfully = true;
  bool _showErrorDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (InitializationService.isDesktopPlatform) {
      windowManager.addListener(this);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitializationStatus();
    });
  }

  void _checkInitializationStatus() {
    if (!_hiveInitializedSuccessfully && !_showErrorDialog) {
      setState(() {
        _showErrorDialog = true;
      });

      ErrorDialogService.showInitializationErrorDialog(
        context,
        error: InitializationError(
          title: 'Проблемы с инициализацией данных',
          message:
              'При запуске приложения возникли проблемы с загрузкой данных. '
              'Для восстановления работоспособности приложение сбросило поврежденные данные.',
          requiresReset: true,
        ),
      ).then((_) {
        setState(() {
          _showErrorDialog = false;
        });
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (InitializationService.isDesktopPlatform) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _flushHiveBoxes();
    }
  }

  Future<void> _flushHiveBoxes() async {
    try {
      await Hive.box<Character>('characters').flush();
    } catch (error) {
      debugPrint('Error flushing Hive boxes: $error');
    }
  }

  void _openSettingsPage() => Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => const SettingsPage(),
  ));

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
          home: _buildHome(),
        );
      },
    );
  }

  Widget _buildHome() {
    if (InitializationService.isMobilePlatform) {
      return const FileHandlerWrapper(child: AppNavigationBar());
    } else {
      return const DesktopAppFrame();
    }
  }
}
