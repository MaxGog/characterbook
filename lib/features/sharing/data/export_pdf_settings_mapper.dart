import 'package:characterbook/features/sharing/domain/export_pdf_settings.dart';
import 'package:characterbook/features/sharing/data/export_pdf_settings_record.dart';

class ExportPdfSettingsMapper {
  const ExportPdfSettingsMapper();

  ExportPdfSettings toDomain(ExportPdfSettingsRecord record) =>
      ExportPdfSettings(
        includeBasicInfo: record.includeBasicInfo,
        includeBiography: record.includeBiography,
        includePersonality: record.includePersonality,
        includeAppearance: record.includeAppearance,
        includeAbilities: record.includeAbilities,
        includeOther: record.includeOther,
        includeCustomFields: record.includeCustomFields,
        includeReferenceImage: record.includeReferenceImage,
        includeAdditionalImages: record.includeAdditionalImages,
        titleFontSize: record.titleFontSize,
        bodyFontSize: record.bodyFontSize,
        titleColor: record.titleColor,
        bodyColor: record.bodyColor,
        includeCharacterImage: record.includeCharacterImage,
      );

  ExportPdfSettingsRecord toRecord(ExportPdfSettings settings) =>
      ExportPdfSettingsRecord(
        includeBasicInfo: settings.includeBasicInfo,
        includeBiography: settings.includeBiography,
        includePersonality: settings.includePersonality,
        includeAppearance: settings.includeAppearance,
        includeAbilities: settings.includeAbilities,
        includeOther: settings.includeOther,
        includeCustomFields: settings.includeCustomFields,
        includeReferenceImage: settings.includeReferenceImage,
        includeAdditionalImages: settings.includeAdditionalImages,
        titleFontSize: settings.titleFontSize,
        bodyFontSize: settings.bodyFontSize,
        titleColor: settings.titleColor,
        bodyColor: settings.bodyColor,
        includeCharacterImage: settings.includeCharacterImage,
      );
}
