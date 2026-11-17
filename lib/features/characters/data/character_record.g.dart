// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomFieldRecordAdapter extends TypeAdapter<CustomFieldRecord> {
  @override
  final int typeId = 1;

  @override
  CustomFieldRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomFieldRecord(
      key: fields[0] as String,
      value: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CustomFieldRecord obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomFieldRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CharacterRecordAdapter extends TypeAdapter<CharacterRecord> {
  @override
  final int typeId = 0;

  @override
  CharacterRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterRecord(
      id: fields[0] as String,
      name: fields[1] as String,
      age: fields[2] as int,
      gender: fields[3] as String,
      biography: fields[4] as String,
      personality: fields[5] as String,
      appearance: fields[6] as String,
      imageBytes: fields[7] as Uint8List?,
      abilities: fields[8] as String,
      other: fields[9] as String,
      referenceImageBytes: fields[10] as Uint8List?,
      customFields: (fields[11] as List).cast<CustomFieldRecord>(),
      additionalImages: (fields[12] as List).cast<Uint8List>(),
      lastEdited: fields[13] as DateTime,
      race: fields[14] as RaceRecord?,
      folderId: fields[15] as String?,
      tags: fields[16] == null ? [] : (fields[16] as List).cast<String>(),
      sortOrder: fields[17] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterRecord obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.biography)
      ..writeByte(5)
      ..write(obj.personality)
      ..writeByte(6)
      ..write(obj.appearance)
      ..writeByte(7)
      ..write(obj.imageBytes)
      ..writeByte(8)
      ..write(obj.abilities)
      ..writeByte(9)
      ..write(obj.other)
      ..writeByte(10)
      ..write(obj.referenceImageBytes)
      ..writeByte(11)
      ..write(obj.customFields)
      ..writeByte(12)
      ..write(obj.additionalImages)
      ..writeByte(13)
      ..write(obj.lastEdited)
      ..writeByte(14)
      ..write(obj.race)
      ..writeByte(15)
      ..write(obj.folderId)
      ..writeByte(16)
      ..write(obj.tags)
      ..writeByte(17)
      ..write(obj.sortOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
