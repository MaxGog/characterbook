import 'package:flutter/material.dart';
import 'package:characterbook/models/export_pdf_settings_model.dart';
import 'package:characterbook/services/export_pdf_settings_service.dart';

class ExportPdfSettingsPage extends StatefulWidget {
  const ExportPdfSettingsPage({Key? key}) : super(key: key);

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
      const SnackBar(content: Text('Настройки сохранены')),
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
      appBar: AppBar(
        title: const Text('Настройки экспорта PDF'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetToDefaults,
            tooltip: 'Сбросить настройки',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Включаемые разделы'),
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
          const SizedBox(height: 24),
          _buildSectionHeader('Настройки шрифтов'),
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
          const SizedBox(height: 24),
          _buildSectionHeader('Настройки цветов'),
          _buildColorPicker(
            'Цвет заголовков',
            _settings!.titleColor,
            (value) {
              setState(() {
                _settings = _settings!.copyWith(titleColor: value);
              });
            },
          ),
          _buildColorPicker(
            'Цвет текста',
            _settings!.bodyColor,
            (value) {
              setState(() {
                _settings = _settings!.copyWith(bodyColor: value);
              });
            },
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _saveSettings,
            child: const Text('Сохранить настройки'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSectionSwitch(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(1)}'),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildColorPicker(
    String label,
    String currentColor,
    ValueChanged<String> onChanged,
  ) {
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
        Text(label),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () => onChanged(color),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _parseColor(color),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: currentColor == color
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
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
