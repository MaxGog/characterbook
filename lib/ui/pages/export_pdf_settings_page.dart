import 'package:flutter/material.dart';
import 'package:characterbook/models/settings/export_pdf_settings_model.dart';
import 'package:characterbook/services/export_pdf_settings_service.dart';

import '../widgets/appbar/common_edit_app_bar.dart';
import '../widgets/buttons/save_button_widget.dart';
import '../widgets/sections/settings_section.dart';

class ExportPdfSettingsPage extends StatefulWidget {
  const ExportPdfSettingsPage({super.key});

  @override
  _ExportPdfSettingsPageState createState() => _ExportPdfSettingsPageState();
}

class _ExportPdfSettingsPageState extends State<ExportPdfSettingsPage> {
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
    } catch (e) {
      _settings = ExportPdfSettings();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    if (_settings == null) return;

    await _settingsService.saveSettings(_settings!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Настройки сохранены'),
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Настройки экспорта PDF'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_settings == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Настройки экспорта PDF'),
        ),
        body: const Center(
          child: Text('Ошибка загрузки настроек'),
        ),
      );
    }

    return Scaffold(
      appBar: CommonEditAppBar(
        title: 'Настройки экспорта PDF',
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetToDefaults,
            tooltip: 'Сбросить настройки',
          ),
        ],
        onSave: _saveSettings,
        saveTooltip: 'Сохранить настройки',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SettingsSection(
              title: 'Включаемые разделы',
              children: [
                _buildSectionSwitch(
                  'Основная информация',
                  _settings!.includeBasicInfo,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(includeBasicInfo: value);
                    });
                  },
                ),
                _buildSectionSwitch(
                  'Биография',
                  _settings!.includeBiography,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(includeBiography: value);
                    });
                  },
                ),
                _buildSectionSwitch(
                  'Характер',
                  _settings!.includePersonality,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(includePersonality: value);
                    });
                  },
                ),
                _buildSectionSwitch(
                  'Внешность',
                  _settings!.includeAppearance,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(includeAppearance: value);
                    });
                  },
                ),
                _buildSectionSwitch(
                  'Способности',
                  _settings!.includeAbilities,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(includeAbilities: value);
                    });
                  },
                ),
                _buildSectionSwitch(
                  'Другое',
                  _settings!.includeOther,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(includeOther: value);
                    });
                  },
                ),
                _buildSectionSwitch(
                  'Дополнительные поля',
                  _settings!.includeCustomFields,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(includeCustomFields: value);
                    });
                  },
                ),
                _buildSectionSwitch(
                  'Изображение персонажа',
                  _settings!.includeCharacterImage,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(includeCharacterImage: value);
                    });
                  },
                ),
                _buildSectionSwitch(
                  'Референс изображение',
                  _settings!.includeReferenceImage,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(includeReferenceImage: value);
                    });
                  },
                ),
                _buildSectionSwitch(
                  'Дополнительные изображения',
                  _settings!.includeAdditionalImages,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(includeAdditionalImages: value);
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            SettingsSection(
              title: 'Настройки шрифтов',
              children: [
                _buildFontSizeSlider(
                  'Размер шрифта заголовков',
                  _settings!.titleFontSize,
                  16,
                  32,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(titleFontSize: value);
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildFontSizeSlider(
                  'Размер шрифта текста',
                  _settings!.bodyFontSize,
                  10,
                  20,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(bodyFontSize: value);
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            SettingsSection(
              title: 'Настройки цветов',
              children: [
                _buildColorPicker(
                  'Цвет заголовков',
                  _settings!.titleColor,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(titleColor: value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildColorPicker(
                  'Цвет текста',
                  _settings!.bodyColor,
                  (value) {
                    setState(() {
                      _settings = _settings!.copyWith(bodyColor: value);
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            SaveButton(
              onPressed: _saveSettings,
              text: 'Сохранить настройки',
              height: 56,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionSwitch(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildFontSizeSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
          activeColor: colorScheme.primary,
          inactiveColor: colorScheme.surfaceVariant,
        ),
      ],
    );
  }

  Widget _buildColorPicker(
    String label,
    String currentColor,
    ValueChanged<String> onChanged,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final colors = [
      '#000000', // Черный
      '#333333', // Темно-серый
      '#666666', // Серый
      '#2E7D32', // Зеленый
      '#1565C0', // Синий
      '#6A1B9A', // Фиолетовый
      '#C62828', // Красный
      '#EF6C00', // Оранжевый
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _parseColor(color),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : Colors.transparent,
                    width: isSelected ? 3 : 0,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: colorScheme.onPrimary,
                        size: 20,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}