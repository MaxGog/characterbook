import 'package:characterbook/services/pdf_export_serivce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:characterbook/data/models/export_pdf_settings_model.dart';
import 'package:characterbook/generated/l10n.dart';

class ExportPdfSettingsScreen extends StatefulWidget {
  const ExportPdfSettingsScreen({super.key});

  @override
  _ExportPdfSettingsScreenState createState() =>
      _ExportPdfSettingsScreenState();
}

class _ExportPdfSettingsScreenState extends State<ExportPdfSettingsScreen> {
  final ExportPdfSettingsService _settingsService = ExportPdfSettingsService();
  ExportPdfSettings? _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      _settings = await _settingsService.getSettings();
    } catch (_) {
      _settings = ExportPdfSettings();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveSettings() async {
    if (_settings == null) return;
    await _settingsService.saveSettings(_settings!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).settings_saved),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      _settings = ExportPdfSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    if (_isLoading) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(title: Text(s.export_pdf_settings)),
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      );
    }

    if (_settings == null) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(title: Text(s.export_pdf_settings)),
            SliverFillRemaining(
              child: Center(child: Text(s.settings_load_error)),
            ),
          ],
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text(s.export_pdf_settings),
              actions: [
                IconButton(
                  icon: const Icon(Icons.restore),
                  onPressed: _resetToDefaults,
                  tooltip: s.reset_settings,
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveSettings,
                  tooltip: s.save_settings,
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    _SectionsCard(
                      settings: _settings!,
                      onChanged: (v) => setState(() => _settings = v),
                    ),
                    const SizedBox(height: 16),
                    _FontSettingsCard(
                      settings: _settings!,
                      onChanged: (v) => setState(() => _settings = v),
                    ),
                    const SizedBox(height: 16),
                    _ColorSettingsCard(
                      settings: _settings!,
                      onChanged: (v) => setState(() => _settings = v),
                    ),
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

class _SectionsCard extends StatelessWidget {
  final ExportPdfSettings settings;
  final ValueChanged<ExportPdfSettings> onChanged;

  const _SectionsCard({required this.settings, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return _SettingsCard(
      title: s.sections_to_include,
      children: [
        _buildSwitch(s.basic_info, settings.includeBasicInfo,
            (v) => onChanged(settings.copyWith(includeBasicInfo: v))),
        _buildSwitch(s.biography, settings.includeBiography,
            (v) => onChanged(settings.copyWith(includeBiography: v))),
        _buildSwitch(s.personality, settings.includePersonality,
            (v) => onChanged(settings.copyWith(includePersonality: v))),
        _buildSwitch(s.appearance, settings.includeAppearance,
            (v) => onChanged(settings.copyWith(includeAppearance: v))),
        _buildSwitch(s.abilities, settings.includeAbilities,
            (v) => onChanged(settings.copyWith(includeAbilities: v))),
        _buildSwitch(s.other, settings.includeOther,
            (v) => onChanged(settings.copyWith(includeOther: v))),
        _buildSwitch(s.custom_fields, settings.includeCustomFields,
            (v) => onChanged(settings.copyWith(includeCustomFields: v))),
        _buildSwitch(s.main_image, settings.includeCharacterImage,
            (v) => onChanged(settings.copyWith(includeCharacterImage: v))),
        _buildSwitch(s.reference_image, settings.includeReferenceImage,
            (v) => onChanged(settings.copyWith(includeReferenceImage: v))),
        _buildSwitch(s.additional_images, settings.includeAdditionalImages,
            (v) => onChanged(settings.copyWith(includeAdditionalImages: v))),
      ],
    );
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}

class _FontSettingsCard extends StatelessWidget {
  final ExportPdfSettings settings;
  final ValueChanged<ExportPdfSettings> onChanged;

  const _FontSettingsCard({required this.settings, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return _SettingsCard(
      title: s.font_settings,
      children: [
        _buildSlider(
          context: context,
          label: s.title_font_size,
          value: settings.titleFontSize,
          min: 16,
          max: 32,
          onChanged: (v) => onChanged(settings.copyWith(titleFontSize: v)),
        ),
        const SizedBox(height: 24),
        _buildSlider(
          context: context,
          label: s.body_font_size,
          value: settings.bodyFontSize,
          min: 10,
          max: 20,
          onChanged: (v) => onChanged(settings.copyWith(bodyFontSize: v)),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required BuildContext context,
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 2).round(),
          onChanged: onChanged,
          activeColor: colorScheme.primary,
          inactiveColor: colorScheme.surfaceVariant,
        ),
      ],
    );
  }
}

class _ColorSettingsCard extends StatelessWidget {
  final ExportPdfSettings settings;
  final ValueChanged<ExportPdfSettings> onChanged;

  const _ColorSettingsCard({required this.settings, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return _SettingsCard(
      title: s.color_settings,
      children: [
        _buildColorPicker(
          context: context,
          label: s.title_color,
          currentColor: settings.titleColor,
          onChanged: (v) => onChanged(settings.copyWith(titleColor: v)),
        ),
        const SizedBox(height: 24),
        _buildColorPicker(
          context: context,
          label: s.body_color,
          currentColor: settings.bodyColor,
          onChanged: (v) => onChanged(settings.copyWith(bodyColor: v)),
        ),
      ],
    );
  }

  Widget _buildColorPicker({
    required BuildContext context,
    required String label,
    required String currentColor,
    required ValueChanged<String> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = const [
      '#000000',
      '#333333',
      '#666666',
      '#2E7D32',
      '#1565C0',
      '#6A1B9A',
      '#C62828',
      '#EF6C00',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((color) {
            final isSelected = currentColor == color;
            return GestureDetector(
              onTap: () => onChanged(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _parseColor(color),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? colorScheme.primary : Colors.transparent,
                    width: isSelected ? 3 : 0,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: isSelected
                    ? Icon(Icons.check, color: _checkColor(color), size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  Color _checkColor(String hex) {
    final color = _parseColor(hex);
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
