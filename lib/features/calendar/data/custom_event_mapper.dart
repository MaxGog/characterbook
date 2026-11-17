import 'package:characterbook/features/calendar/domain/custom_event_model.dart';
import 'package:characterbook/features/calendar/data/custom_event_record.dart';

class CustomEventMapper {
  const CustomEventMapper();

  CustomEvent toDomain(CustomEventRecord record) => CustomEvent(
        id: record.id,
        title: record.title,
        description: record.description,
        date: record.date,
        hasReminder: record.hasReminder,
        reminderMinutesBefore: record.reminderMinutesBefore,
        addedToDeviceCalendar: record.addedToDeviceCalendar,
        deviceCalendarEventId: record.deviceCalendarEventId,
      );

  CustomEventRecord toRecord(CustomEvent event) => CustomEventRecord(
        id: event.id,
        title: event.title,
        description: event.description,
        date: event.date,
        hasReminder: event.hasReminder,
        reminderMinutesBefore: event.reminderMinutesBefore,
        addedToDeviceCalendar: event.addedToDeviceCalendar,
        deviceCalendarEventId: event.deviceCalendarEventId,
      );
}
