abstract interface class DeviceCalendarActions {
  Future<bool> requestPermission();

  Future<String?> addEvent({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<bool> deleteEvent(String eventId);
}
