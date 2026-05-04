// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FolderAdapter extends TypeAdapter<Folder> {
  @override
  final int typeId = 5;

  @override
  Folder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Folder(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as FolderType,
      parentId: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
      contentIds: fields[6] == null ? [] : (fields[6] as List?)?.cast<String>(),
      colorValue: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Folder obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.parentId)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.contentIds)
      ..writeByte(7)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FolderTypeAdapter extends TypeAdapter<FolderType> {
  @override
  final int typeId = 6;

  @override
  FolderType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FolderType.character;
      case 1:
        return FolderType.race;
      case 2:
        return FolderType.note;
      case 3:
        return FolderType.template;
      default:
        return FolderType.character;
    }
  }

  @override
  void write(BinaryWriter writer, FolderType obj) {
    switch (obj) {
      case FolderType.character:
        writer.writeByte(0);
        break;
      case FolderType.race:
        writer.writeByte(1);
        break;
      case FolderType.note:
        writer.writeByte(2);
        break;
      case FolderType.template:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
