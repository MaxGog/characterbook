import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:characterbook/repositories/character_repository.dart';
import 'package:characterbook/repositories/folder_repository.dart';
import 'package:characterbook/repositories/race_repository.dart';
import 'package:characterbook/services/folder_service.dart';
import 'package:characterbook/ui/controllers/character_management_controller.dart';
import 'package:characterbook/ui/widgets/appbar/common_edit_app_bar.dart';
import 'package:characterbook/ui/widgets/avatar_picker_widget.dart';
import 'package:characterbook/ui/widgets/base_edit_page_scaffold.dart';
import 'package:characterbook/ui/widgets/buttons/save_button_widget.dart';
import 'package:characterbook/ui/widgets/fields/custom_fields_editor.dart';
import 'package:characterbook/ui/widgets/fields/custom_text_field.dart';
import 'package:characterbook/ui/widgets/fields/fullscreen_text_editor.dart';
import 'package:characterbook/ui/widgets/fields/gender_selector_field.dart';
import 'package:characterbook/ui/widgets/fields/race_selector_field.dart';
import 'package:characterbook/ui/widgets/reference_image_picker.dart';
import 'package:characterbook/ui/widgets/sections/image_gallery_section.dart';
import 'package:characterbook/ui/widgets/sections/tags_and_folder_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CharacterManagementScreen extends StatefulWidget {
  final Character? character;
  final QuestionnaireTemplate? template;

  const CharacterManagementScreen({super.key, this.character, this.template});

  @override
  State<CharacterManagementScreen> createState() => _CharacterManagementScreenState();
}

