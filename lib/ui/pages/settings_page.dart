import 'package:characterbook/ui/widgets/backup_buttons_widget.dart';
import 'package:flutter/material.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
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
          _buildLanguageSection(context, colorScheme, s),
          const SizedBox(height: 8),
          _buildThemeSection(context, themeProvider, colorScheme, s),
          const SizedBox(height: 8),
          _buildBackupSection(context, colorScheme, s),
          const SizedBox(height: 8),
          _buildAboutSection(context, colorScheme, s),
          const SizedBox(height: 8),
          _buildAcknowledgementsSection(context, colorScheme, s),
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, ThemeProvider themeProvider, ColorScheme colorScheme, S s) {
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
                s.theme.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildThemeListTile(themeProvider, ThemeMode.system, s.system, Icons.phone_android),
            _buildThemeListTile(themeProvider, ThemeMode.light, s.light, Icons.light_mode),
            _buildThemeListTile(themeProvider, ThemeMode.dark, s.dark, Icons.dark_mode),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                s.accentColor.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: accentColors.entries.map((entry) =>
                  _buildColorChoiceChip(themeProvider, entry, colorScheme)
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeListTile(
      ThemeProvider themeProvider,
      ThemeMode mode,
      String title,
      IconData icon
      ) {
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

  Widget _buildColorChoiceChip(
      ThemeProvider themeProvider,
      MapEntry<String, Color> entry,
      ColorScheme colorScheme
      ) {
    return ChoiceChip(
      label: Text(entry.key),
      selected: themeProvider.seedColor == entry.value,
      onSelected: (_) => themeProvider.setSeedColor(entry.value),
      selectedColor: entry.value,
      labelStyle: TextStyle(
        color: themeProvider.seedColor == entry.value ?
        entry.value.contrastTextColor : colorScheme.onSurface,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      pressElevation: 0,
    );
  }

  Widget _buildBackupSection(BuildContext context, ColorScheme colorScheme, S s) {
    final cloudBackupService = CloudBackupService();

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
                s.backup.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: BackupButtons(cloudBackupService: cloudBackupService),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, ColorScheme colorScheme, S s) {
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
                s.aboutApp.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
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
              trailing: FutureBuilder<String>(
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? '1.6.3',
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                }, future: null,
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
        ),
      ),
    );
  }

  Widget _buildAcknowledgementsSection(BuildContext context, ColorScheme colorScheme, S s) {
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
                s.acknowledgements.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Данила Ганьков | Makoto🐼 | Максим Семенков | Артём Голубев | '
                    'Евгений Стратий | Никита Жевнерович | Участники EnA',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, ColorScheme colorScheme, S s) {
    final localeProvider = Provider.of<LocaleProvider>(context);

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
                s.appLanguage.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
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
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  String _displayName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru': return 'Русский';
      case 'en': return 'English';
      default: return locale.languageCode;
    }
  }
}

extension ColorExtension on Color {
  Color get contrastTextColor {
    final brightness = ThemeData.estimateBrightnessForColor(this);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }
}