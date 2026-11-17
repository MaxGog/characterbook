class PdfLocalizationData {
  final String serviceCreationError;
  final String raceServiceCreationError;
  final String unsupportedModelType;
  final String pdfGenerationError;
  final String fontLoadTimeout;
  final String settingsLoadError;
  final String settingsSaveError;

  final String characterProfileTitle;
  final String raceProfileTitle;
  final String basicInfo;
  final String name;
  final String age;
  final String gender;
  final String race;
  final String description;
  final String biography;
  final String personality;
  final String appearance;
  final String abilities;
  final String other;
  final String referenceImage;
  final String customFields;
  final String additionalImages;
  final String biology;
  final String backstory;

  const PdfLocalizationData({
    required this.serviceCreationError,
    required this.raceServiceCreationError,
    required this.unsupportedModelType,
    required this.pdfGenerationError,
    required this.fontLoadTimeout,
    required this.settingsLoadError,
    required this.settingsSaveError,
    required this.characterProfileTitle,
    required this.raceProfileTitle,
    required this.basicInfo,
    required this.name,
    required this.age,
    required this.gender,
    required this.race,
    required this.description,
    required this.biography,
    required this.personality,
    required this.appearance,
    required this.abilities,
    required this.other,
    required this.referenceImage,
    required this.customFields,
    required this.additionalImages,
    required this.biology,
    required this.backstory,
  });

  factory PdfLocalizationData.russian() {
    return const PdfLocalizationData(
      serviceCreationError: 'Ошибка создания сервиса для персонажа',
      raceServiceCreationError: 'Ошибка создания сервиса для расы',
      unsupportedModelType: 'Неподдерживаемый тип модели для экспорта PDF',
      pdfGenerationError: 'Ошибка генерации PDF',
      fontLoadTimeout: 'Таймаут загрузки шрифта',
      settingsLoadError: 'Ошибка загрузки настроек PDF',
      settingsSaveError: 'Ошибка сохранения настроек PDF',
      characterProfileTitle: 'Характеристика персонажа',
      raceProfileTitle: 'Описание расы',
      basicInfo: 'Основная информация',
      name: 'Название',
      age: 'Возраст',
      gender: 'Пол',
      race: 'Раса',
      description: 'Описание',
      biography: 'Биография',
      personality: 'Характер',
      appearance: 'Внешность',
      abilities: 'Способности',
      other: 'Другое',
      referenceImage: 'Референс изображение',
      customFields: 'Дополнительные поля',
      additionalImages: 'Дополнительные изображения',
      biology: 'Биология',
      backstory: 'История',
    );
  }

  factory PdfLocalizationData.english() {
    return const PdfLocalizationData(
      serviceCreationError: 'Error creating service for character',
      raceServiceCreationError: 'Error creating service for race',
      unsupportedModelType: 'Unsupported model type for PDF export',
      pdfGenerationError: 'PDF generation error',
      fontLoadTimeout: 'Font load timeout',
      settingsLoadError: 'PDF settings load error',
      settingsSaveError: 'PDF settings save error',
      characterProfileTitle: 'Character Profile',
      raceProfileTitle: 'Race Description',
      basicInfo: 'Basic Information',
      name: 'Name',
      age: 'Age',
      gender: 'Gender',
      race: 'Race',
      description: 'Description',
      biography: 'Biography',
      personality: 'Personality',
      appearance: 'Appearance',
      abilities: 'Abilities',
      other: 'Other',
      referenceImage: 'Reference Image',
      customFields: 'Custom Fields',
      additionalImages: 'Additional Images',
      biology: 'Biology',
      backstory: 'Backstory',
    );
  }

  static PdfLocalizationData defaultLocalization() =>
      PdfLocalizationData.russian();
}
