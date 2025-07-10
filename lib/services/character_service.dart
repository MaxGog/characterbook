import 'dart:convert';
import 'dart:io';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/dialogs/loading_dialog.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hive/hive.dart';
import '../models/character_model.dart';

class CharacterService {
  static const String _boxName = 'characters';
  static const String _regularFontPath = 'assets/fonts/NotoSans-Regular.ttf';
  static const String _boldFontPath = 'assets/fonts/NotoSans-Bold.ttf';

  final Character? character;

  CharacterService.forDatabase() : character = null;

  CharacterService.forExport(this.character);

  Future<Box<Character>> get _box => Hive.openBox<Character>(_boxName);

  Future<void> saveCharacter(Character character, {int? key}) async {
    final box = await _box;
    key != null ? await box.put(key, character) : await box.add(character);
  }

  Future<List<Character>> getAllCharacters() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> deleteCharacter(int key) async {
    final box = await _box;
    await box.delete(key);
  }

  Future<void> exportToPdf(context) async {
    if (character == null) throw Exception("Character is not set for export");
    showLoadingDialog(context: context, message: S.of(context).creating_pdf);

    await Future.delayed(const Duration(milliseconds: 50));

    try {
      final font = await _loadFont(_regularFontPath);
      final boldFont = await _loadFont(_boldFontPath);
      final theme = pw.ThemeData.withFont(base: font, bold: boldFont);

      final pdf = pw.Document();
      _addMainPage(pdf, theme);
      _addOptionalSections(pdf, theme);

      hideLoadingDialog(context);

      final bytes = await pdf.save();
      await _sharePdf(bytes);
    } catch (e) {
      throw Exception('Ошибка экспорта в PDF: ${e.toString()}');
    }
  }

  Future<pw.Font> _loadFont(String path) async {
    final fontData = await rootBundle.load(path);
    return pw.Font.ttf(fontData);
  }

  void _addMainPage(pw.Document pdf, pw.ThemeData theme) {
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Характеристика персонажа',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          if (character!.imageBytes != null) ...[
            _buildImage(character!.imageBytes!),
            pw.SizedBox(height: 20),
          ],
          _buildSection('Основная информация', [
            _buildInfoRow('Имя:', character!.name),
            _buildInfoRow('Возраст:', character!.age.toString()),
            if (character!.gender.isNotEmpty) _buildInfoRow('Пол:', character!.gender),
            if (character!.race != null) _buildInfoRow('Раса:', character!.race!.name),
          ]),
        ],
      ),
    );
  }

  void _addOptionalSections(pw.Document pdf, pw.ThemeData theme) {
    final sections = [
      _Section('Биография', character!.biography),
      _Section('Характер', character!.personality),
      _Section('Внешность', character!.appearance),
      _Section('Способности', character!.abilities),
      _Section('Другое', character!.other),
    ];

    for (final section in sections) {
      if (section.content.isNotEmpty) {
        _addTextSection(pdf, theme, section.title, section.content);
      }
    }

    if (character!.referenceImageBytes != null) {
      _addImageSection(pdf, theme, 'Референс изображение', character!.referenceImageBytes!);
    }

    if (character!.customFields.isNotEmpty) {
      _addCustomFieldsSection(pdf, theme);
    }

    if (character!.additionalImages.isNotEmpty) {
      _addAdditionalImagesSection(pdf, theme);
    }
  }

  void _addTextSection(pw.Document pdf, pw.ThemeData theme, String title, String content) {
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) => [
          pw.Header(
            level: 1,
            child: pw.Text(title),
          ),
          pw.SizedBox(height: 20),
          pw.Text(content, softWrap: true),
        ],
      ),
    );
  }

  void _addImageSection(pw.Document pdf, pw.ThemeData theme, String title, Uint8List imageBytes) {
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        theme: theme,
        build: (pw.Context context) => [
          pw.Header(
            level: 1,
            child: pw.Text(title),
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
            child: pw.Text('Дополнительные поля'),
          ),
          pw.SizedBox(height: 20),
          ...character!.customFields.map((field) => 
            _buildInfoRow('${field.key}:', field.value)
          ),
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
            child: pw.Text('Дополнительные изображения'),
          ),
          pw.SizedBox(height: 20),
          ...character!.additionalImages.map((imageBytes) => 
            pw.Column(children: [_buildImage(imageBytes), pw.SizedBox(height: 20)])
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

  pw.Widget _buildSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 15),
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        ...children,
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 10),
          pw.Expanded(child: pw.Text(value, softWrap: true)),
        ],
      ),
    );
  }

  Future<void> exportToJson(context) async {
    if (character == null) throw Exception("Character is not set for export");
    showLoadingDialog(context: context, message: S.of(context).creating_file);
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      final jsonStr = jsonEncode(character!.toJson());
      final fileName = '${character!.name}_${DateTime.now().millisecondsSinceEpoch}.character';

      hideLoadingDialog(context);

      await _shareFile(
        Uint8List.fromList(jsonStr.codeUnits),
        fileName,
        text: 'Персонаж: ${character!.name}',
      );
    } catch (e) {
      throw Exception('Ошибка экспорта в JSON: ${e.toString()}');
    }
  }

  Future<void> _sharePdf(Uint8List bytes) async {
    await _shareFile(
      bytes,
      '${character!.name}.pdf',
      text: 'Характеристика персонажа ${character!.name}',
      subject: 'PDF с характеристикой персонажа',
    );
  }

  Future<void> _shareFile(Uint8List bytes, String fileName, {String? text, String? subject}) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles(
      [XFile(file.path)],
      text: text,
      subject: subject,
    );
  }
}

class _Section {
  final String title;
  final String content;

  _Section(this.title, this.content);
}