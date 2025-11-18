import 'dart:io';

import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:characterbook/services/hive_service.dart';
import 'package:characterbook/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'generated/l10n.dart';
import 'models/character_model.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'services/file_handler.dart';
import 'services/file_handler_wrapper.dart';
import 'ui/pages/home_page.dart';

Future<void> _initializeHive() async {
  try {
    await HiveService.initHive();
    await Future.wait([
      HiveService.getBox<Character>('characters'),
      HiveService.getBox<Note>('notes'),
      HiveService.getBox<Race>('races'),
      HiveService.getBox<QuestionnaireTemplate>('templates'),
      HiveService.getBox<Folder>('folders'),
    ]);
  } catch (error) {
    debugPrint('Hive initialization error: $error');
  }
}

Future<void> _initializeWindowManager() async {
  if (!_isDesktopPlatform) return;
  
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow();
  
  await windowManager.setTitleBarStyle(
    TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  await windowManager.setSize(const Size(1200, 800));
  await windowManager.setMinimumSize(const Size(800, 600));
  await windowManager.center();
  await windowManager.show();
}

bool get _isDesktopPlatform => Platform.isWindows || Platform.isMacOS;

bool get _isMobilePlatform {
  if (kIsWeb) return false;
  try {
    return Platform.isAndroid || Platform.isIOS;
  } catch (e) {
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    _initializeWindowManager(),
    _initializeHive(),
  ]);

  FileHandler.initialize();

  runApp(const CharacterBookApp());
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
          create: (_) => NotificationService(GlobalKey<ScaffoldMessengerState>()),
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
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    if (_isDesktopPlatform) {
      windowManager.addListener(this);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_isDesktopPlatform) {
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

  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, LocaleProvider, NotificationService>(
      builder: (context, themeProvider, localeProvider, notificationService, _) {
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
    if (_isMobilePlatform) {
      return const FileHandlerWrapper(child: HomePage());
    } else {
      return const _DesktopAppFrame();
    }
  }
}

class _DesktopAppFrame extends StatelessWidget {
  const _DesktopAppFrame();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: Column(
        children: [
          _DesktopTitleBar(),
          const Expanded(child: HomePage()),
        ],
      ),
    );
  }
}

class _DesktopTitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 36,
      color: theme.colorScheme.surfaceContainerLowest,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _AppTitle(),
          const Positioned(
            right: 0,
            child: _WindowControls(),
          ),
        ],
      ),
    );
  }
}

class _AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _AppIcon(),
        const SizedBox(width: 8),
        Text(
          'CharacterBook',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _AppIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ClipOval(
      child: Container(
        width: 24,
        height: 24,
        color: theme.colorScheme.surfaceContainerHigh,
        child: Image.asset(
          'assets/iconapp.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.book,
              size: 16,
              color: theme.colorScheme.primary,
            );
          },
        ),
      ),
    );
  }
}

class _WindowControls extends StatelessWidget {
  const _WindowControls();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _WindowControlButton(
          icon: Icons.minimize,
          action: WindowAction.minimize,
        ),
        _WindowControlButton(
          icon: Icons.crop_square,
          action: WindowAction.toggleMaximize,
        ),
        _WindowControlButton(
          icon: Icons.close,
          action: WindowAction.close,
          isClose: true,
        ),
      ],
    );
  }
}

class _WindowControlButton extends StatefulWidget {
  const _WindowControlButton({
    required this.icon,
    required this.action,
    this.isClose = false,
  });

  final IconData icon;
  final WindowAction action;
  final bool isClose;

  @override
  State<_WindowControlButton> createState() => _WindowControlButtonState();
}

class _WindowControlButtonState extends State<_WindowControlButton> {
  bool _isHovered = false;

  Future<void> _handleAction() async {
    try {
      switch (widget.action) {
        case WindowAction.minimize:
          await windowManager.minimize();
          break;
        case WindowAction.toggleMaximize:
          final isMaximized = await windowManager.isMaximized();
          if (isMaximized) {
            await windowManager.unmaximize();
          } else {
            await windowManager.maximize();
          }
          break;
        case WindowAction.close:
          await windowManager.close();
          break;
      }
    } catch (error) {
      debugPrint('Window action error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = _getBackgroundColor(colorScheme, isDark);
    final iconColor = _getIconColor(colorScheme);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _handleAction,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 32,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            size: 16,
            color: iconColor,
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme, bool isDark) {
    if (!_isHovered) {
      return widget.isClose
          ? colorScheme.error.withOpacity(isDark ? 0.12 : 0.08)
          : colorScheme.onPrimaryContainer.withOpacity(isDark ? 0.08 : 0.04);
    }
    
    return widget.isClose
        ? colorScheme.error.withOpacity(isDark ? 0.24 : 0.16)
        : colorScheme.onSurface.withOpacity(isDark ? 0.16 : 0.12);
  }

  Color _getIconColor(ColorScheme colorScheme) {
    return widget.isClose
        ? colorScheme.error
        : _isHovered 
            ? colorScheme.onSurface 
            : colorScheme.onSurface.withOpacity(0.8);
  }
}

enum WindowAction {
  minimize,
  toggleMaximize,
  close,
}