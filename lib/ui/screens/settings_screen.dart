import 'dart:async';
import 'package:characterbook/ui/widgets/sections/about_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/controllers/settings_controller.dart';
import 'package:characterbook/ui/widgets/sections/settings_section.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:characterbook/services/backup_service.dart';
import 'package:characterbook/providers/locale_provider.dart';
import 'package:characterbook/providers/theme_provider.dart';
import 'package:characterbook/ui/screens/calendar_page.dart';
import 'package:characterbook/ui/screens/export_pdf_settings_page.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsController _controller;

  @override
  void initState() {
    super.initState();
    final localeProvider = context.read<LocaleProvider>();
    final themeProvider = context.read<ThemeProvider>();
    final filePickerService = context.read<FilePickerService>();
    final cloudBackupService = context.read<CloudBackupService>();
    final localBackupService = context.read<LocalBackupService>();

    _controller = SettingsController(
      localeProvider: localeProvider,
      themeProvider: themeProvider,
      filePickerService: filePickerService,
      cloudBackupService: cloudBackupService,
      localBackupService: localBackupService,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            s.settings,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          centerTitle: false,
          titleSpacing: 24,
          scrolledUnderElevation: 3,
          shadowColor: theme.colorScheme.shadow,
          surfaceTintColor: Colors.transparent,
          backgroundColor: theme.colorScheme.surfaceContainerLowest,
          toolbarHeight: 80,
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
        ),
        body: ChangeNotifierProvider.value(
          value: _controller,
          child: const _SettingsBody(),
        ),
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: const [
        _LanguageSection(),
        SizedBox(height: 8),
        _ThemeSection(),
        SizedBox(height: 8),
        _ImportSection(),
        SizedBox(height: 8),
        _BackupSection(),
        SizedBox(height: 8),
        _CalendarSection(),
        SizedBox(height: 8),
        _ExportPdfSettingsSection(),
        SizedBox(height: 8),
        AboutSection(),
        SizedBox(height: 8),
        _AcknowledgementsSection(),
        SizedBox(height: 8),
        _LicensesSection(),
      ],
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SettingsSection(
      title: s.appLanguage,
      children: const [_LanguageSelector()],
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return ListTile(
      leading: Icon(Icons.language, color: colorScheme.onSurfaceVariant),
      title: Text(s.language),
      trailing: SizedBox(
        width: 120,
        child: DropdownButton<Locale>(
          value: controller.locale,
          onChanged: (Locale? newLocale) {
            if (newLocale != null) controller.setLocale(newLocale);
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
          selectedItemBuilder: (BuildContext context) {
            return S.delegate.supportedLocales.map<Widget>((Locale locale) {
              return Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _displayName(locale),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
          isExpanded: true,
          underline: Container(),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: colorScheme.surfaceContainerHigh,
          icon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.arrow_drop_down,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          iconSize: 24,
          alignment: Alignment.centerRight,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

String _displayName(Locale locale) {
  switch (locale.languageCode) {
    case 'ru':
      return 'Русский';
    case 'en':
      return 'English';
    default:
      return locale.languageCode;
  }
}

const _presetColors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.teal,
  Colors.lightBlue,
];

class _ThemeSection extends StatelessWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsSection(
      title: s.theme,
      children: [
        const _ThemeModeSelector(),
        const SizedBox(height: 8),
        Divider(height: 1, color: colorScheme.outlineVariant),
        const SizedBox(height: 16),
        Text(
          s.accentColor.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 12),
        const _AccentColorSelector(),
      ],
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        _ThemeListTile(
          mode: ThemeMode.system,
          title: s.system,
          icon: Icons.phone_android,
        ),
        _ThemeListTile(
          mode: ThemeMode.light,
          title: s.light,
          icon: Icons.light_mode,
        ),
        _ThemeListTile(
          mode: ThemeMode.dark,
          title: s.dark,
          icon: Icons.dark_mode,
        ),
      ],
    );
  }
}

class _ThemeListTile extends StatelessWidget {
  final ThemeMode mode;
  final String title;
  final IconData icon;

  const _ThemeListTile({
    required this.mode,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final isSelected = controller.themeMode == mode;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon,
          color:
              isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant),
      title: Text(title),
      trailing:
          isSelected ? Icon(Icons.check, color: colorScheme.primary) : null,
      onTap: () => controller.setThemeMode(mode),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _AccentColorSelector extends StatelessWidget {
  const _AccentColorSelector();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final s = S.of(context);
    final accentColors = {
      s.color_blue: Colors.blue,
      s.color_green: Colors.green,
      s.color_red: Colors.red,
      s.color_orange: Colors.orange,
      s.color_purple: Colors.purple,
      s.color_pink: Colors.pink,
      s.color_teal: Colors.teal,
      s.color_light_blue: Colors.lightBlue,
    };
    final currentColor = controller.seedColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...accentColors.entries.map((entry) => _ColorChoiceChip(
                  label: entry.key,
                  color: entry.value,
                  selected: currentColor == entry.value,
                  onSelected: (_) => controller.setSeedColor(entry.value),
                )),
          ],
        ),
        const SizedBox(height: 12),
        _CustomColorButton(
          currentColor: currentColor,
          onColorSelected: (color) => controller.setSeedColor(color),
        ),
      ],
    );
  }
}

class _ColorChoiceChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _ColorChoiceChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: color.withOpacity(0.2),
      selectedColor: color,
      labelStyle: TextStyle(
        color: selected ? Colors.white : null,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _CustomColorButton extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;

  const _CustomColorButton({
    required this.currentColor,
    required this.onColorSelected,
  });

  bool get _isCustomColor => !_presetColors.contains(currentColor);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _isCustomColor;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          final pickedColor = await showDialog<Color>(
            context: context,
            builder: (context) =>
                _ColorPickerDialog(initialColor: currentColor),
          );
          if (pickedColor != null) onColorSelected(pickedColor);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.color_lens, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  S.of(context).choose_color,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: currentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.primary, width: 2),
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const _ColorPickerDialog({required this.initialColor});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(S.of(context).choose_color),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8,
              children: _presetColors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color
                            ? colorScheme.primary
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _selectedColor),
          child: Text(S.of(context).choose_color),
        ),
      ],
    );
  }
}

