import 'package:characterbook/config/app_router.dart';
import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/features/notes/domain/note_model.dart';
import 'package:characterbook/features/races/domain/race_model.dart';
import 'package:characterbook/features/templates/domain/template_model.dart';
import 'package:characterbook/core/app_notification_actions.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:characterbook/ui/navigation/app_menu_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppNavigator {
  static AppNotificationActions? _notificationActions;

  static void configureNotifications(AppNotificationActions actions) {
    _notificationActions = actions;
  }

  static BuildContext? get _context =>
      appRouter.routerDelegate.navigatorKey.currentContext;

  static NavigatorState? get navigator =>
      appRouter.routerDelegate.navigatorKey.currentState;

  static void goToHome() => appRouter.go('/home');
  static void goToCharacters() => appRouter.go('/characters');
  static void goToRaces() => appRouter.go('/races');
  static void goToNotes() => appRouter.go('/notes');

  static Future<bool?> openNewCharacter({QuestionnaireTemplate? template}) {
    return appRouter.push<bool>(
      '/characters/create',
      extra: template,
    );
  }

  static Future<bool?> openNewRace() {
    return appRouter.push<bool>('/races/create');
  }

  static Future<bool?> openNewNote() {
    return appRouter.push<bool>('/notes/create');
  }

  static Future<bool?> editCharacter(Character character) {
    return appRouter.push<bool>(
      '/characters/${character.id}/edit',
      extra: character,
    );
  }

  static Future<bool?> editRace(Race race) {
    return appRouter.push<bool>(
      '/races/${race.id}/edit',
      extra: race,
    );
  }

  static Future<bool?> editNote(Note note) {
    return appRouter.push<bool>(
      '/notes/${note.id}/edit',
      extra: note,
    );
  }

  static void openSettings() {
    appRouter.push('/settings');
  }

  static Future<QuestionnaireTemplate?> openTemplates() {
    return appRouter.push<QuestionnaireTemplate>('/templates');
  }

  static Future<bool?> openSwipeActionSettings() {
    return appRouter.push<bool>('/settings/swipe-actions');
  }

  static void openFilePicker() {
    final ctx = _context;
    if (ctx != null) {
      final filePicker = Provider.of<FilePickerService>(ctx, listen: false);
      filePicker.importCharacter();
    }
  }

  static void showNotification(
    String message, {
    AppNotificationType type = AppNotificationType.success,
    Duration duration = const Duration(seconds: 2),
  }) {
    final actions = _notificationActions;
    if (actions == null) {
      throw StateError('App notifications have not been configured.');
    }
    actions.showNotification(message, type: type, duration: duration);
  }

  static void showSuccess(String message) =>
      showNotification(message, type: AppNotificationType.success);
  static void showError(String message) =>
      showNotification(message, type: AppNotificationType.error);
  static void showInfo(String message) =>
      showNotification(message, type: AppNotificationType.info);

  static void openMenu(BuildContext context) {
    if (MediaQuery.sizeOf(context).width >= 600) {
      scaffoldKey.currentState?.openDrawer();
    } else {
      showAppMenuBottomSheet(context);
    }
  }
}
