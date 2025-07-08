import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:characterbook/ui/widgets/backup_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/cloud_backup_service.dart';
import '../../generated/l10n.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.settings),
        centerTitle: false,
        scrolledUnderElevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _LanguageSection(s: s),
          const SizedBox(height: 8),
          _ThemeSection(themeProvider: themeProvider, s: s),
          const SizedBox(height: 8),
          _ImportSection(s: s),
          const SizedBox(height: 8),
          _BackupSection(s: s),
          const SizedBox(height: 8),
          _AboutSection(s: s),
          const SizedBox(height: 8),
          _AcknowledgementsSection(s: s),
        ],
      ),
    );
  }
}

class _LanguageSection extends StatelessWidget {
  final S s;

  const _LanguageSection({required this.s});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return _SettingsSection(
      title: s.appLanguage,
      children: [
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(s.language),
          trailing: DropdownButton<Locale>(
            value: localeProvider.locale,
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                localeProvider.setLocale(newLocale);
              }
            },
            items: S.delegate.supportedLocales.map((Locale locale) {
              return DropdownMenuItem<Locale>(
                value: locale,
                child: Text(
                  _displayName(locale),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }).toList(),
            underline: Container(),
            borderRadius: BorderRadius.circular(12),
            dropdownColor: colorScheme.surfaceContainerHigh,
            icon: Icon(
              Icons.arrow_drop_down,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  String _displayName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru': return 'Русский';
      case 'en': return 'English';
      default: return locale.languageCode;
    }
  }
}

class _ThemeSection extends StatelessWidget {
  final ThemeProvider themeProvider;
  final S s;

  const _ThemeSection({
    required this.themeProvider,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColors = {
      s.blue: Colors.blue,
      s.green: Colors.green,
      s.red: Colors.red,
      s.orange: Colors.orange,
      s.purple: Colors.purple,
      s.pink: Colors.pink,
      s.teal: Colors.teal,
      s.lightBlue: Colors.lightBlue,
    };

    return _SettingsSection(
      title: s.theme,
      children: [
        _ThemeListTile(
          themeProvider: themeProvider,
          mode: ThemeMode.system,
          title: s.system,
          icon: Icons.phone_android,
        ),
        _ThemeListTile(
          themeProvider: themeProvider,
          mode: ThemeMode.light,
          title: s.light,
          icon: Icons.light_mode,
        ),
        _ThemeListTile(
          themeProvider: themeProvider,
          mode: ThemeMode.dark,
          title: s.dark,
          icon: Icons.dark_mode,
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 16),
        Text(
          s.accentColor.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: accentColors.entries.map((entry) =>
              _ColorChoiceChip(
                themeProvider: themeProvider,
                entry: entry,
                colorScheme: colorScheme,
              )
          ).toList(),
        ),
      ],
    );
  }
}

class _ThemeListTile extends StatelessWidget {
  final ThemeProvider themeProvider;
  final ThemeMode mode;
  final String title;
  final IconData icon;

  const _ThemeListTile({
    required this.themeProvider,
    required this.mode,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Radio<ThemeMode>(
        value: mode,
        groupValue: themeProvider.themeMode,
        onChanged: (value) {
          if (value != null) themeProvider.setThemeMode(value);
        },
      ),
      onTap: () => themeProvider.setThemeMode(mode),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _ColorChoiceChip extends StatelessWidget {
  final ThemeProvider themeProvider;
  final MapEntry<String, Color> entry;
  final ColorScheme colorScheme;

  const _ColorChoiceChip({
    required this.themeProvider,
    required this.entry,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(entry.key),
      selected: themeProvider.seedColor == entry.value,
      onSelected: (_) => themeProvider.setSeedColor(entry.value),
      selectedColor: entry.value,
      labelStyle: TextStyle(
        color: themeProvider.seedColor == entry.value
            ? entry.value.contrastTextColor
            : colorScheme.onSurface,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      pressElevation: 0,
    );
  }
}

class _ImportSection extends StatelessWidget {
  final S s;

  const _ImportSection({required this.s});

  @override
  Widget build(BuildContext context) {
    return _SettingsSection(
      title: s.import,
      children: [
        _ImportButton(
          icon: Icons.person,
          label: s.import_character,
          onPressed: () => _importCharacter(context),
        ),
        _ImportButton(
          icon: Icons.people,
          label: s.import_race,
          onPressed: () => _importRace(context),
        ),
        _ImportButton(
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

class _ImportButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ImportButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _BackupSection extends StatelessWidget {
  final S s;

  const _BackupSection({required this.s});

  @override
  Widget build(BuildContext context) {
    return _SettingsSection(
      title: s.backup,
      children: [
        Center(
          child: BackupButtons(cloudBackupService: CloudBackupService()),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  final S s;

  const _AboutSection({required this.s});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _SettingsSection(
      title: s.aboutApp,
      children: [
        ListTile(
          leading: const Icon(Icons.title),
          title: Text(s.name),
          trailing: Text(
            s.app_name,
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.developer_mode),
          title: Text(s.developer),
          trailing: Text(
            'Максим Гоглов',
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(s.version),
          trailing: Text(
            '1.6.4',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _launchUrl('https://github.com/MaxGog/CharacterBook'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Image.asset('assets/underdeveloped.png'),
                  const SizedBox(height: 8),
                  Text(
                    s.githubRepo,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}

class _AcknowledgementsSection extends StatelessWidget {
  final S s;

  const _AcknowledgementsSection({required this.s});

  @override
  Widget build(BuildContext context) {
    return _SettingsSection(
      title: s.acknowledgements,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Данила Ганьков | Makoto🐼 | Максим Семенков | Артём Голубев | '
                'Евгений Стратий | Никита Жевнерович | Участники EnA',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

extension ColorExtension on Color {
  Color get contrastTextColor {
    final brightness = ThemeData.estimateBrightnessForColor(this);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }
}