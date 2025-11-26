import 'package:characterbook/services/hive_service.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:characterbook/models/characters/character_model.dart';
import 'package:characterbook/models/settings/export_pdf_settings_model.dart';

class PdfExportService {
  static const String _regularFontPath = 'assets/fonts/NotoSans-Regular.ttf';
  static const String _boldFontPath = 'assets/fonts/NotoSans-Bold.ttf';

  final Character character;
  final ExportPdfSettings settings;

  static const String _settingsKey = 'export_pdf_settings';

  PdfExportService({
    required this.character,
    required this.settings,
  });

  Future<ExportPdfSettings> getSettings() async {
    final box = await HiveService.getBox<ExportPdfSettings>('pdf_settings');
    return box.get(_settingsKey) ?? ExportPdfSettings();
  }

  Future<void> saveSettings(ExportPdfSettings settings) async {
    final box = await HiveService.getBox<ExportPdfSettings>('pdf_settings');
    await box.put(_settingsKey, settings);
  }

  Future<Uint8List> generatePdf() async {
    final font = await _loadFont(_regularFontPath);
    final boldFont = await _loadFont(_boldFontPath);
    final theme = pw.ThemeData.withFont(base: font, bold: boldFont);

    final pdf = pw.Document();

    _addMainPage(pdf, theme);
    _addOptionalSections(pdf, theme);

    return await pdf.save();
  }

  void _addMainPage(pw.Document pdf, pw.ThemeData theme) {
    if (!settings.includeBasicInfo) return;

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Характеристика персонажа',
              style: pw.TextStyle(
                fontSize: settings.titleFontSize,
                fontWeight: pw.FontWeight.bold,
                color: _parsePdfColor(settings.titleColor),
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          if (character.imageBytes != null &&
              settings.includeCharacterImage) ...[
            _buildImage(character.imageBytes!),
            pw.SizedBox(height: 20),
          ],
          _buildSection('Основная информация', [
            _buildInfoRow('Имя:', character.name),
            _buildInfoRow('Возраст:', character.age.toString()),
            if (character.gender.isNotEmpty)
              _buildInfoRow('Пол:', character.gender),
            if (character.race != null)
              _buildInfoRow('Раса:', character.race!.name),
          ]),
        ],
      ),
    );
  }

  void _addOptionalSections(pw.Document pdf, pw.ThemeData theme) {
    final sections = [
      _Section('Биография', character.biography, settings.includeBiography),
      _Section('Характер', character.personality, settings.includePersonality),
      _Section('Внешность', character.appearance, settings.includeAppearance),
      _Section('Способности', character.abilities, settings.includeAbilities),
      _Section('Другое', character.other, settings.includeOther),
    ];

    for (final section in sections) {
      if (section.include && section.content.isNotEmpty) {
        _addTextSection(pdf, theme, section.title, section.content);
      }
    }

    if (settings.includeReferenceImage &&
        character.referenceImageBytes != null) {
      _addImageSection(
          pdf, theme, 'Референс изображение', character.referenceImageBytes!);
    }

    if (settings.includeCustomFields && character.customFields.isNotEmpty) {
      _addCustomFieldsSection(pdf, theme);
    }

    if (settings.includeAdditionalImages &&
        character.additionalImages.isNotEmpty) {
      _addAdditionalImagesSection(pdf, theme);
    }
  }

  void _addTextSection(
      pw.Document pdf, pw.ThemeData theme, String title, String content) {
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) => [
          pw.Header(
            level: 1,
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: settings.titleFontSize,
                color: _parsePdfColor(settings.titleColor),
              ),
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
      ),
    );
  }

  void _addImageSection(
      pw.Document pdf, pw.ThemeData theme, String title, Uint8List imageBytes) {
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) => [
          pw.Header(
            level: 1,
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: settings.titleFontSize,
                color: _parsePdfColor(settings.titleColor),
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          _buildImage(imageBytes),
        ],
      ),
    );
  }

  void _addCustomFieldsSection(pw.Document pdf, pw.ThemeData theme) {
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) => [
          pw.Header(
            level: 1,
            child: pw.Text(
              'Дополнительные поля',
              style: pw.TextStyle(
                fontSize: settings.titleFontSize,
                color: _parsePdfColor(settings.titleColor),
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          ...character.customFields
              .map((field) => _buildInfoRow('${field.key}:', field.value)),
        ],
      ),
    );
  }

  void _addAdditionalImagesSection(pw.Document pdf, pw.ThemeData theme) {
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) => [
          pw.Header(
            level: 1,
            child: pw.Text(
              'Дополнительные изображения',
              style: pw.TextStyle(
                fontSize: settings.titleFontSize,
                color: _parsePdfColor(settings.titleColor),
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          ...character.additionalImages.map((imageBytes) => pw.Column(
              children: [_buildImage(imageBytes), pw.SizedBox(height: 20)])),
        ],
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
        width: 300,
        height: 300,
      ),
    );
  }

  Future<pw.Font> _loadFont(String path) async {
    try {
      final fontData = await rootBundle.load(path);
      return pw.Font.ttf(fontData);
    } catch (e) {
      if (kDebugMode) {
        print('Ошибка загрузки шрифта $path: $e');
      }
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
  final String content;
  final bool include;

  _Section(this.title, this.content, this.include);
}
