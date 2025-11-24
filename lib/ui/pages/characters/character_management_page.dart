import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../../../generated/l10n.dart';
import '../../../models/characters/character_model.dart';
import '../../../models/characters/template_model.dart';
import '../../../models/custom_field_model.dart';
import '../../../models/folder_model.dart';
import '../../../models/race_model.dart';
import '../../../services/character_service.dart';
import '../../../services/folder_service.dart';
import '../../handlers/unsaved_changes_handler.dart';
import '../../widgets/appbar/common_edit_app_bar.dart';
import '../../widgets/avatar_picker_widget.dart';
import '../../widgets/base_edit_page_scaffold.dart';
import '../../widgets/fields/custom_fields_editor.dart';
import '../../widgets/fields/custom_text_field.dart';
import '../../widgets/fields/gender_selector_field.dart';
import '../../widgets/fields/race_selector_field.dart';
import '../../widgets/reference_image_picker.dart';
import '../../widgets/buttons/save_button_widget.dart';
import '../../widgets/sections/image_gallery_section.dart';
import '../../widgets/sections/tags_and_folder_section.dart';

class CharacterEditPage extends StatefulWidget {
  final Character? character;
  final QuestionnaireTemplate? template;

  const CharacterEditPage({super.key, this.character, this.template});

  @override
  State<CharacterEditPage> createState() => _CharacterEditPageState();
}

