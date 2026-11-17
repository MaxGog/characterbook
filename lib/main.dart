import 'dart:async';

import 'package:characterbook/config/app_router.dart';
import 'package:characterbook/features/calendar/domain/custom_event_repository.dart';
import 'package:characterbook/features/calendar/application/custom_event_service.dart';
import 'package:characterbook/features/calendar/data/custom_event_repository_hive.dart';
import 'package:characterbook/features/characters/presentation/providers/character_service.dart';
import 'package:characterbook/features/characters/data/character_repository_hive.dart';
import 'package:characterbook/features/characters/domain/character_repository.dart';
import 'package:characterbook/features/notes/presentation/providers/note_service.dart';
import 'package:characterbook/features/notes/data/note_repository_hive.dart';
import 'package:characterbook/features/notes/domain/note_repository.dart';
import 'package:characterbook/features/races/presentation/providers/race_service.dart';
import 'package:characterbook/features/races/data/race_repository_hive.dart';
import 'package:characterbook/features/races/domain/race_repository.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/handlers/file_handler.dart';
import 'package:characterbook/features/backup/data/cloud_backup_service.dart';
import 'package:characterbook/features/backup/data/local_backup_service.dart';
import 'package:characterbook/features/backup/data/repository_backup_repository.dart';
import 'package:characterbook/features/backup/domain/backup_manager.dart';
import 'package:characterbook/features/backup/domain/backup_repository.dart';
import 'package:characterbook/features/backup/presentation/auto_backup_provider.dart';
import 'package:characterbook/features/backup/presentation/backup_controller.dart';
import 'package:characterbook/core/file_share_actions.dart';
import 'package:characterbook/core/local_notification_actions.dart';
import 'package:characterbook/core/app_settings_actions.dart';
import 'package:characterbook/features/notifications/data/local_notification_service.dart';
import 'package:characterbook/features/notifications/presentation/overlay_notification.dart';
import 'package:characterbook/features/sharing/data/file_share_service.dart';
import 'package:characterbook/features/sharing/data/pdf_export_action_service.dart';
import 'package:characterbook/features/sharing/data/pdf_export_service.dart';
import 'package:characterbook/features/sharing/application/pdf_export_actions.dart';
import 'package:characterbook/features/settings/presentation/providers/locale_provider.dart';
import 'package:characterbook/features/settings/presentation/providers/swipe_action_settings_provider.dart';
import 'package:characterbook/features/settings/presentation/providers/theme_provider.dart';
import 'package:characterbook/features/settings/presentation/settings_actions.dart';
import 'package:characterbook/features/settings/data/locale_channel_service.dart';
import 'package:characterbook/features/settings/domain/locale_channel_actions.dart';
import 'package:characterbook/features/sharing/domain/export_pdf_settings_actions.dart';
import 'package:characterbook/features/relationships/domain/relationship_repository.dart';
import 'package:characterbook/features/relationships/data/relationship_repository_hive.dart';
import 'package:characterbook/features/templates/domain/template_repository.dart';
import 'package:characterbook/services/app_navigator.dart';
import 'package:characterbook/features/calendar/data/device_calendar_service.dart';
import 'package:characterbook/features/calendar/domain/device_calendar_actions.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:characterbook/core/storage/hive_service.dart';
import 'package:characterbook/services/menu_channel_service.dart';
import 'package:characterbook/features/relationships/presentation/providers/relationship_service.dart';
import 'package:characterbook/features/templates/application/template_service.dart';
import 'package:characterbook/features/templates/data/template_file_picker.dart';
import 'package:characterbook/features/templates/data/template_repository_hive.dart';
import 'package:characterbook/features/templates/domain/template_import_actions.dart';
import 'package:characterbook/features/templates/presentation/template_list_controller.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:characterbook/providers/pins_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();

  bool hiveInitialized = false;
  try {
    await HiveService.initializeAll();
    hiveInitialized = true;
  } catch (error) {
    debugPrint('Critical initialization error: $error');
    hiveInitialized = false;
  }

  await FileHandler.initialize();

  runApp(
    CharacterBookApp(
      hiveInitialized: hiveInitialized,
      localNotificationActions: localNotificationService,
    ),
  );
}

