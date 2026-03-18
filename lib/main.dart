import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/handlers/file_handler.dart';
import 'package:characterbook/handlers/file_handler_wrapper.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/export_pdf_settings_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/relationship_model.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:characterbook/providers/locale_provider.dart';
import 'package:characterbook/providers/theme_provider.dart';
import 'package:characterbook/repositories/character_repository.dart';
import 'package:characterbook/repositories/folder_repository.dart';
import 'package:characterbook/repositories/note_repository.dart';
import 'package:characterbook/repositories/race_repository.dart';
import 'package:characterbook/repositories/relationship_repository.dart';
import 'package:characterbook/repositories/template_repository.dart';
import 'package:characterbook/services/backup_service.dart';
import 'package:characterbook/services/character_service.dart';
import 'package:characterbook/services/clipboard_service.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:characterbook/services/file_share_service.dart';
import 'package:characterbook/services/folder_service.dart';
import 'package:characterbook/services/hive_service.dart';
import 'package:characterbook/services/note_service.dart';
import 'package:characterbook/services/notification_service.dart';
import 'package:characterbook/services/race_service.dart';
import 'package:characterbook/services/relationship_service.dart';
import 'package:characterbook/services/template_service.dart';
import 'package:characterbook/ui/navigation/app_navigation_bar.dart';
import 'package:characterbook/ui/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool hiveInitialized = false;
  Box<Character>? characterBox;
  Box<Race>? raceBox;
  Box<Folder>? folderBox;
  Box<Note>? noteBox;
  Box<QuestionnaireTemplate>? templateBox;
  Box<ExportPdfSettings>? settingsBox;
  Box<Relationship>? relationshipBox;

  try {
    await HiveService.initHive();

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(RelationshipAdapter());
    }

    characterBox = await _openBoxWithRetry<Character>('characters');
    raceBox = await _openBoxWithRetry<Race>('races');
    folderBox = await _openBoxWithRetry<Folder>('folders');
    noteBox = await _openBoxWithRetry<Note>('notes');
    templateBox = await _openBoxWithRetry<QuestionnaireTemplate>('templates');
    settingsBox = await _openBoxWithRetry<ExportPdfSettings>('pdf_settings');
    relationshipBox =
        await _openBoxWithRetry<Relationship>('relationships');

    hiveInitialized = true;
  } catch (error) {
    debugPrint('Critical initialization error: $error');
    hiveInitialized = false;
  }

  await FileHandler.initialize();

  runApp(CharacterBookApp(
    hiveInitialized: hiveInitialized,
    characterBox: characterBox,
    raceBox: raceBox,
    folderBox: folderBox,
    noteBox: noteBox,
    templateBox: templateBox,
    settingsBox: settingsBox,
    relationshipBox: relationshipBox,
  ));
}

Future<Box<T>> _openBoxWithRetry<T>(String name) async {
  try {
    return await HiveService.openBox<T>(name);
  } catch (e) {
    debugPrint('Error opening box $name, deleting and retrying: $e');
    await HiveService.deleteBox(name);
    return await HiveService.openBox<T>(name);
  }
}

class CharacterBookApp extends StatelessWidget {
  final bool hiveInitialized;
  final Box<Character>? characterBox;
  final Box<Race>? raceBox;
  final Box<Folder>? folderBox;
  final Box<Note>? noteBox;
  final Box<QuestionnaireTemplate>? templateBox;
  final Box<ExportPdfSettings>? settingsBox;
  final Box<Relationship>? relationshipBox;

  const CharacterBookApp({
    super.key,
    required this.hiveInitialized,
    this.characterBox,
    this.raceBox,
    this.folderBox,
    this.noteBox,
    this.templateBox,
    this.settingsBox,
    this.relationshipBox,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> messengerKey =
        GlobalKey<ScaffoldMessengerState>();

    return MultiProvider(
      providers: [
        Provider<FilePickerService>(create: (_) => FilePickerService()),
        Provider<ClipboardService>(create: (_) => ClipboardService()),
        Provider<FileShareService>(create: (_) => FileShareService()),
        if (characterBox != null)
          Provider<CharacterRepository>(
            create: (_) => CharacterRepositoryHive(characterBox!),
          ),
        if (raceBox != null)
          Provider<RaceRepository>(
            create: (_) => RaceRepositoryHive(raceBox!),
          ),
        if (folderBox != null)
          Provider<FolderRepository>(
            create: (_) => FolderRepositoryHive(folderBox!),
          ),
        if (noteBox != null)
          Provider<NoteRepository>(
            create: (_) => NoteRepositoryHive(noteBox!),
          ),
        if (templateBox != null)
          Provider<TemplateRepository>(
            create: (_) => TemplateRepositoryHive(templateBox!),
          ),
        if (relationshipBox != null)
          Provider<RelationshipRepository>(
            create: (_) => RelationshipRepositoryHive(relationshipBox!),
          ),
        ProxyProvider<RelationshipRepository, RelationshipService>(
          update: (_, repo, __) => RelationshipService(repo),
        ),

        ProxyProvider2<CharacterRepository, RelationshipService, CharacterService>(
          update: (_, repo, relService, __) =>
              CharacterService(repo, relService),
        ),
        ProxyProvider<RaceRepository, RaceService>(
          update: (_, repo, __) => RaceService(repo),
        ),
        ProxyProvider<FolderRepository, FolderService>(
          update: (_, repo, __) => FolderService(repo),
        ),
        ProxyProvider<NoteRepository, NoteService>(
          update: (_, repo, __) => NoteService(repo),
        ),
        ProxyProvider<TemplateRepository, TemplateService>(
          update: (_, repo, __) => TemplateService(repo),
        ),
        
        ProxyProvider5<CharacterRepository, RaceRepository, FolderRepository,
            NoteRepository, TemplateRepository, BackupManager>(
          update:
              (_, charRepo, raceRepo, folderRepo, noteRepo, templateRepo, __) {
            return BackupManager(
              characterRepo: charRepo,
              noteRepo: noteRepo,
              raceRepo: raceRepo,
              templateRepo: templateRepo,
              folderRepo: folderRepo,
            );
          },
        ),
        Provider<NotificationService>(
          create: (_) => NotificationService(messengerKey),
        ),
        ProxyProvider3<BackupManager, FilePickerService, NotificationService,
            LocalBackupService>(
          update: (_, backupManager, filePicker, notification, __) {
            return LocalBackupService(
              backupManager: backupManager,
              filePickerService: filePicker,
              notificationService: notification,
            );
          },
        ),
        ProxyProvider2<BackupManager, NotificationService, CloudBackupService>(
          update: (_, backupManager, notification, __) {
            return CloudBackupService(
              backupManager: backupManager,
              notificationService: notification,
            );
          },
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: _AppContent(
        hiveInitialized: hiveInitialized,
        messengerKey: messengerKey,
      ),
    );
  }
}

class _AppContent extends StatefulWidget {
  final bool hiveInitialized;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  const _AppContent({
    required this.hiveInitialized,
    required this.messengerKey,
  });

  @override
  State<_AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<_AppContent> {
  bool _showErrorDialog = false;
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupMethodChannel();
      _checkInitializationStatus();
    });
  }

  void _setupMethodChannel() {
    const channel = MethodChannel('characterbook/menu');
    channel.setMethodCallHandler((call) async {
      if (call.method == 'openSettings') {
        _navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
      }
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
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: widget.messengerKey,
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
