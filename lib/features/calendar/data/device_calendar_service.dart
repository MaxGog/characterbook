import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:characterbook/features/calendar/domain/device_calendar_actions.dart';
import 'package:timezone/timezone.dart' as tz;

class DeviceCalendarService implements DeviceCalendarActions {
  final DeviceCalendarPlugin _deviceCalendar = DeviceCalendarPlugin();

  @override
  Future<bool> requestPermission() async {
    final result = await _deviceCalendar.requestPermissions();
    return result.isSuccess && result.data == true;
  }

  @override
  Future<String?> addEvent({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final permissionGranted = await requestPermission();
      if (!permissionGranted) return null;

      final calendarsResult = await _deviceCalendar.retrieveCalendars();
      if (calendarsResult.data == null || calendarsResult.data!.isEmpty) {
        debugPrint('No calendars found');
        return null;
      }

      final calendars = calendarsResult.data!;
      final writableCalendar = calendars.firstWhere(
        (cal) => cal.isReadOnly == false,
        orElse: () => calendars.first,
      );

      final startTZ = tz.TZDateTime.from(startDate, tz.local);
      final endTZ = tz.TZDateTime.from(endDate, tz.local);

      final event = Event(
        writableCalendar.id,
        title: title,
        description: description,
        start: startTZ,
        end: endTZ,
        location: 'CharacterBook',
      );

      final result = await _deviceCalendar.createOrUpdateEvent(event);
      if (result?.isSuccess == true) {
        return result!.data;
      }
    } catch (e) {
      debugPrint('Error adding event to device calendar: $e');
    }
    return null;
  }

  @override
  Future<bool> deleteEvent(String eventId) async {
    try {
      final calendarsResult = await _deviceCalendar.retrieveCalendars();
      if (calendarsResult.data == null) return false;

      for (final calendar in calendarsResult.data!) {
        if (calendar.isReadOnly!) continue;
        final delResult =
            await _deviceCalendar.deleteEvent(eventId, calendar.id);
        if (delResult.isSuccess == true) {
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error deleting device calendar event: $e');
    }
    return false;
  }
}
