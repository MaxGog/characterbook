enum AppNotificationType { success, error, info }

abstract interface class AppNotificationActions {
  void showNotification(
    String message, {
    AppNotificationType type = AppNotificationType.success,
    Duration duration = const Duration(seconds: 2),
  });
}
