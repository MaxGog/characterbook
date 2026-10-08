import 'package:flutter/material.dart';
import 'package:characterbook/features/settings/domain/settings_actions.dart';

class ThemeListTile extends StatelessWidget {
  final ThemeSettingsActions themeProvider;
  final ThemeMode mode;
  final String title;
  final IconData icon;

  const ThemeListTile({
    super.key,
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