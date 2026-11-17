import 'dart:async';

import 'package:characterbook/features/sharing/application/pdf_export_actions.dart';
import 'package:characterbook/features/sharing/application/pdf_localization_data.dart';
import 'package:flutter/services.dart';
import 'package:characterbook/features/characters/domain/character_model.dart';
import 'package:characterbook/features/races/domain/race_model.dart';
import 'package:characterbook/features/sharing/domain/export_pdf_settings.dart';
import 'package:characterbook/features/sharing/data/export_pdf_settings_record.dart';
import 'package:characterbook/features/sharing/data/export_pdf_settings_mapper.dart';
import 'package:characterbook/features/sharing/domain/export_pdf_settings_actions.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart' as pw;

class PdfExportService implements PdfExportDocument {
  static const String _regularFontPath = 'assets/fonts/NotoSans-Regular.ttf';
  static const String _boldFontPath = 'assets/fonts/NotoSans-Bold.ttf';

  final Object model;
  final ExportPdfSettings settings;
  final PdfLocalizationData localization;
  final Completer<Uint8List> _completer = Completer<Uint8List>();

  PdfExportService({
    required this.model,
    required this.settings,
    required this.localization,
  });

  static Future<PdfExportService> createForCharacter(
    Character character,
    PdfLocalizationData localization, {
    required ExportPdfSettingsActions settingsActions,
  }) async {
    try {
      final settings = await settingsActions.getSettings();
      return PdfExportService(
        model: character,
        settings: settings,
        localization: localization,
      );
    } catch (e) {
      throw Exception('${localization.serviceCreationError}: ${e.toString()}');
    }
  }

  static Future<PdfExportService> createForRace(
    Race race,
    PdfLocalizationData localization, {
    required ExportPdfSettingsActions settingsActions,
  }) async {
    try {
      final settings = await settingsActions.getSettings();
      return PdfExportService(
        model: race,
        settings: settings,
        localization: localization,
      );
    } catch (e) {
      throw Exception(
          '${localization.raceServiceCreationError}: ${e.toString()}');
    }
  }

  static Future<PdfExportService> createWithCustomSettings(
    Object model,
    ExportPdfSettings settings,
    PdfLocalizationData localization,
  ) async {
    return PdfExportService(
      model: model,
      settings: settings,
      localization: localization,
    );
  }

  @override
  Future<Uint8List> generatePdf() async {
    try {
      final font = await _loadFont(_regularFontPath);
      final boldFont = await _loadFont(_boldFontPath);

      final theme = pw.ThemeData.withFont(base: font, bold: boldFont);
      final pdf = pw.Document();

      Map<String, dynamic> exportData;
      if (model is Character) {
        exportData = _characterToExportMap(model as Character);
      } else if (model is Race) {
        exportData = _raceToExportMap(model as Race);
      } else {
        throw Exception(localization.unsupportedModelType);
      }

      _addMainPage(pdf, theme, exportData);

      _addOptionalSections(pdf, theme, exportData);

      final result = await pdf.save();

      if (!_completer.isCompleted) {
        _completer.complete(result);
      }

      return result;
    } catch (e) {
      if (!_completer.isCompleted) {
        _completer.completeError(e);
      }
      throw Exception('${localization.pdfGenerationError}: ${e.toString()}');
    }
  }

  Map<String, dynamic> _characterToExportMap(Character character) {
    return {
      'type': 'character',
      'id': character.id,
      'name': character.name,
      'description': character.biography,
      'mainImage': character.imageBytes,
      'additionalImages': character.additionalImages,
      'tags': character.tags,
      'lastEdited': character.lastEdited,
      'details': {
        'age': character.age,
        'gender': character.gender,
        'biography': character.biography,
        'personality': character.personality,
        'appearance': character.appearance,
        'abilities': character.abilities,
        'other': character.other,
        'race': character.race?.name,
        'customFields': character.customFields
            .map((f) => {'key': f.key, 'value': f.value})
            .toList(),
        'referenceImage': character.referenceImageBytes,
      }
    };
  }

