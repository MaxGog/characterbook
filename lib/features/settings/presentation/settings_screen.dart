import 'package:characterbook/ui/widgets/easter_egg_helper.dart';
import 'package:characterbook/ui/widgets/about_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/widgets/settings_section.dart';
import 'package:characterbook/features/settings/domain/settings_actions.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _showEasterEgg = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  title: Text(s.settings),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _LanguageSection(),
                        const SizedBox(height: 8),
                        _PreferencesSection(),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showEasterEgg = true;
                            });
                          },
                          child: _buildAboutSection(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_showEasterEgg)
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: EasterEggHelper(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final s = S.of(context);
    return SettingsSection(title: s.about, children: [AboutSection()]);
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
    final localeSettings = context.watch<LocaleSettingsActions>();
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return ListTile(
      leading: Icon(Icons.language, color: colorScheme.onSurfaceVariant),
      title: Text(s.language),
      trailing: SizedBox(
        width: 120,
        child: DropdownButton<Locale>(
          value: localeSettings.locale,
          onChanged: (Locale? newLocale) {
            if (newLocale != null) localeSettings.setLocale(newLocale);
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

class _PreferencesSection extends StatelessWidget {
  const _PreferencesSection();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return SettingsSection(
      title: s.settings,
      children: [
        _PreferenceTile(
          icon: Icons.palette_outlined,
          title: s.customize_theme,
          onTap: () => context.push('/settings/theme'),
        ),
        const SizedBox(height: 8),
        _PreferenceTile(
          icon: Icons.swipe,
          title: s.configureSwipeActions,
          onTap: () => context.push('/settings/swipe-actions'),
        ),
        const SizedBox(height: 8),
        _PreferenceTile(
          icon: Icons.picture_as_pdf,
          title: s.export_pdf_settings,
          onTap: () => context.push('/settings/export-pdf'),
        ),
        const SizedBox(height: 8),
        _PreferenceTile(
          icon: Icons.backup,
          title: s.backup,
          onTap: () => context.push('/settings/backup'),
        ),
      ],
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _PreferenceTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: colorScheme.onPrimaryContainer),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
