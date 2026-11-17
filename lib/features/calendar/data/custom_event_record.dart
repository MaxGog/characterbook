import 'package:hive/hive.dart';

part 'custom_event_record.g.dart';

@HiveType(typeId: 13)
class CustomEventRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final bool hasReminder;

  @HiveField(5)
  final int reminderMinutesBefore;

  @HiveField(6)
  final bool addedToDeviceCalendar;

  @HiveField(7)
  final String? deviceCalendarEventId;

  CustomEventRecord({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.hasReminder,
    required this.reminderMinutesBefore,
    required this.addedToDeviceCalendar,
    required this.deviceCalendarEventId,
  });
}
