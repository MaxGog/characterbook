import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';
import '../models/characters/character_model.dart';
import '../models/characters/template_model.dart';
import '../models/folder_model.dart';
import '../models/note_model.dart';
import '../models/race_model.dart';
import '../models/export_pdf_settings_model.dart';
import 'hive_service.dart';

class InitializationService {
  static bool get isDesktopPlatform =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS);

  static bool get isMobilePlatform {
    if (kIsWeb) return false;
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (e) {
      return false;
    }
  }

  static Future<void> initializeHive() async {
    try {
      await HiveService.initHive();
      await Future.wait([
        HiveService.getBox<Character>('characters'),
        HiveService.getBox<Note>('notes'),
        HiveService.getBox<Race>('races'),
        HiveService.getBox<QuestionnaireTemplate>('templates'),
        HiveService.getBox<Folder>('folders'),
        HiveService.getBox<ExportPdfSettings>('pdf_settings'),
      ]);
    } catch (error) {
      debugPrint('Hive initialization error: $error');
    }
  }

  static Future<void> initializeWindowManager() async {
    if (!isDesktopPlatform) return;

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
}
