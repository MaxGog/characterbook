abstract interface class LocalNotificationActions {
  Future<int?> scheduleNotification({
    required String title,
    required String body,
    required DateTime eventDate,
    required int minutesBefore,
  });

  Future<void> cancelNotification(int id);

  Future<void> cancelForEvent(String title, DateTime eventDate);
}
