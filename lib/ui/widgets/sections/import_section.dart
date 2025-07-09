import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/widgets/import_button_widget.dart';
import 'package:characterbook/ui/widgets/sections/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:characterbook/services/file_picker_service.dart';

class ImportSection extends StatelessWidget {
  const ImportSection({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SettingsSection(
      title: s.import,
      children: [
        ImportButton(
          icon: Icons.person,
          label: s.import_character,
          onPressed: () => _importCharacter(context),
        ),
        ImportButton(
          icon: Icons.people,
          label: s.import_race,
          onPressed: () => _importRace(context),
        ),
        ImportButton(
          icon: Icons.list_alt,
          label: s.import_template,
          onPressed: () => _importTemplate(context),
        ),
      ],
    );
  }

  Future<void> _importCharacter(BuildContext context) async {
    try {
      final filePicker = FilePickerService();
      final character = await filePicker.importCharacter();
      if (character != null && context.mounted) {
        final box = await Hive.openBox<Character>('characters');
        await box.add(character);
        _showSnackBar(context, 'Персонаж "${character.name}" успешно импортирован');
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Ошибка импорта персонажа: ${e.toString()}');
      }
    }
  }

  Future<void> _importRace(BuildContext context) async {
    try {
      final filePicker = FilePickerService();
      final race = await filePicker.importRace();
      if (race != null && context.mounted) {
        final box = await Hive.openBox<Race>('races');
        final existingRace = box.values.firstWhere(
          (r) => r.name == race.name,
          orElse: () => Race.empty(),
        );
        
        if (existingRace.key != null) {
          final shouldReplace = await _showReplaceDialog(
            context,
            title: 'Раса уже существует',
            content: 'Заменить расу "${race.name}"?',
          );
          
          if (shouldReplace != true) return;
          await box.put(existingRace.key, race);
        } else {
          await box.add(race);
        }
        
        _showSnackBar(context, 'Раса "${race.name}" успешно импортирована');
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Ошибка импорта расы: ${e.toString()}');
      }
    }
  }

  Future<void> _importTemplate(BuildContext context) async {
    try {
      final filePicker = FilePickerService();
      final template = await filePicker.importTemplate();
      if (template != null && context.mounted) {
        final box = await Hive.openBox<QuestionnaireTemplate>('templates');
        
        if (box.containsKey(template.name)) {
          final shouldReplace = await _showReplaceDialog(
            context,
            title: 'Шаблон уже существует',
            content: 'Заменить шаблон "${template.name}"?',
          );
          
          if (shouldReplace != true) return;
        }
        
        await box.put(template.name, template);
        _showSnackBar(context, 'Шаблон "${template.name}" успешно импортирован');
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Ошибка импорта шаблона: ${e.toString()}');
      }
    }
  }

  Future<bool?> _showReplaceDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
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
}