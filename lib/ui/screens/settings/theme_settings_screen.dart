import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/providers/theme_provider.dart';
import 'package:characterbook/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  Future<void> _pickCustomColor(BuildContext context, Color currentColor) async {
    final selected = await showDialog<Color>(
      context: context,
      builder: (context) {
        var temp = currentColor;
        return AlertDialog(
          title: Text(S.of(context).choose_color),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (c) => temp = c,
              enableAlpha: false,
              labelTypes: const [],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, temp),
              child: Text(S.of(context).choose_color),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;
    if (selected != null) {
      context.read<ThemeProvider>().setSeedColor(selected);
    }
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
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text(s.theme),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _ThemePhonePreview(),
                    const SizedBox(height: 20),
                    _ThemeKeyColorTiles(onPickCustomColor: _pickCustomColor),
                    const SizedBox(height: 12),
                    const _ThemeModePills(),
                    const SizedBox(height: 12),
                    const _MaterialYouOptions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemePhonePreview extends StatelessWidget {
  const _ThemePhonePreview();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);
    final previewHeight = (MediaQuery.sizeOf(context).height * 0.42)
        .clamp(260.0, 360.0) as double;
    const designWidth = 252.0;
    const designHeight = 448.0;

    return SizedBox(
      height: previewHeight,
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: designWidth,
            height: designHeight,
            child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  s.app_name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 14),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: Icon(Icons.home, color: colorScheme.primary, size: 26),
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

class _ThemeKeyColorTiles extends StatelessWidget {
  final Future<void> Function(BuildContext context, Color currentColor)
      onPickCustomColor;

  const _ThemeKeyColorTiles({
    required this.onPickCustomColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final brightness = Theme.of(context).brightness;
    final colorScheme = Theme.of(context).colorScheme;

    final presetColors = <Color>[
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.deepPurple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.lightBlue,
    ];

    final useAuto = themeProvider.useDynamicColor;
    final selectedSeed = themeProvider.seedColor;

    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 2 + presetColors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            final scheme = colorScheme;
            return _ColorTile(
              scheme: scheme,
              selected: useAuto,
              leading: const Icon(Icons.auto_awesome, size: 22),
              onTap: () => themeProvider.setUseDynamicColor(true),
            );
          }

          if (index == 1) {
            final scheme = themeProvider.colorSpec == ThemeColorSpec.spec2021
                ? ColorScheme.fromSeed(
                    seedColor: selectedSeed,
                    brightness: brightness,
                  )
                : themeProvider.generateMaterialYouColorSchemeFromSeed(
                    seed: selectedSeed,
                    brightness: brightness,
                  );
            return _ColorTile(
              scheme: scheme,
              selected: !useAuto &&
                  !presetColors.any((c) => c.value == selectedSeed.value),
              leading: const Icon(Icons.colorize, size: 22),
              onTap: () async {
                themeProvider.setUseDynamicColor(false);
                await onPickCustomColor(context, selectedSeed);
              },
            );
          }

          final c = presetColors[index - 2];
          final scheme = themeProvider.colorSpec == ThemeColorSpec.spec2021
              ? ColorScheme.fromSeed(
                  seedColor: c,
                  brightness: brightness,
                )
              : themeProvider.generateMaterialYouColorSchemeFromSeed(
                  seed: c,
                  brightness: brightness,
                );

          return _ColorTile(
            scheme: scheme,
            selected: !useAuto && selectedSeed.value == c.value,
            onTap: () {
              themeProvider.setUseDynamicColor(false);
              themeProvider.setSeedColor(c);
            },
          );
        },
      ),
    );
  }
}

class _ColorTile extends StatelessWidget {
  final ColorScheme scheme;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