class _ImportSection extends StatelessWidget {
  const _ImportSection();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SettingsSection(
      title: s.import,
      children: [
        _ImportButton(
          icon: Icons.person,
          label: s.import_character,
          onPressed: () =>
              context.read<SettingsController>().importCharacter(context),
        ),
        _ImportButton(
          icon: Icons.people,
          label: s.import_race,
          onPressed: () =>
              context.read<SettingsController>().importRace(context),
        ),
        _ImportButton(
          icon: Icons.list_alt,
          label: s.import_template,
          onPressed: () =>
              context.read<SettingsController>().importTemplate(context),
        ),
      ],
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: colorScheme.onPrimaryContainer),
        ),
        title: Text(label),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: onPressed,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

class _BackupSection extends StatelessWidget {
  const _BackupSection();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SettingsSection(
      title: s.backup,
      children: const [_BackupButtons()],
    );
  }
}

class _BackupButtons extends StatelessWidget {
  const _BackupButtons();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();
    final s = S.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.backup_to_file, style: textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: controller.isLocalBackupExporting
                    ? null
                    : controller.exportLocalBackup,
                icon: controller.isLocalBackupExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.backup),
                label: Text(s.export),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.icon(
                onPressed: controller.isLocalBackupImporting
                    ? null
                    : controller.importLocalBackup,
                icon: controller.isLocalBackupImporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.restore),
                label: Text(s.import),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(s.backup_to_cloud, style: textTheme.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: controller.isCloudBackupExporting
                    ? null
                    : controller.exportCloudBackup,
                icon: controller.isCloudBackupExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.cloud_upload),
                label: Text(s.export),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.icon(
                onPressed: controller.isCloudBackupImporting
                    ? null
                    : controller.importCloudBackup,
                icon: controller.isCloudBackupImporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.cloud_download),
                label: Text(s.import),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CalendarSection extends StatelessWidget {
  const _CalendarSection();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsSection(
      title: s.calendar,
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            s.calendar_statistics,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CalendarPage()),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

class _ExportPdfSettingsSection extends StatelessWidget {
  const _ExportPdfSettingsSection();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsSection(
      title: s.export_pdf_settings,
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.picture_as_pdf,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            s.export_pdf_settings,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ExportPdfSettingsPage()),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

class _AcknowledgementsSection extends StatelessWidget {
  const _AcknowledgementsSection();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SettingsSection(
      title: s.acknowledgements,
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            _buildContributorChip(context, 'Артём Голубев'),
            _buildContributorChip(context, 'Евгений Стратий'),
            _buildContributorChip(context, 'Максим Семенков'),
            _buildContributorChip(context, 'Makoto🐼'),
            _buildContributorChip(context, 'Александр Черняев'),
            _buildContributorChip(context, 'Мария Война'),
            _buildContributorChip(context, 'Дарья Воробьёва'),
            _buildContributorChip(context, 'Никита Жевнерович'),
            _buildContributorChip(context, 'KellSmiley'),
            _buildContributorChip(context, 'Участники EnA'),
          ],
        ),
      ],
    );
  }

  Widget _buildContributorChip(BuildContext context, String name) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(
        name,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      backgroundColor: theme.colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _LicensesSection extends StatelessWidget {
  const _LicensesSection();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsSection(
      title: s.licenses,
      children: [
        ListTile(
          leading: Icon(Icons.code, color: colorScheme.onSurfaceVariant),
          title: Text(s.flutterLicense),
          onTap: () => _launchUrl(
              'https://github.com/flutter/flutter/blob/master/LICENSE'),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.article, color: colorScheme.onSurfaceVariant),
          title: Text(s.characterbookLicense),
          onTap: () => _launchUrl('https://www.gnu.org/licenses/gpl-3.0.html'),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.list, color: colorScheme.onSurfaceVariant),
          title: Text(s.usedLibraries),
          onTap: () => showLicensePage(
            context: context,
            applicationName: s.app_name,
            applicationVersion: '1.8.0',
            applicationIcon:
                Image.asset('assets/iconapp.png', width: 50, height: 50),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
