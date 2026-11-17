import 'package:uuid/uuid.dart';

class CustomEvent {
  final String id;

  final String title;

  final String description;

  final DateTime date;

  final bool hasReminder;

  final int reminderMinutesBefore;

  final bool addedToDeviceCalendar;

  final String? deviceCalendarEventId;

  CustomEvent({
    String? id,
    required this.title,
    this.description = '',
    required this.date,
    this.hasReminder = false,
    this.reminderMinutesBefore = 15,
    this.addedToDeviceCalendar = false,
    this.deviceCalendarEventId,
  }) : id = id ?? const Uuid().v4();

  CustomEvent copyWith({
    String? title,
    String? description,
    DateTime? date,
    bool? hasReminder,
    int? reminderMinutesBefore,
    bool? addedToDeviceCalendar,
    String? deviceCalendarEventId,
  }) {
    return CustomEvent(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      addedToDeviceCalendar:
          addedToDeviceCalendar ?? this.addedToDeviceCalendar,
      deviceCalendarEventId:
          deviceCalendarEventId ?? this.deviceCalendarEventId,
    );
  }
}
