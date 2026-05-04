// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_pdf_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExportPdfSettingsAdapter extends TypeAdapter<ExportPdfSettings> {
  @override
  final int typeId = 11;

  @override
  ExportPdfSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExportPdfSettings(
      includeBasicInfo: fields[0] as bool,
      includeBiography: fields[1] as bool,
      includePersonality: fields[2] as bool,
      includeAppearance: fields[3] as bool,
      includeAbilities: fields[4] as bool,
      includeOther: fields[5] as bool,
      includeCustomFields: fields[6] as bool,
      includeReferenceImage: fields[7] as bool,
      includeAdditionalImages: fields[8] as bool,
      includeCharacterImage: fields[13] as bool,
      titleFontSize: fields[9] as double,
      bodyFontSize: fields[10] as double,
      titleColor: fields[11] as String,
      bodyColor: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExportPdfSettings obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.includeBasicInfo)
      ..writeByte(1)
      ..write(obj.includeBiography)
      ..writeByte(2)
      ..write(obj.includePersonality)
      ..writeByte(3)
      ..write(obj.includeAppearance)
      ..writeByte(4)
      ..write(obj.includeAbilities)
      ..writeByte(5)
      ..write(obj.includeOther)
      ..writeByte(6)
      ..write(obj.includeCustomFields)
      ..writeByte(7)
      ..write(obj.includeReferenceImage)
      ..writeByte(8)
      ..write(obj.includeAdditionalImages)
      ..writeByte(9)
      ..write(obj.titleFontSize)
      ..writeByte(10)
      ..write(obj.bodyFontSize)
      ..writeByte(11)
      ..write(obj.titleColor)
      ..writeByte(12)
      ..write(obj.bodyColor)
      ..writeByte(13)
      ..write(obj.includeCharacterImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExportPdfSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