  Map<String, dynamic> _raceToExportMap(Race race) {
    return {
      'type': 'race',
      'id': race.id,
      'name': race.name,
      'description': race.description,
      'mainImage': race.logo,
      'additionalImages': race.additionalImages,
      'tags': race.tags,
      'lastEdited': race.lastEdited,
      'details': {
        'biology': race.biology,
        'backstory': race.backstory,
        'description': race.description,
      }
    };
  }

  void _addMainPage(
      pw.Document pdf, pw.ThemeData theme, Map<String, dynamic> data) {
    if (!settings.includeBasicInfo) return;

    final isCharacter = data['type'] == 'character';
    final title = isCharacter
        ? localization.characterProfileTitle
        : localization.raceProfileTitle;

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: settings.titleFontSize,
                  fontWeight: pw.FontWeight.bold,
                  color: _parsePdfColor(settings.titleColor),
                ),
              ),
              pw.SizedBox(height: 20),
              if (data['mainImage'] != null &&
                  settings.includeCharacterImage) ...[
                _buildImage(data['mainImage']!),
                pw.SizedBox(height: 20),
              ],
              _buildBasicInfoSection(data, isCharacter),
            ],
          );
        },
      ),
    );
  }

  pw.Widget _buildBasicInfoSection(
      Map<String, dynamic> data, bool isCharacter) {
    final details = data['details'] as Map<String, dynamic>;
    final infoRows = <pw.Widget>[
      _buildInfoRow('${localization.name}:', data['name']),
    ];

    if (isCharacter) {
      infoRows.addAll([
        if (details['age'] != null && details['age'].toString().isNotEmpty)
          _buildInfoRow('${localization.age}:', details['age'].toString()),
        if (details['gender'] != null &&
            details['gender'].toString().isNotEmpty)
          _buildInfoRow('${localization.gender}:', details['gender']),
        if (details['race'] != null && details['race'].toString().isNotEmpty)
          _buildInfoRow('${localization.race}:', details['race']),
      ]);
    }

    if (data['description'] != null &&
        data['description'].toString().isNotEmpty) {
      infoRows.add(
          _buildInfoRow('${localization.description}:', data['description']));
    }

    return _buildSection(localization.basicInfo, infoRows);
  }

  void _addOptionalSections(
      pw.Document pdf, pw.ThemeData theme, Map<String, dynamic> data) {
    final isCharacter = data['type'] == 'character';
    final details = data['details'] as Map<String, dynamic>;

    if (isCharacter) {
      _addCharacterSections(pdf, theme, details);
    } else {
      _addRaceSections(pdf, theme, details);
    }

    if (settings.includeCustomFields && details['customFields'] != null) {
      _addCustomFieldsSection(pdf, theme, details['customFields']);
    }

    if (settings.includeAdditionalImages && data['additionalImages'] != null) {
      _addAdditionalImagesSection(pdf, theme, data['additionalImages']);
    }
  }

  void _addCharacterSections(
      pw.Document pdf, pw.ThemeData theme, Map<String, dynamic> details) {
    final sections = [
      _Section(localization.biography, details['biography'],
          settings.includeBiography),
      _Section(localization.personality, details['personality'],
          settings.includePersonality),
      _Section(localization.appearance, details['appearance'],
          settings.includeAppearance),
      _Section(localization.abilities, details['abilities'],
          settings.includeAbilities),
      _Section(localization.other, details['other'], settings.includeOther),
    ];

    for (final section in sections) {
      if (section.include &&
          section.content != null &&
          section.content.toString().isNotEmpty) {
        _addTextSection(pdf, theme, section.title, section.content.toString());
      }
    }

    if (settings.includeReferenceImage && details['referenceImage'] != null) {
      _addImageSection(
          pdf, theme, localization.referenceImage, details['referenceImage']!);
    }
  }

  void _addRaceSections(
      pw.Document pdf, pw.ThemeData theme, Map<String, dynamic> details) {
    final sections = [
      _Section(
          localization.biology, details['biology'], settings.includeBiography),
      _Section(localization.backstory, details['backstory'],
          settings.includePersonality),
      _Section(localization.description, details['description'],
          settings.includeAppearance),
    ];

    for (final section in sections) {
      if (section.include &&
          section.content != null &&
          section.content.toString().isNotEmpty) {
        _addTextSection(pdf, theme, section.title, section.content.toString());
      }
    }
  }

  void _addTextSection(
      pw.Document pdf, pw.ThemeData theme, String title, String content) {
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: settings.titleFontSize,
                  color: _parsePdfColor(settings.titleColor),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                content,
                softWrap: true,
                style: pw.TextStyle(
                  fontSize: settings.bodyFontSize,
                  color: _parsePdfColor(settings.bodyColor),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addImageSection(
      pw.Document pdf, pw.ThemeData theme, String title, Uint8List imageBytes) {
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: settings.titleFontSize,
                  color: _parsePdfColor(settings.titleColor),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              _buildImage(imageBytes),
            ],
          );
        },
      ),
    );
  }

  void _addCustomFieldsSection(
      pw.Document pdf, pw.ThemeData theme, List<dynamic> customFields) {
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                localization.customFields,
                style: pw.TextStyle(
                  fontSize: settings.titleFontSize,
                  color: _parsePdfColor(settings.titleColor),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              ...customFields.map<pw.Widget>(
                (field) => _buildInfoRow('${field['key']}:', field['value']),
              ),
            ],
          );
        },
      ),
    );
  }

  void _addAdditionalImagesSection(
      pw.Document pdf, pw.ThemeData theme, List<Uint8List> images) {
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                localization.additionalImages,
                style: pw.TextStyle(
                  fontSize: settings.titleFontSize,
                  color: _parsePdfColor(settings.titleColor),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              ...images.map<pw.Widget>(
                (imageBytes) => pw.Column(
                  children: [
                    _buildImage(imageBytes),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  pw.Widget _buildSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 15),
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: settings.titleFontSize,
            fontWeight: pw.FontWeight.bold,
            color: _parsePdfColor(settings.titleColor),
          ),
        ),
        pw.Divider(),
        ...children,
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: settings.bodyFontSize,
              color: _parsePdfColor(settings.bodyColor),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Text(
              value,
              softWrap: true,
              style: pw.TextStyle(
                fontSize: settings.bodyFontSize,
                color: _parsePdfColor(settings.bodyColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildImage(Uint8List bytes) {
    return pw.Center(
      child: pw.Image(
        pw.MemoryImage(bytes),
        fit: pw.BoxFit.contain,
        width: 200,
        height: 200,
      ),
    );
  }

  Future<pw.Font> _loadFont(String path) async {
    try {
      final fontData = await rootBundle.load(path).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException(localization.fontLoadTimeout);
        },
      );
      return pw.Font.ttf(fontData);
    } catch (e) {
      return pw.Font.courier();
    }
  }

  pw.PdfColor _parsePdfColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      final r = int.parse(hexColor.substring(0, 2), radix: 16) / 255;
      final g = int.parse(hexColor.substring(2, 4), radix: 16) / 255;
      final b = int.parse(hexColor.substring(4, 6), radix: 16) / 255;
      return pw.PdfColor(r, g, b);
    } else {
      return pw.PdfColor(0, 0, 0);
    }
  }
}

class _Section {
  final String title;
  final dynamic content;
  final bool include;

  _Section(this.title, this.content, this.include);
}

class ExportPdfSettingsService implements ExportPdfSettingsActions {
  static const String _boxName = 'export_pdf_settings';
  static const String _settingsKey = 'settings';

  Future<Box<ExportPdfSettingsRecord>> get _box =>
      Hive.openBox<ExportPdfSettingsRecord>(_boxName);

  @override
  Future<ExportPdfSettings> getSettings() async {
    try {
      final box = await _box;
      final record = box.get(_settingsKey);
      return record == null
          ? ExportPdfSettings()
          : const ExportPdfSettingsMapper().toDomain(record);
    } catch (e) {
      throw Exception(
          '${PdfLocalizationData.defaultLocalization().settingsLoadError}: ${e.toString()}');
    }
  }

  @override
  Future<void> saveSettings(ExportPdfSettings settings) async {
    try {
      final box = await _box;
      await box.put(
        _settingsKey,
        const ExportPdfSettingsMapper().toRecord(settings),
      );
    } catch (e) {
      throw Exception(
          '${PdfLocalizationData.defaultLocalization().settingsSaveError}: ${e.toString()}');
    }
  }
}
