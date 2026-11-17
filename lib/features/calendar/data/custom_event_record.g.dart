// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_event_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomEventRecordAdapter extends TypeAdapter<CustomEventRecord> {
  @override
  final int typeId = 13;

  @override
  CustomEventRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomEventRecord(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      date: fields[3] as DateTime,
      hasReminder: fields[4] as bool,
      reminderMinutesBefore: fields[5] as int,
      addedToDeviceCalendar: fields[6] as bool,
      deviceCalendarEventId: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomEventRecord obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.hasReminder)
      ..writeByte(5)
      ..write(obj.reminderMinutesBefore)
      ..writeByte(6)
      ..write(obj.addedToDeviceCalendar)
      ..writeByte(7)
      ..write(obj.deviceCalendarEventId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomEventRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
