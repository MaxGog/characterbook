import 'package:characterbook/data/models/character_model.dart';
import 'package:characterbook/data/models/race_model.dart';
import 'package:characterbook/data/models/template_model.dart';
import 'package:characterbook/providers/locale_provider.dart';
import 'package:characterbook/providers/theme_provider.dart';
import 'package:characterbook/services/backup_service.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsController extends ChangeNotifier {
  final LocaleProvider localeProvider;
  final ThemeProvider themeProvider;
  final FilePickerService filePickerService;
  final CloudBackupService cloudBackupService;
  final LocalBackupService localBackupService;

  SettingsController({
    required this.localeProvider,
    required this.themeProvider,
    required this.filePickerService,
    required this.cloudBackupService,
    required this.localBackupService,
  });

  Locale get locale => localeProvider.locale;
  void setLocale(Locale locale) {
    localeProvider.setLocale(locale);
    notifyListeners();
  }

  ThemeMode get themeMode => themeProvider.themeMode;
  void setThemeMode(ThemeMode mode) {
    themeProvider.setThemeMode(mode);
    notifyListeners();
  }

  Color get seedColor => themeProvider.seedColor;
  void setSeedColor(Color color) {
    themeProvider.setSeedColor(color);
    notifyListeners();
  }

  Future<void> importCharacter(BuildContext context) async {
    try {
      final character = await filePickerService.importCharacter();
      if (character != null) {
        final box = await Hive.openBox<Character>('characters');
        await box.add(character);
        _showSnackBar(context, 'Персонаж "${character.name}" импортирован');
      }
    } catch (e) {
      _showSnackBar(context, 'Ошибка импорта персонажа: $e');
    }
  }

  Future<void> importRace(BuildContext context) async {
    try {
      final race = await filePickerService.importRace();
      if (race != null) {
        final box = await Hive.openBox<Race>('races');
        final existing = box.values.firstWhere(
          (r) => r.name == race.name,
          orElse: () => Race.empty(),
        );
        if (existing.key != null) {
          final replace = await _showReplaceDialog(
            context,
            'Раса уже существует',
            'Заменить расу "${race.name}"?',
          );
          if (replace != true) return;
          await box.put(existing.key, race);
        } else {
          await box.add(race);
        }
        _showSnackBar(context, 'Раса "${race.name}" импортирована');
      }
    } catch (e) {
      _showSnackBar(context, 'Ошибка импорта расы: $e');
    }
  }

  Future<void> importTemplate(BuildContext context) async {
    try {
      final template = await filePickerService.importTemplate();
      if (template != null) {
        final box = await Hive.openBox<QuestionnaireTemplate>('templates');
        if (box.containsKey(template.name)) {
          final replace = await _showReplaceDialog(
            context,
            'Шаблон уже существует',
            'Заменить шаблон "${template.name}"?',
          );
          if (replace != true) return;
        }
        await box.put(template.name, template);
        _showSnackBar(context, 'Шаблон "${template.name}" импортирован');
      }
    } catch (e) {
      _showSnackBar(context, 'Ошибка импорта шаблона: $e');
    }
  }

  Future<bool?> _showReplaceDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Заменить'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  bool _isLocalBackupExporting = false;
  bool _isLocalBackupImporting = false;
  bool _isCloudBackupExporting = false;
  bool _isCloudBackupImporting = false;

  bool get isLocalBackupExporting => _isLocalBackupExporting;
  bool get isLocalBackupImporting => _isLocalBackupImporting;
  bool get isCloudBackupExporting => _isCloudBackupExporting;
  bool get isCloudBackupImporting => _isCloudBackupImporting;

  Future<void> exportLocalBackup() async {
    if (_isLocalBackupExporting) return;
    _setLocalBackupExporting(true);
    try {
      await localBackupService.exportData();
    } catch (e) {

    } finally {
      _setLocalBackupExporting(false);
    }
  }

  Future<void> importLocalBackup() async {
    if (_isLocalBackupImporting) return;
    _setLocalBackupImporting(true);
    try {
      await localBackupService.importData();
    } catch (e) {

    } finally {
      _setLocalBackupImporting(false);
    }
  }

  Future<void> exportCloudBackup() async {
    if (_isCloudBackupExporting) return;
    _setCloudBackupExporting(true);
    try {
      await cloudBackupService.exportData();
    } catch (e) {

    } finally {
      _setCloudBackupExporting(false);
    }
  }

  Future<void> importCloudBackup() async {
    if (_isCloudBackupImporting) return;
    _setCloudBackupImporting(true);
    try {
      await cloudBackupService.importData();
    } catch (e) {

    } finally {
      _setCloudBackupImporting(false);
    }
  }

  void _setLocalBackupExporting(bool value) {
    if (_isLocalBackupExporting == value) return;
    _isLocalBackupExporting = value;
    notifyListeners();
  }

  void _setLocalBackupImporting(bool value) {
    if (_isLocalBackupImporting == value) return;
    _isLocalBackupImporting = value;
    notifyListeners();
  }

  void _setCloudBackupExporting(bool value) {
    if (_isCloudBackupExporting == value) return;
    _isCloudBackupExporting = value;
    notifyListeners();
  }

  void _setCloudBackupImporting(bool value) {
    if (_isCloudBackupImporting == value) return;
    _isCloudBackupImporting = value;
    notifyListeners();
  }
}
