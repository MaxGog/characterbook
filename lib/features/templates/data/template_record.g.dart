// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TemplateRecordAdapter extends TypeAdapter<TemplateRecord> {
  @override
  final int typeId = 4;

  @override
  TemplateRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TemplateRecord(
      name: fields[0] as String,
      standardFields: (fields[1] as List).cast<String>(),
      customFields: (fields[2] as List).cast<CustomFieldRecord>(),
      sortOrder: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, TemplateRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.standardFields)
      ..writeByte(2)
      ..write(obj.customFields)
      ..writeByte(3)
      ..write(obj.sortOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