  const _ColorTile({
    required this.scheme,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(26);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: scheme.surfaceContainerHigh,
            border: Border.all(
              color: selected ? colorScheme.primary : Colors.transparent,
              width: 3,
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(color: scheme.primaryContainer),
                      ),
                      Expanded(
                        child: Container(color: scheme.tertiaryContainer),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: leading ??
                        (selected
                            ? Icon(
                                Icons.check,
                                color: scheme.primary.contrastTextColor,
                                size: 18,
                              )
                            : null),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeModePills extends StatelessWidget {
  const _ThemeModePills();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    final selectedIndex = switch (themeProvider.themeMode) {
      ThemeMode.system => 0,
      ThemeMode.light => 1,
      ThemeMode.dark => themeProvider.useAmoledBlack ? 3 : 2,
    };

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModePill(
              selected: selectedIndex == 0,
              icon: Icons.auto_mode,
              onTap: () {
                themeProvider.setUseAmoledBlack(false);
                themeProvider.setThemeMode(ThemeMode.system);
              },
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ModePill(
              selected: selectedIndex == 1,
              icon: Icons.light_mode,
              onTap: () {
                themeProvider.setUseAmoledBlack(false);
                themeProvider.setThemeMode(ThemeMode.light);
              },
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ModePill(
              selected: selectedIndex == 2,
              icon: Icons.dark_mode,
              onTap: () {
                themeProvider.setUseAmoledBlack(false);
                themeProvider.setThemeMode(ThemeMode.dark);
              },
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ModePill(
              selected: selectedIndex == 3,
              icon: Icons.brightness_1,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.dark);
                themeProvider.setUseAmoledBlack(true);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  const _ModePill({
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = selected ? colorScheme.primaryContainer : Colors.transparent;
    final fg =
        selected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant;

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: 48,
          child: Icon(icon, color: fg),
        ),
      ),
    );
  }
}

class _MaterialYouOptions extends StatelessWidget {
  const _MaterialYouOptions();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    final isSystem = themeProvider.useDynamicColor &&
        themeProvider.supportsDynamicColor &&
        themeProvider.paletteStyle == ThemePaletteStyle.tonalSpot &&
        themeProvider.colorSpec == ThemeColorSpec.spec2025;

    final statusText = isSystem
        ? s.material_you_status_system
        : s.material_you_status_generated;

    return Material(
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    statusText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _OptionRow(
            title: s.color_style,
            value: _formatStyle(themeProvider.paletteStyle),
            onTap: () => _showPaletteStyleSheet(context),
          ),
          const Divider(height: 1),
          _OptionRow(
            title: s.color_spec,
            value: _formatColorSpec(context, themeProvider.colorSpec),
            onTap: () => _showColorSpecSheet(context),
          ),
        ],
      ),
    );
  }

  Future<void> _showPaletteStyleSheet(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final current = context.watch<ThemeProvider>().paletteStyle;
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              for (final style in ThemePaletteStyle.values)
                RadioListTile<ThemePaletteStyle>(
                  value: style,
                  groupValue: current,
                  title: Text(_formatStyle(style)),
                  onChanged: (v) {
                    if (v == null) return;
                    themeProvider.setPaletteStyle(v);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showColorSpecSheet(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final current = context.watch<ThemeProvider>().colorSpec;
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              for (final spec in ThemeColorSpec.values)
                RadioListTile<ThemeColorSpec>(
                  value: spec,
                  groupValue: current,
                  title: Text(_formatColorSpec(context, spec)),
                  onChanged: (v) {
                    if (v == null) return;
                    themeProvider.setColorSpec(v);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _OptionRow extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _OptionRow({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatColorSpec(BuildContext context, ThemeColorSpec spec) {
  final s = S.of(context);
  return switch (spec) {
    ThemeColorSpec.spec2021 => s.color_spec_2021,
    ThemeColorSpec.spec2025 => s.color_spec_2025,
  };
}

String _formatStyle(ThemePaletteStyle style) {
  final name = style.name;
  final buffer = StringBuffer();
  for (var i = 0; i < name.length; i++) {
    final c = name[i];
    if (i == 0) {
      buffer.write(c.toUpperCase());
      continue;
    }
    final isUpper = c.toUpperCase() == c && c.toLowerCase() != c;
    if (isUpper) buffer.write(' ');
    buffer.write(c);
  }
  return buffer.toString();
}
