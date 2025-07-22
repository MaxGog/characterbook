import 'dart:typed_data';
import 'package:characterbook/ui/handlers/unsaved_changes_handler.dart';
import 'package:characterbook/ui/widgets/folder_selector_widget.dart';
import 'package:characterbook/ui/widgets/tags/tags_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/services/folder_service.dart';

import '../../../generated/l10n.dart';
import '../../../models/character_model.dart';
import '../../../models/custom_field_model.dart';
import '../../../models/race_model.dart';
import '../../../models/template_model.dart';
import '../../../services/character_service.dart';

import '../../widgets/avatar_picker_widget.dart';
import '../../widgets/fields/custom_fields_editor.dart';
import '../../widgets/fields/custom_text_field.dart';
import '../../widgets/fields/gender_selector_field.dart';
import '../../widgets/fields/race_selector_field.dart';
import '../../widgets/save_button_widget.dart';
import '../../dialogs/unsaved_changes_dialog.dart';

class CharacterEditPage extends StatefulWidget {
  final Character? character;
  final QuestionnaireTemplate? template;

  const CharacterEditPage({super.key, this.character, this.template});

  @override
  State<CharacterEditPage> createState() => _CharacterEditPageState();
}

class _CharacterEditPageState extends State<CharacterEditPage> with UnsavedChangesHandler {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  late final CharacterService _characterService;
  late final FolderService _folderService;

  late Character _character;
  late List<Race> _races;
  late List<CustomField> _customFields;
  late List<Uint8List> _additionalImages;
  List<Folder> _characterFolders = [];
  Folder? _selectedFolder;
  List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();

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
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Future<void> saveChanges() async => await _saveCharacter();


  Future<void> _loadFolders() async {
    final folders = _folderService.getFoldersByType(FolderType.character);
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
  }

