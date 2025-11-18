// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_universal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterUniversalAdapter extends TypeAdapter<CharacterUniversal> {
  @override
  final int typeId = 10;

  @override
  CharacterUniversal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterUniversal(
      id: fields[0] as String?,
      name: fields[1] as String,
      age: fields[2] as int,
      gender: fields[3] as String,
      race: fields[4] as Race?,
      tags: fields[10] == null ? [] : (fields[10] as List).cast<String>(),
      customFields: (fields[5] as List?)?.cast<CustomField>(),
      additionalImages: (fields[7] as List?)?.cast<Uint8List>(),
      lastEdited: fields[8] as DateTime?,
      folderId: fields[9] as String?,
      imageBytes: fields[6] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterUniversal obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.race)
      ..writeByte(5)
      ..write(obj.customFields)
      ..writeByte(6)
      ..write(obj.imageBytes)
      ..writeByte(7)
      ..write(obj.additionalImages)
      ..writeByte(8)
      ..write(obj.lastEdited)
      ..writeByte(9)
      ..write(obj.folderId)
      ..writeByte(10)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterUniversalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