class CharacterBookApp extends StatelessWidget {
  final bool hiveInitialized;
  final LocalNotificationActions? localNotificationActions;

  const CharacterBookApp({
    super.key,
    required this.hiveInitialized,
    this.localNotificationActions,
  });

  @override
  Widget build(BuildContext context) {
    AppNavigator.configureNotifications(
      OverlayNotificationService(
        navigatorKey: appRouter.routerDelegate.navigatorKey,
      ),
    );
    final characterBox = HiveService.characterBox;
    final raceBox = HiveService.raceBox;
    final noteBox = HiveService.noteBox;
    final templateBox = HiveService.templateBox;
    final relationshipBox = HiveService.relationshipBox;
    final customEventBox = HiveService.customEventBox;
    final appSettingsBox = HiveService.appSettingsBox;

    return MultiProvider(
      providers: [
        Provider<FilePickerService>(create: (_) => FilePickerService()),
        Provider<FileShareActions>(
          create: (_) => const FileShareService(),
        ),
        Provider<ExportPdfSettingsActions>(
          create: (_) => ExportPdfSettingsService(),
        ),
        ProxyProvider<ExportPdfSettingsActions, PdfExportActions>(
          update: (_, settings, __) => PdfExportActionService(settings),
        ),
        ChangeNotifierProvider(create: (_) => PinsProvider()),
        if (characterBox != null)
          Provider<CharacterRepositoryHive>(
            create: (_) => CharacterRepositoryHive(characterBox),
          ),
        if (characterBox != null)
          Provider<CharacterRepository>(
            create: (context) => context.read<CharacterRepositoryHive>(),
          ),
        if (raceBox != null)
          Provider<RaceRepository>(
            create: (_) => RaceRepositoryHive(raceBox),
          ),
        if (noteBox != null)
          Provider<NoteRepository>(
            create: (context) => NoteRepositoryHive(
              noteBox,
              resolveLegacyCharacterId: characterBox == null
                  ? null
                  : context.read<CharacterRepositoryHive>().resolveLegacyKey,
            ),
          ),
        if (templateBox != null)
          Provider<TemplateRepository>(
            create: (_) => TemplateRepositoryHive(templateBox),
          ),
        if (relationshipBox != null)
          Provider<RelationshipRepository>(
            create: (_) => RelationshipRepositoryHive(relationshipBox),
          ),
        if (appSettingsBox != null)
          ChangeNotifierProvider<AutoBackupProvider>(
            create: (_) => AutoBackupProvider(appSettingsBox),
          ),
        if (customEventBox != null)
          Provider<CustomEventRepository>(
            create: (_) => CustomEventRepositoryHive(customEventBox),
          ),
        Provider<DeviceCalendarActions>(
          create: (_) => DeviceCalendarService(),
        ),
        Provider<LocalNotificationActions>(
          create: (_) {
            final configuredActions = localNotificationActions;
            if (configuredActions != null) {
              return configuredActions;
            }
            final service = LocalNotificationService();
            unawaited(service.initialize());
            return service;
          },
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<LocaleChannelActions>(
          create: (_) => LocaleChannelService(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              LocaleProvider(context.read<LocaleChannelActions>()),
        ),
        ChangeNotifierProvider(create: (_) => SwipeActionSettingsProvider()),
        ListenableProxyProvider<ThemeProvider, ThemeSettingsActions>(
          update: (_, settings, __) => settings,
        ),
        ListenableProxyProvider<LocaleProvider, LocaleSettingsActions>(
          update: (_, settings, __) => settings,
        ),
        ListenableProxyProvider<SwipeActionSettingsProvider,
            SwipeActionSettingsActions>(
          update: (_, settings, __) => settings,
        ),
      ],
      child: _AppServicesWrapper(
        hiveInitialized: hiveInitialized,
      ),
    );
  }
}

class _AppServicesWrapper extends StatelessWidget {
  final bool hiveInitialized;
  const _AppServicesWrapper({
    required this.hiveInitialized,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RelationshipService(
            context.read<RelationshipRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CharacterService(
            context.read<CharacterRepository>(),
            context.read<RelationshipRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RaceService(
            context.read<RaceRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => NoteService(
            context.read<NoteRepository>(),
          ),
        ),
        Provider<TemplateImportActions>(
          create: (context) => TemplateFilePicker(
            () => context.read<FilePickerService>().importTemplate(),
          ),
        ),
        Provider<TemplateService>(
          create: (context) => TemplateService(
            context.read<TemplateRepository>(),
            context.read<TemplateImportActions>(),
          ),
        ),
        ProxyProvider<CustomEventRepository, CustomEventService>(
          update: (_, repo, __) => CustomEventService(repo),
        ),
        ProxyProvider5<CharacterRepository, RaceRepository, NoteRepository,
            TemplateRepository, RelationshipRepository, BackupRepository>(
          update: (_, charRepo, raceRepo, noteRepo, templateRepo,
                  relationshipRepo, __) =>
              RepositoryBackupRepository(
            characterRepository: charRepo,
            noteRepository: noteRepo,
            raceRepository: raceRepo,
            templateRepository: templateRepo,
            relationshipRepository: relationshipRepo,
          ),
        ),
        ProxyProvider<BackupRepository, BackupManager>(
          update: (_, repository, __) => BackupManager(repository),
        ),
        ProxyProvider3<BackupManager, FilePickerService, FileShareActions,
            LocalBackupService>(
          update: (_, backupManager, filePicker, fileShareActions, __) =>
              LocalBackupService(
            backupManager: backupManager,
            pickBackupFile: () => filePicker.pickRestoreFile(),
            fileShareActions: fileShareActions,
          ),
        ),
        ProxyProvider<BackupManager, CloudBackupService>(
          update: (_, backupManager, __) => CloudBackupService(
            backupManager: backupManager,
          ),
        ),
        ChangeNotifierProvider<BackupController>(
          create: (context) => BackupController(
            localBackupService: context.read<LocalBackupService>(),
            cloudBackupService: context.read<CloudBackupService>(),
            autoBackupSettings: context.read<AutoBackupProvider>(),
          ),
        ),
        ChangeNotifierProvider<TemplateListController>(
          create: (context) => TemplateListController(
            context.read<TemplateRepository>(),
          ),
        ),
      ],
      child: _AppContent(
        hiveInitialized: hiveInitialized,
      ),
    );
  }
}

class _AppContent extends StatefulWidget {
  final bool hiveInitialized;
  const _AppContent({
    required this.hiveInitialized,
  });

  @override
  State<_AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<_AppContent> {
  bool _showErrorDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupMethodChannel();
      _checkInitializationStatus();
      _performAutoBackupIfEnabled();
    });
  }

  void _setupMethodChannel() {
    MenuChannel.initialize(
      onOpenSettings: AppNavigator.openSettings,
      onNewCharacter: AppNavigator.openNewCharacter,
      onOpenFile: AppNavigator.openFilePicker,
    );
  }

  void _performAutoBackupIfEnabled() {
    context.read<BackupController>().runAutomaticBackup().catchError(
      (Object error, StackTrace stackTrace) {
        debugPrint('Automatic backup failed: $error\n$stackTrace');
      },
    );
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
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, _) {
        return DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            themeProvider.updateDynamicColorSchemes(
              light: lightDynamic,
              dark: darkDynamic,
            );

            return MaterialApp.router(
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
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
            );
          },
        );
      },
    );
  }
}
