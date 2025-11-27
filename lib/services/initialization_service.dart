import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../models/character_model.dart';
import '../models/template_model.dart';
import '../models/folder_model.dart';
import '../models/note_model.dart';
import '../models/race_model.dart';
import '../models/export_pdf_settings_model.dart';
import 'hive_service.dart';
import '../generated/l10n.dart';

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

  static Future<bool> initializeHive() async {
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
      return true;
    } catch (error) {
      debugPrint('Hive initialization error: $error');
      await HiveService.resetAndReinitialize();
      return false;
    }
  }

  static Future<void> initializeWindowManager() async {
    if (!isDesktopPlatform) return;

    try {
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
    } catch (error) {
      debugPrint('Window manager initialization error: $error');
      rethrow;
    }
  }
}

class InitializationError {
  final String title;
  final String message;
  final bool requiresReset;

  InitializationError({
    required this.title,
    required this.message,
    this.requiresReset = false,
  });
}

class ErrorDialogService {
  static Future<void> showInitializationErrorDialog(
    BuildContext context, {
    required InitializationError error,
  }) async {
    final s = S.of(context);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(error.title)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(error.message),
              if (error.requiresReset) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          s.initialization_reset_warning,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(s.understood),
            ),
            if (error.requiresReset)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDetailedErrorInfo(context, error);
                },
                child: Text(s.details),
              ),
          ],
        );
      },
    );
  }

  static Future<void> showCriticalErrorDialog(
    BuildContext context, {
    required String message,
  }) async {
    final s = S.of(context);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(s.critical_error),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.critical_error_warning,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (InitializationService.isDesktopPlatform) {
                  exit(0);
                }
              },
              child: Text(s.close_app),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(s.continue_text),
            ),
          ],
        );
      },
    );
  }

  static void _showDetailedErrorInfo(
      BuildContext context, InitializationError error) {
    final s = S.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.error_details),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.error_details_description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.technical_details,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.message,
                      style: const TextStyle(
                          fontFamily: 'Monospace', fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                s.recovery_advice,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(s.close),
          ),
        ],
      ),
    );
  }
}