class _CharacterEditPageState extends State<CharacterEditPage>
    with UnsavedChangesHandler {
  static const _sectionSpacing = 24.0;
  static const _fieldSpacing = 16.0;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();

  late final CharacterService _characterService;
  late final FolderService _folderService;

  late Character _character;
  late List<Race> _races;
  late List<CustomField> _customFields;
  late List<Uint8List> _additionalImages;
  List<Folder> _characterFolders = [];
  Folder? _selectedFolder;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _characterService = CharacterService.forDatabase();
    _folderService = FolderService(Hive.box<Folder>('folders'));
    _initializeFields();
    _loadRaces();
    _loadFolders();
    hasUnsavedChanges = widget.character == null;
  }

  @override
  Future<void> saveChanges() async => _saveCharacter();

  Future<void> _loadFolders() async {
    final folders = _folderService.getFoldersByType(FolderType.character);
    if (!mounted) return;
    
    setState(() {
      _characterFolders = folders;
      _selectedFolder = widget.character?.folderId != null
          ? _folderService.getFolderById(widget.character!.folderId!)
          : null;
    });
  }

  void _initializeFields() {
    if (widget.template != null && widget.character == null) {
      _character = widget.template!.applyToCharacter(Character.empty());
    } else {
      _character = widget.character?.copyWith() ?? Character.empty();
    }

    _customFields = _character.customFields.map((f) => f.copyWith()).toList();
    _additionalImages = List.from(_character.additionalImages);
    _tags = List.from(_character.tags);
  }

  Future<void> _loadRaces() async {
    final raceBox = Hive.box<Race>('races');
    if (!mounted) return;
    
    setState(() {
      _races = raceBox.values.toList();

      if (_character.race != null &&
          !_races.any((r) => r.name == _character.race?.name)) {
        _races.add(_character.race!);
      }

      if (_character.race == null && _races.isNotEmpty) {
        _character.race = _races.first;
      }
    });
  }

  Character _buildCharacter() {
    return _character.copyWith(
      customFields: _customFields.where((f) => f.key.isNotEmpty).toList(),
      additionalImages: _additionalImages,
      tags: _tags,
      folderId: _selectedFolder?.id,
    );
  }

  Future<void> _pickImage(bool isMainImage) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;

      setState(() {
        if (isMainImage) {
          _character.imageBytes = bytes;
        } else {
          _character.referenceImageBytes = bytes;
        }
        hasUnsavedChanges = true;
      });
    } catch (e) {
      _showError('${S.of(context).error}: ${e.toString()}');
    }
  }

  Future<void> _pickAdditionalImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;

      setState(() {
        _additionalImages.add(bytes);
        hasUnsavedChanges = true;
      });
    } catch (e) {
      _showError('${S.of(context).error}: ${e.toString()}');
    }
  }

  void _removeAdditionalImage(int index) {
    setState(() {
      _additionalImages.removeAt(index);
      hasUnsavedChanges = true;
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    try {
      final character = _buildCharacter();
      final characterKey = await _characterService.saveCharacter(
        character,
        key: widget.character?.key,
      );

      await _updateFolderMembership(characterKey);
      if (!mounted) return;

      setState(() => hasUnsavedChanges = false);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${S.of(context).save_error}: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _updateFolderMembership(dynamic characterKey) async {
    final actualKey = characterKey ?? widget.character?.key;
    if (actualKey == null) return;

    final keyString = actualKey.toString();

    if (_selectedFolder == null) {
      for (final folder in _characterFolders) {
        if (folder.contentIds.contains(keyString)) {
          await _folderService.removeFromFolder(folder.id, keyString);
        }
      }
      return;
    }

    for (final folder in _characterFolders) {
      if (folder.id != _selectedFolder!.id &&
          folder.contentIds.contains(keyString)) {
        await _folderService.removeFromFolder(folder.id, keyString);
      }
    }
    await _folderService.addToFolder(_selectedFolder!.id, keyString);
  }

  bool _shouldShowField(String fieldName) {
    return widget.template?.containsField(fieldName) ?? true;
  }

  String _normalizeGender(String? gender, BuildContext context) {
    if (gender == null) return 'male';

    final s = S.of(context);
    return switch (gender) {
      'male' => s.male,
      'female' => s.female,
      'another' => s.another,
      _ => gender,
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final title = _buildPageTitle(s);

    return BaseEditPageScaffold(
      onWillPop: () => handleUnsavedChanges(context),
      appBar: CommonEditAppBar(
        title: title,
        onSave: _saveCharacter,
        saveTooltip: s.save,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildFolderAndTagsSection(),
            if (widget.template != null) _buildTemplateChip(),
            _buildAvatarSection(),
            const SizedBox(height: _sectionSpacing),
            _buildNameField(),
            const SizedBox(height: _fieldSpacing),
            ..._buildCharacterFields(s),
            const SizedBox(height: _sectionSpacing),
            SaveButton(
              onPressed: _saveCharacter,
              text: s.save,
            ),
            const SizedBox(height: _fieldSpacing),
          ],
        ),
      ),
    );
  }

  String _buildPageTitle(S s) {
    if (widget.character == null) {
      return widget.template == null
          ? s.new_character
          : '${s.new_character} (${s.from_template})';
    }
    return s.edit_character;
  }

  Widget _buildFolderAndTagsSection() {
    return TagsAndFolderSection(
      tags: _tags,
      onTagsChanged: (tags) {
        setState(() {
          _tags = tags;
          hasUnsavedChanges = true;
        });
      },
      folderService: _folderService,
      folderType: FolderType.character,
      selectedFolder: _selectedFolder,
      onFolderSelected: (folder) {
        setState(() {
          _selectedFolder = folder;
          hasUnsavedChanges = true;
        });
      },
      folders: _characterFolders,
    );
  }

  Widget _buildTemplateChip() {
    return Padding(
      padding: const EdgeInsets.only(bottom: _fieldSpacing),
      child: Chip(
        label: Text(
          '${S.of(context).template}: ${widget.template!.name}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }

  Widget _buildAvatarSection() {
    return AvatarPicker(
      currentAvatar: _character.imageBytes,
      onAvatarChanged: (bytes) {
        setState(() {
          _character.imageBytes = bytes;
          hasUnsavedChanges = true;
        });
      },
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      label: S.of(context).name,
      initialValue: _character.name,
      isRequired: true,
      onSaved: (value) => _character.name = value!,
      onChanged: (_) => hasUnsavedChanges = true,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return S.of(context).name;
        }
        return null;
      },
    );
  }

  List<Widget> _buildCharacterFields(S s) {
    final fields = <Widget>[];

    if (_shouldShowField('age') || _shouldShowField('gender')) {
      fields.addAll([
        _buildAgeAndGenderRow(),
        const SizedBox(height: _fieldSpacing),
      ]);
    }

    if (_shouldShowField('race')) {
      fields.addAll([
        RaceSelectorField(
          initialRace: _character.race,
          onChanged: (race) {
            _character.race = race;
            hasUnsavedChanges = true;
          },
        ),
        const SizedBox(height: _fieldSpacing),
      ]);
    }

    if (_shouldShowField('referenceImage')) {
      fields.addAll([
        ReferenceImagePicker(
          imageBytes: _character.referenceImageBytes,
          onPickImage: () => _pickImage(false),
          title: s.reference_image,
        ),
        const SizedBox(height: _fieldSpacing),
      ]);
    }

    fields.addAll([
      CustomFieldsEditor(
        initialFields: _customFields,
        onFieldsChanged: (fields) {
          _customFields = fields;
          hasUnsavedChanges = true;
        },
        verticalLayout: true,
      ),
    ]);

    if (_shouldShowField('additionalImages')) {
      fields.addAll([
        const SizedBox(height: _fieldSpacing),
        ImageGallerySection(
          images: _additionalImages,
          onAddImage: _pickAdditionalImage,
          onRemoveImage: _removeAdditionalImage,
          title: s.additional_images,
          emptyText: s.no_additional_images,
          addTooltip: s.add_picture,
        ),
      ]);
    }

    final textFields = [
      ('appearance', s.appearance, 5),
      ('personality', s.personality, 4),
      ('biography', s.biography, 7),
      ('abilities', s.abilities, 7),
      ('other', s.other, 5),
    ];

    for (final (fieldName, label, maxLines) in textFields) {
      if (_shouldShowField(fieldName)) {
        fields.addAll([
          const SizedBox(height: _fieldSpacing),
          CustomTextField(
            label: label,
            initialValue: _getFieldValue(fieldName),
            alignLabel: true,
            onSaved: (value) => _setFieldValue(fieldName, value!),
            onChanged: (_) => hasUnsavedChanges = true,
            maxLines: maxLines,
          ),
        ]);
      }
    }

    return fields;
  }

  String _getFieldValue(String fieldName) {
    return switch (fieldName) {
      'appearance' => _character.appearance,
      'personality' => _character.personality,
      'biography' => _character.biography,
      'abilities' => _character.abilities,
      'other' => _character.other,
      _ => '',
    };
  }

  void _setFieldValue(String fieldName, String value) {
    switch (fieldName) {
      case 'appearance':
        _character.appearance = value;
      case 'personality':
        _character.personality = value;
      case 'biography':
        _character.biography = value;
      case 'abilities':
        _character.abilities = value;
      case 'other':
        _character.other = value;
    }
  }

  Widget _buildAgeAndGenderRow() {
    return Row(
      children: [
        if (_shouldShowField('age')) ...[
          Expanded(child: _buildAgeField()),
          if (_shouldShowField('gender')) const SizedBox(width: _fieldSpacing),
        ],
        if (_shouldShowField('gender')) Expanded(child: _buildGenderField()),
      ],
    );
  }

  Widget _buildAgeField() {
    return CustomTextField(
      label: S.of(context).age,
      initialValue: _character.age.toString(),
      isRequired: _shouldShowField('age'),
      keyboardType: TextInputType.number,
      validator: _shouldShowField('age')
          ? (value) {
              if (value?.isEmpty ?? true) return S.of(context).enter_age;
              final age = int.tryParse(value!);
              if (age == null || age <= 0) return S.of(context).invalid_age;
              return null;
            }
          : null,
      onSaved: _shouldShowField('age')
          ? (value) => _character.age = int.tryParse(value ?? '0') ?? 0
          : null,
      onChanged: (_) => hasUnsavedChanges = true,
    );
  }

  Widget _buildGenderField() {
    return GenderSelectorField(
      initialValue: _normalizeGender(_character.gender, context),
      onChanged: (value) {
        setState(() {
          _character.gender = value!;
          hasUnsavedChanges = true;
        });
      },
    );
  }
}