class _CharacterManagementScreenState extends State<CharacterManagementScreen> {
  static const _sectionSpacing = 24.0;
  static const _fieldSpacing = 16.0;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharacterManagementController(
        characterRepo: context.read<CharacterRepository>(),
        raceRepo: context.read<RaceRepository>(),
        folderRepo: context.read<FolderRepository>(),
        character: widget.character,
        template: widget.template,
      ),
      child: Consumer<CharacterManagementController>(
        builder: (context, controller, child) {
          final s = S.of(context);
          final title = _buildPageTitle(s);

          return BaseEditPageScaffold(
            onWillPop: () async {
              if (controller.hasUnsavedChanges) {
                final shouldLeave = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(s.unsaved_changes_title),
                    content: Text(s.unsaved_changes_content),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(s.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(s.close),
                      ),
                    ],
                  ),
                );
                return shouldLeave ?? false;
              }
              return true;
            },
            appBar: CommonEditAppBar(
              title: title,
              onSave: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final success = await controller.save();
                  if (success && mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              saveTooltip: s.save,
            ),
            body: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFolderAndTagsSection(context, controller),
                  if (widget.template != null) _buildTemplateChip(context),
                  const SizedBox(height: _sectionSpacing),
                  _buildAvatarSection(context, controller),
                  const SizedBox(height: _sectionSpacing),
                  _buildNameField(context, controller),
                  const SizedBox(height: _fieldSpacing),
                  ..._buildCharacterFields(context, controller),
                  const SizedBox(height: _sectionSpacing),
                  SaveButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final success = await controller.save();
                        if (success && mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    text: s.save,
                  ),
                  const SizedBox(height: _fieldSpacing),
                ],
              ),
            ),
          );
        },
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

  Widget _buildFolderAndTagsSection(
      BuildContext context, CharacterManagementController controller) {
    final folderService = context.read<FolderService>();
    return TagsAndFolderSection(
      tags: controller.tags,
      onTagsChanged: controller.setTags,
      folderService: folderService,
      folderType: FolderType.character,
      selectedFolder: controller.selectedFolder,
      onFolderSelected: controller.setSelectedFolder,
      folders: controller.availableFolders,
    );
  }

  Widget _buildTemplateChip(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: _fieldSpacing),
      child: Chip(
        label: Text(
          '${s.template}: ${widget.template!.name}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }

  Widget _buildAvatarSection(
      BuildContext context, CharacterManagementController controller) {
    return AvatarPicker(
      currentAvatar: controller.character.imageBytes,
      onAvatarChanged: (bytes) {
        controller.updateMainImage(bytes);
      },
    );
  }

  Widget _buildNameField(
      BuildContext context, CharacterManagementController controller) {
    final s = S.of(context);
    return CustomTextField(
      label: s.name,
      initialValue: controller.character.name,
      isRequired: true,
      onSaved: (value) => controller.updateName(value ?? ''),
      validator: (value) {
        if (value?.isEmpty ?? true) return s.name;
        return null;
      },
    );
  }

  List<Widget> _buildCharacterFields(
      BuildContext context, CharacterManagementController controller) {
    final s = S.of(context);
    final fields = <Widget>[];

    if (_shouldShowField('age') || _shouldShowField('gender')) {
      fields.addAll([
        _buildAgeAndGenderRow(context, controller),
        const SizedBox(height: _fieldSpacing),
      ]);
    }

    if (_shouldShowField('race')) {
      fields.addAll([
        RaceSelectorField(
          initialRace: controller.character.race,
          onChanged: (race) => controller.updateRace(race),
        ),
        const SizedBox(height: _fieldSpacing),
      ]);
    }

    if (_shouldShowField('referenceImage')) {
      fields.addAll([
        ReferenceImagePicker(
          imageBytes: controller.character.referenceImageBytes,
          onPickImage: () => _pickReferenceImage(context, controller),
          title: s.reference_image,
        ),
        const SizedBox(height: _fieldSpacing),
      ]);
    }

    fields.addAll([
      CustomFieldsEditor(
        initialFields: controller.customFields,
        onFieldsChanged: controller.setCustomFields,
        verticalLayout: true,
      ),
    ]);

    if (_shouldShowField('additionalImages')) {
      fields.addAll([
        const SizedBox(height: _fieldSpacing),
        ImageGallerySection(
          images: controller.additionalImages,
          onAddImage: () => _pickAdditionalImage(context, controller),
          onRemoveImage: (index) => controller.removeAdditionalImage(index),
          title: s.additional_images,
          emptyText: s.no_additional_images,
          addTooltip: s.add_picture,
        ),
      ]);
    }

    final fullscreenFields = [
      ('appearance', s.appearance),
      ('personality', s.personality),
      ('biography', s.biography),
      ('abilities', s.abilities),
      ('other', s.other),
    ];

    for (final (fieldName, label) in fullscreenFields) {
      if (_shouldShowField(fieldName)) {
        fields.addAll([
          const SizedBox(height: _fieldSpacing),
          _FullscreenTextField(
            label: label,
            value: _getFieldValue(controller, fieldName) ?? '',
            onChanged: (value) => controller.updateTextField(fieldName, value),
            onTap: () =>
                _openFullscreenEditor(context, controller, fieldName, label),
            maxLines: 3,
          ),
        ]);
      }
    }

    return fields;
  }

  String? _getFieldValue(CharacterManagementController controller, String fieldName) {
    switch (fieldName) {
      case 'appearance':
        return controller.character.appearance;
      case 'personality':
        return controller.character.personality;
      case 'biography':
        return controller.character.biography;
      case 'abilities':
        return controller.character.abilities;
      case 'other':
        return controller.character.other;
      default:
        return '';
    }
  }

  Future<void> _openFullscreenEditor(
    BuildContext context,
    CharacterManagementController controller,
    String fieldName,
    String label,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenTextEditor(
          title: label,
          initialValue: _getFieldValue(controller, fieldName) ?? '',
          onChanged: (value) {
            controller.updateTextField(fieldName, value);
          },
        ),
      ),
    );
    if (result != null) {
      controller.updateTextField(fieldName, result);
    }
  }

  Widget _buildAgeAndGenderRow(
      BuildContext context, CharacterManagementController controller) {
    final s = S.of(context);
    return Row(
      children: [
        if (_shouldShowField('age')) ...[
          Expanded(
            child: CustomTextField(
              label: s.age,
              initialValue: controller.character.age.toString(),
              isRequired: _shouldShowField('age'),
              keyboardType: TextInputType.number,
              onSaved: (value) =>
                  controller.updateAge(int.tryParse(value ?? '0') ?? 0),
              validator: _shouldShowField('age')
                  ? (value) {
                      if (value?.isEmpty ?? true) return s.enter_age;
                      final age = int.tryParse(value!);
                      if (age == null || age <= 0) return s.invalid_age;
                      return null;
                    }
                  : null,
            ),
          ),
          if (_shouldShowField('gender')) const SizedBox(width: _fieldSpacing),
        ],
        if (_shouldShowField('gender'))
          Expanded(
            child: GenderSelectorField(
              initialValue: controller.character.gender,
              onChanged: (value) => controller.updateGender(value ?? ''),
            ),
          ),
      ],
    );
  }

  Future<void> _pickReferenceImage(
      BuildContext context, CharacterManagementController controller) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      controller.updateReferenceImage(bytes);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  Future<void> _pickAdditionalImage(
      BuildContext context, CharacterManagementController controller) async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      if (!mounted) return;
      controller.addAdditionalImage(bytes);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${S.of(context).error}: $message'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  bool _shouldShowField(String fieldName) {
    return widget.template?.containsField(fieldName) ?? true;
  }
}

class _FullscreenTextField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;
  final int? maxLines;

  const _FullscreenTextField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.onTap,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Icon(
                  Icons.open_in_full,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value.isEmpty ? '${s.edit}...' : value,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: value.isEmpty
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : null,
                    fontStyle: value.isEmpty ? FontStyle.italic : null,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