  Future<void> _loadRaces() async {
    final raceBox = Hive.box<Race>('races');
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

  Future<void> _updateCharacter() async {
    setState(() {
      _character = _buildCharacter();
    });
  }

  Character _buildCharacter() {
    return _character.copyWith(
      customFields: _customFields.where((f) => f.key.isNotEmpty).toList(),
      additionalImages: _additionalImages,
    );
  }

  Future<void> _pickReferenceImage() async => _pickAndSetImage(false);

  Future<void> _pickAndSetImage(bool isMainImage) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          if (isMainImage) {
            _character.imageBytes = bytes;
          } else {
            _character.referenceImageBytes = bytes;
          }
          hasUnsavedChanges = true;
        });
        await _updateCharacter();
      }
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
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _additionalImages.add(bytes);
          hasUnsavedChanges = true;
        });
        await _updateCharacter();
      }
    } catch (e) {
      _showError('${S.of(context).error}: ${e.toString()}');
    }
  }

  void _removeAdditionalImage(int index) {
    setState(() {
      _additionalImages.removeAt(index);
      hasUnsavedChanges = true;
    });
    _updateCharacter();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _saveCharacter() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final character = _buildCharacter();
        character.folderId = _selectedFolder?.id;
        character.tags = _tags;

        final characterKey = await _characterService.saveCharacter(
          character,
          key: widget.character?.key,
        );

        final actualKey = characterKey ?? widget.character?.key;

        if (actualKey != null) {
          if (_selectedFolder == null) {
            for (final folder in _characterFolders) {
              if (folder.contentIds.contains(actualKey.toString())) {
                await _folderService.removeFromFolder(folder.id, actualKey.toString());
              }
            }
          } 
          else {
            for (final folder in _characterFolders) {
              if (folder.id != _selectedFolder!.id && 
                  folder.contentIds.contains(actualKey.toString())) {
                await _folderService.removeFromFolder(folder.id, actualKey.toString());
              }
            }
            await _folderService.addToFolder(_selectedFolder!.id, actualKey.toString());
          }
        }

        setState(() => hasUnsavedChanges = false);

        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${S.of(context).save_error}: ${e.toString()}')),
          );
        }
      }
    }
  }

  bool _shouldShowField(String fieldName) {
    if (widget.template == null) return true;
    return widget.template!.containsField(fieldName);
  }

  String _normalizeGender(String? gender, BuildContext context) {
    if (gender == null) return 'male';

    final s = S.of(context);
    if (gender == s.male) return 'male';
    if (gender == s.female) return 'female';
    if (gender == s.another) return 'another';

    return gender;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return WillPopScope(
      onWillPop: () => handleUnsavedChanges(context),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TagsInputWidget(
                  tags: _tags,
                  onTagsChanged: (tags) {
                    setState(() {
                      _tags = tags;
                      hasUnsavedChanges = true;
                    });
                  },
                ),
                const SizedBox(height: 24),
                if (widget.template != null) _buildTemplateChip(),
                AvatarPicker(
                  currentAvatar: _character.imageBytes,
                  onAvatarChanged: (bytes) {
                    setState(() {
                      _character.imageBytes = bytes;
                      hasUnsavedChanges = true;
                    });
                    _updateCharacter();
                  },
                ),
                const SizedBox(height: 24),
                _buildNameField(),
                if (_characterFolders.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  FolderSelectorWidget(
                    selectedFolder: _selectedFolder,
                    onFolderSelected: (folder) {
                      setState(() {
                        _selectedFolder = folder;
                        _character.folderId = folder?.id;
                        hasUnsavedChanges = true;
                      });
                    },
                    folderService: _folderService,
                    folderType: FolderType.character,
                  ),
                ],
                const SizedBox(height: 16),
                if (_shouldShowField('age') || _shouldShowField('gender'))
                  _buildAgeAndGenderRow(),
                if (_shouldShowField('age') || _shouldShowField('gender'))
                  const SizedBox(height: 16),
                if (_shouldShowField('race'))
                  RaceSelectorField(
                    initialRace: _character.race,
                    onChanged: (race) {
                      _character.race = race;
                      hasUnsavedChanges = true;
                    },
                  ),
                if (_shouldShowField('race')) const SizedBox(height: 16),
                if (_shouldShowField('referenceImage'))
                  _buildReferenceImageSection(context, colorScheme, textTheme),
                  const SizedBox(height: 16),
                if (_shouldShowField('appearance'))
                  CustomTextField(
                    label: S.of(context).appearance,
                    initialValue: _character.appearance,
                    alignLabel: true,
                    onSaved: (value) => _character.appearance = value!,
                    onChanged: (_) => hasUnsavedChanges = true,
                    maxLines: 5,
                  ),
                if (_shouldShowField('appearance')) const SizedBox(height: 16),
                if (_shouldShowField('additionalImages'))
                  _buildAdditionalImagesSection(context, textTheme, colorScheme),
                if (_shouldShowField('additionalImages')) const SizedBox(height: 16),
                if (_shouldShowField('personality'))
                  CustomTextField(
                    label: S.of(context).personality,
                    initialValue: _character.personality,
                    alignLabel: true,
                    onSaved: (value) => _character.personality = value!,
                    onChanged: (_) => hasUnsavedChanges = true,
                    maxLines: 4,
                  ),
                if (_shouldShowField('personality')) const SizedBox(height: 16),
                if (_shouldShowField('biography'))
                  CustomTextField(
                    label: S.of(context).biography,
                    initialValue: _character.biography,
                    alignLabel: true,
                    onSaved: (value) => _character.biography = value!,
                    onChanged: (_) => hasUnsavedChanges = true,
                    maxLines: 7,
                  ),
                if (_shouldShowField('biography')) const SizedBox(height: 16),
                if (_shouldShowField('abilities'))
                  CustomTextField(
                    label: S.of(context).abilities,
                    initialValue: _character.abilities,
                    alignLabel: true,
                    onSaved: (value) => _character.abilities = value!,
                    onChanged: (_) => hasUnsavedChanges = true,
                    maxLines: 7,
                  ),
                if (_shouldShowField('abilities')) const SizedBox(height: 16),
                if (_shouldShowField('other'))
                  CustomTextField(
                    label: S.of(context).other,
                    initialValue: _character.other,
                    alignLabel: true,
                    onSaved: (value) => _character.other = value!,
                    onChanged: (_) => hasUnsavedChanges = true,
                    maxLines: 5,
                  ),
                if (_shouldShowField('other')) const SizedBox(height: 32),
                CustomFieldsEditor(
                  initialFields: _customFields,
                  onFieldsChanged: (fields) {
                    _customFields = fields;
                    hasUnsavedChanges = true;
                  },
                ),
                const SizedBox(height: 16),
                SaveButton(
                  onPressed: _saveCharacter,
                  text: S.of(context).save,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        widget.character == null
            ? widget.template == null
                ? S.of(context).new_character
                : '${S.of(context).new_character} (${S.of(context).from_template})'
            : S.of(context).edit,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveCharacter,
          tooltip: S.of(context).save,
        ),
      ],
    );
  }

  Widget _buildAdditionalImagesSection(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(S.of(context).additional_images, style: textTheme.titleMedium),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_photo_alternate),
              onPressed: _pickAdditionalImage,
              tooltip: S.of(context).add_picture,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_additionalImages.isEmpty)
          Text(
            S.of(context).no_additional_images,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        if (_additionalImages.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _additionalImages.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _additionalImages[index],
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeAdditionalImage(index),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReferenceImageSection(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        Text(
          S.of(context).reference_image,
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _pickReferenceImage,
          child: Ink(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              image: _character.referenceImageBytes != null
                  ? DecorationImage(
                image: MemoryImage(_character.referenceImageBytes!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: _character.referenceImageBytes == null
                ? Icon(
              Icons.add_a_photo,
              size: 40,
              color: colorScheme.onSurfaceVariant,
            )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateChip() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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

  Widget _buildNameField() {
    return CustomTextField(
      label: S.of(context).name,
      initialValue: _character.name,
      isRequired: true,
      onSaved: (value) => _character.name = value!,
      onChanged: (_) => hasUnsavedChanges = true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).name;
        }
        return null;
      },
    );
  }

  Widget _buildAgeAndGenderRow() {
    return Column(
      children: [
        Row(
          children: [
            if (_shouldShowField('age'))
              Expanded(child: _buildAgeField()),
            if (_shouldShowField('age') && _shouldShowField('gender'))
              const SizedBox(width: 16),
            if (_shouldShowField('gender'))
              Expanded(child: _buildGenderField()),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAgeField() {
    return CustomTextField(
      label: S.of(context).age,
      initialValue: _character.age?.toString() ?? '',
      isRequired: _shouldShowField('age'),
      keyboardType: TextInputType.number,
      validator: _shouldShowField('age') ? (value) {
        if (value?.isEmpty ?? true) return S.of(context).enter_age;
        final age = int.tryParse(value!);
        if (age == null || age <= 0) return S.of(context).invalid_age;
        return null;
      } : null,
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