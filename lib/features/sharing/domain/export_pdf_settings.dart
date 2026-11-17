class ExportPdfSettings {
  bool includeBasicInfo;

  bool includeBiography;

  bool includePersonality;

  bool includeAppearance;

  bool includeAbilities;

  bool includeOther;

  bool includeCustomFields;

  bool includeReferenceImage;

  bool includeAdditionalImages;

  double titleFontSize;

  double bodyFontSize;

  String titleColor;

  String bodyColor;

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
