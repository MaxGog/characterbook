import 'package:characterbook/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:characterbook/features/settings/domain/settings_actions.dart';

class ColorChoiceChip extends StatelessWidget {
  final ThemeSettingsActions themeProvider;
  final String label;
  final Color color;

  const ColorChoiceChip({
    super.key,
    required this.themeProvider,
    required this.label,
    required this.color, required bool selected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: themeProvider.seedColor == color,
      onSelected: (_) => themeProvider.setSeedColor(color),
      selectedColor: color,
      labelStyle: TextStyle(
        color: themeProvider.seedColor == color
            ? color.contrastTextColor
            : Theme.of(context).colorScheme.onSurface,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      pressElevation: 0,
    );
  }
}