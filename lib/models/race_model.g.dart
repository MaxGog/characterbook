// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RaceAdapter extends TypeAdapter<Race> {
  @override
  final int typeId = 3;

  @override
  Race read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Race(
      name: fields[0] as String,
      description: fields[1] as String,
      biology: fields[2] as String,
      backstory: fields[3] as String,
      logo: fields[4] as Uint8List?,
      folderId: fields[5] as String?,
      tags: fields[6] == null ? [] : (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Race obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.biology)
      ..writeByte(3)
      ..write(obj.backstory)
      ..writeByte(4)
      ..write(obj.logo)
      ..writeByte(5)
      ..write(obj.folderId)
      ..writeByte(6)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
