import 'package:hive/hive.dart';

part 'export_pdf_settings_record.g.dart';

@HiveType(typeId: 11)
class ExportPdfSettingsRecord extends HiveObject {
  @HiveField(0)
  final bool includeBasicInfo;
  @HiveField(1)
  final bool includeBiography;
  @HiveField(2)
  final bool includePersonality;
  @HiveField(3)
  final bool includeAppearance;
  @HiveField(4)
  final bool includeAbilities;
  @HiveField(5)
  final bool includeOther;
  @HiveField(6)
  final bool includeCustomFields;
  @HiveField(7)
  final bool includeReferenceImage;
  @HiveField(8)
  final bool includeAdditionalImages;
  @HiveField(9)
  final double titleFontSize;
  @HiveField(10)
  final double bodyFontSize;
  @HiveField(11)
  final String titleColor;
  @HiveField(12)
  final String bodyColor;
  @HiveField(13)
  final bool includeCharacterImage;

  ExportPdfSettingsRecord({
    required this.includeBasicInfo,
    required this.includeBiography,
    required this.includePersonality,
    required this.includeAppearance,
    required this.includeAbilities,
    required this.includeOther,
    required this.includeCustomFields,
    required this.includeReferenceImage,
    required this.includeAdditionalImages,
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.titleColor,
    required this.bodyColor,
    required this.includeCharacterImage,
  });
}
