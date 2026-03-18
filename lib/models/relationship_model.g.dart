// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RelationshipAdapter extends TypeAdapter<Relationship> {
  @override
  final int typeId = 12;

  @override
  Relationship read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Relationship(
      id: fields[0] as String?,
      character1Id: fields[1] as String,
      character2Id: fields[2] as String,
      name: fields[3] as String,
      description: fields[4] as String,
      created: fields[5] as DateTime?,
      lastEdited: fields[6] as DateTime?,
      type: fields[7] as String?,
      directed: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Relationship obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.character1Id)
      ..writeByte(2)
      ..write(obj.character2Id)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.created)
      ..writeByte(6)
      ..write(obj.lastEdited)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.directed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelationshipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
