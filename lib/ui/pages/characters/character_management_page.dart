import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/services/folder_service.dart';
import 'package:flutter_tags/flutter_tags.dart';

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

class _CharacterEditPageState extends State<CharacterEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  late final CharacterService _characterService;

  late Character _character;
  late List<Race> _races;
  late List<CustomField> _customFields;
  late List<Uint8List> _additionalImages;
  bool _hasUnsavedChanges = false;

  late final FolderService _folderService;
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
    _hasUnsavedChanges = widget.character == null;
    _tags = List.from(widget.character?.tags ?? []);
  }

  Future<void> _loadFolders() async {
    final folders = _folderService.getFoldersByType(FolderType.character);
    setState(() {
      _characterFolders = folders;
      _selectedFolder = widget.character?.folderId != null 
        ? _folderService.getFolderById(widget.character!.folderId!) 
        : null;
    });
  }

  void _onTagsChanged(List<String> tags) {
    setState(() {
      _tags = tags;
      _hasUnsavedChanges = true;
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
          _hasUnsavedChanges = true;
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
          _hasUnsavedChanges = true;
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
      _hasUnsavedChanges = true;
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

        setState(() => _hasUnsavedChanges = false);

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
      onWillPop: () async {
        if (!_hasUnsavedChanges) return true;
        final shouldSave = await UnsavedChangesDialog().show(context);
        if (shouldSave == null) return false;
        if (shouldSave) await _saveCharacter();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.character == null
                ? widget.template == null
                ? S.of(context).new_character
                : '${S.of(context).new_character} (${S.of(context).from_template})'
                : S.of(context).edit,
            style: textTheme.titleLarge,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveCharacter,
              tooltip: S.of(context).save,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.template != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Chip(
                      label: Text(
                        '${S.of(context).template}: ${widget.template!.name}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      backgroundColor: colorScheme.primaryContainer,
                    ),
                  ),
                AvatarPicker(
                  currentAvatar: _character.imageBytes,
                  onAvatarChanged: (bytes) {
                    setState(() {
                      _character.imageBytes = bytes;
                      _hasUnsavedChanges = true;
                    });
                    _updateCharacter();
                  },
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: S.of(context).name,
                  initialValue: _character.name,
                  isRequired: true,
                  onSaved: (value) => _character.name = value!,
                  onChanged: (_) => _hasUnsavedChanges = true,
                ),
                if (_characterFolders.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _selectFolder(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: S.of(context).folder,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.folder_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _selectedFolder?.name ?? S.of(context).no_folder_selected,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: _selectedFolder == null 
                                  ? Theme.of(context).colorScheme.onSurface 
                                  : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (_selectedFolder != null)
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              style: IconButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedFolder = null;
                                  _character.folderId = null;
                                  _hasUnsavedChanges = true;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (_shouldShowField('age') || _shouldShowField('gender'))
                  Row(
                    children: [
                      if (_shouldShowField('age'))
                        Expanded(
                          child: CustomTextField(
                            label: S.of(context).age,
                            initialValue: _character.age.toString(),
                            isRequired: _shouldShowField('age'),
                            keyboardType: TextInputType.number,
                            validator: _shouldShowField('age') ? (value) {
                              if (value?.isEmpty ?? true) return S.of(context).enter_age;
                              final age = int.tryParse(value!);
                              if (age == null || age <= 0) return S.of(context).invalid_age;
                              return null;
                            } : null,
                            onSaved: _shouldShowField('age')
                                ? (value) => _character.age = int.parse(value!)
                                : null,
                            onChanged: (_) => _hasUnsavedChanges = true,
                          ),
                        ),
                      if (_shouldShowField('age') && _shouldShowField('gender'))
                        const SizedBox(width: 16),
                      if (_shouldShowField('gender'))
                        Expanded(
                          child: GenderSelectorField(
                            initialValue: _normalizeGender(_character.gender, context),
                            onChanged: (value) {
                              _character.gender = value!;
                              _hasUnsavedChanges = true;
                            },
                          ),
                        ),
                    ],
                  ),
                if (_shouldShowField('age') || _shouldShowField('gender'))
                  const SizedBox(height: 16),
                if (_shouldShowField('race'))
                  RaceSelectorField(
                    initialRace: _character.race,
                    onChanged: (race) {
                      _character.race = race;
                      _hasUnsavedChanges = true;
                    },
                  ),
                if (_shouldShowField('race')) const SizedBox(height: 16),
                //_buildTagsInput(context),
                if (_shouldShowField('referenceImage'))
                  _buildReferenceImageSection(context, colorScheme, textTheme),
                  const SizedBox(height: 16),
                if (_shouldShowField('appearance'))
                  CustomTextField(
                    label: S.of(context).appearance,
                    initialValue: _character.appearance,
                    alignLabel: true,
                    onSaved: (value) => _character.appearance = value!,
                    onChanged: (_) => _hasUnsavedChanges = true,
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
                    onChanged: (_) => _hasUnsavedChanges = true,
                    maxLines: 4,
                  ),
                if (_shouldShowField('personality')) const SizedBox(height: 16),
                if (_shouldShowField('biography'))
                  CustomTextField(
                    label: S.of(context).biography,
                    initialValue: _character.biography,
                    alignLabel: true,
                    onSaved: (value) => _character.biography = value!,
                    onChanged: (_) => _hasUnsavedChanges = true,
                    maxLines: 7,
                  ),
                if (_shouldShowField('biography')) const SizedBox(height: 16),
                if (_shouldShowField('abilities'))
                  CustomTextField(
                    label: S.of(context).abilities,
                    initialValue: _character.abilities,
                    alignLabel: true,
                    onSaved: (value) => _character.abilities = value!,
                    onChanged: (_) => _hasUnsavedChanges = true,
                    maxLines: 7,
                  ),
                if (_shouldShowField('abilities')) const SizedBox(height: 16),
                if (_shouldShowField('other'))
                  CustomTextField(
                    label: S.of(context).other,
                    initialValue: _character.other,
                    alignLabel: true,
                    onSaved: (value) => _character.other = value!,
                    onChanged: (_) => _hasUnsavedChanges = true,
                    maxLines: 5,
                  ),
                if (_shouldShowField('other')) const SizedBox(height: 32),
                CustomFieldsEditor(
                  initialFields: _customFields,
                  onFieldsChanged: (fields) {
                    _customFields = fields;
                    _hasUnsavedChanges = true;
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

  Widget _buildTagsInput(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).tags,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Tags(
          itemCount: _tags.length,
          itemBuilder: (index) => ItemTags(
            key: Key(index.toString()),
            index: index,
            title: _tags[index],
            active: true,
            //textStyle: theme.textTheme.bodyMedium,
            combine: ItemTagsCombine.withTextBefore,
            removeButton: ItemTagsRemoveButton(
              onRemoved: () {
                setState(() {
                  _tags.removeAt(index);
                  _hasUnsavedChanges = true;
                });
                return true;
              },
            ),
          ),
          textField: TagsTextField(
            inputDecoration: InputDecoration(
              hintText: S.of(context).add_tag,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (String tag) {
              if (tag.trim().isNotEmpty && !_tags.contains(tag)) {
                setState(() {
                  _tags.add(tag);
                  _hasUnsavedChanges = true;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectFolder(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final selected = await showModalBottomSheet<Folder>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    S.of(context).select_folder,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            Expanded(
              child: Material(
                color: Colors.transparent,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _characterFolders.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        leading: Icon(
                          Icons.folder_off,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        title: Text(
                          S.of(context).none,
                          style: textTheme.bodyLarge,
                        ),
                        onTap: () => Navigator.pop(context, null),
                      );
                    }

                    final folder = _characterFolders[index - 1];
                    return ListTile(
                      leading: Icon(
                        Icons.folder,
                        color: colorScheme.primary,
                      ),
                      title: Text(
                        folder.name,
                        style: textTheme.bodyLarge,
                      ),
                      trailing: _selectedFolder?.id == folder.id
                          ? Icon(
                              Icons.check,
                              color: colorScheme.primary,
                            )
                          : null,
                      onTap: () => Navigator.pop(context, folder),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null || _selectedFolder != null) {
      setState(() {
        _selectedFolder = selected;
        _character.folderId = selected?.id;
        _hasUnsavedChanges = true;
      });
    }
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
}