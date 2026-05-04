import 'package:hive/hive.dart';

part 'export_pdf_settings_model.g.dart';

@HiveType(typeId: 11)
class ExportPdfSettings {
  @HiveField(0)
  bool includeBasicInfo;

  @HiveField(1)
  bool includeBiography;

  @HiveField(2)
  bool includePersonality;

  @HiveField(3)
  bool includeAppearance;

  @HiveField(4)
  bool includeAbilities;

  @HiveField(5)
  bool includeOther;

  @HiveField(6)
  bool includeCustomFields;

  @HiveField(7)
  bool includeReferenceImage;

  @HiveField(8)
  bool includeAdditionalImages;

  @HiveField(9)
  double titleFontSize;

  @HiveField(10)
  double bodyFontSize;

  @HiveField(11)
  String titleColor;

  @HiveField(12)
  String bodyColor;

  @HiveField(13)
  bool includeCharacterImage;

  ExportPdfSettings({
    this.includeBasicInfo = true,
    this.includeBiography = true,
    this.includePersonality = true,
    this.includeAppearance = true,
    this.includeAbilities = true,
    this.includeOther = true,
    this.includeCustomFields = true,
    this.includeReferenceImage = true,
    this.includeAdditionalImages = true,
    this.includeCharacterImage = true,
    this.titleFontSize = 24.0,
    this.bodyFontSize = 14.0,
    this.titleColor = '#000000',
    this.bodyColor = '#000000',
  });

  ExportPdfSettings copyWith({
    bool? includeBasicInfo,
    bool? includeBiography,
    bool? includePersonality,
    bool? includeAppearance,
    bool? includeAbilities,
    bool? includeOther,
    bool? includeCustomFields,
    bool? includeReferenceImage,
    bool? includeAdditionalImages,
    bool? includeCharacterImage,
    double? titleFontSize,
    double? bodyFontSize,
    String? titleColor,
    String? bodyColor,
  }) {
    return ExportPdfSettings(
      includeBasicInfo: includeBasicInfo ?? this.includeBasicInfo,
      includeBiography: includeBiography ?? this.includeBiography,
      includePersonality: includePersonality ?? this.includePersonality,
      includeAppearance: includeAppearance ?? this.includeAppearance,
      includeAbilities: includeAbilities ?? this.includeAbilities,
      includeOther: includeOther ?? this.includeOther,
      includeCustomFields: includeCustomFields ?? this.includeCustomFields,
      includeReferenceImage:
          includeReferenceImage ?? this.includeReferenceImage,
      includeAdditionalImages:
          includeAdditionalImages ?? this.includeAdditionalImages,
      includeCharacterImage:
          includeCharacterImage ?? this.includeCharacterImage,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      bodyFontSize: bodyFontSize ?? this.bodyFontSize,
      titleColor: titleColor ?? this.titleColor,
      bodyColor: bodyColor ?? this.bodyColor,
    );
  }
}
