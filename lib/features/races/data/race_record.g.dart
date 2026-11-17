// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RaceRecordAdapter extends TypeAdapter<RaceRecord> {
  @override
  final int typeId = 3;

  @override
  RaceRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RaceRecord(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      biology: fields[3] as String,
      backstory: fields[4] as String,
      logo: fields[5] as Uint8List?,
      folderId: fields[6] as String?,
      tags: fields[7] == null ? [] : (fields[7] as List).cast<String>(),
      additionalImages:
          fields[8] == null ? [] : (fields[8] as List).cast<Uint8List>(),
      lastEdited: fields[9] as DateTime,
      sortOrder: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RaceRecord obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.biology)
      ..writeByte(4)
      ..write(obj.backstory)
      ..writeByte(5)
      ..write(obj.logo)
      ..writeByte(6)
      ..write(obj.folderId)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.additionalImages)
      ..writeByte(9)
      ..write(obj.lastEdited)
      ..writeByte(10)
      ..write(obj.sortOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RaceRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
