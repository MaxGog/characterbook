import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/repositories/folder_repository.dart';
import 'package:characterbook/repositories/race_repository.dart';
import 'package:characterbook/services/folder_service.dart';
import 'package:characterbook/ui/controllers/race_management_controller.dart';
import 'package:characterbook/ui/widgets/appbar/common_edit_app_bar.dart';
import 'package:characterbook/ui/widgets/avatar_picker_widget.dart';
import 'package:characterbook/ui/widgets/base_edit_page_scaffold.dart';
import 'package:characterbook/ui/widgets/buttons/save_button_widget.dart';
import 'package:characterbook/ui/widgets/fields/custom_text_field.dart';
import 'package:characterbook/ui/widgets/fields/fullscreen_field_preview.dart';
import 'package:characterbook/ui/widgets/fields/fullscreen_text_editor.dart';
import 'package:characterbook/ui/widgets/sections/tags_and_folder_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RaceManagementScreen extends StatefulWidget {
  final Race? race;

  const RaceManagementScreen({super.key, this.race});

  @override
  State<RaceManagementScreen> createState() => _RaceManagementScreenState();
}

class _RaceManagementScreenState extends State<RaceManagementScreen> {
  static const _logoSize = 120.0;
  static const _fieldSpacing = 16.0;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RaceManagementController(
        raceRepo: context.read<RaceRepository>(),
        folderRepo: context.read<FolderRepository>(),
        race: widget.race,
      ),
      child: Consumer<RaceManagementController>(
        builder: (context, controller, child) {
          final s = S.of(context);
          final title = widget.race == null ? s.new_race : s.edit_race;

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
                    Navigator.pop(context, true);
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
                  const SizedBox(height: 24),
                  _buildLogoSection(context, controller),
                  const SizedBox(height: 24),
                  _buildNameField(context, controller),
                  const SizedBox(height: _fieldSpacing),
                  _buildDescriptionField(context, controller),
                  const SizedBox(height: _fieldSpacing),
                  _buildBiologyField(context, controller),
                  const SizedBox(height: _fieldSpacing),
                  _buildBackstoryField(context, controller),
                  const SizedBox(height: 32),
                  SaveButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final success = await controller.save();
                        if (success && mounted) {
                          Navigator.pop(context, true);
                        }
                      }
                    },
                    text: s.save_race,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFolderAndTagsSection(
      BuildContext context, RaceManagementController controller) {
    final folderService = context.read<FolderService>();
    return TagsAndFolderSection(
      tags: controller.tags,
      onTagsChanged: controller.setTags,
      folderService: folderService,
      folderType: FolderType.race,
      selectedFolder: controller.selectedFolder,
      onFolderSelected: controller.setSelectedFolder,
      folders: controller.availableFolders,
    );
  }

  Widget _buildLogoSection(
      BuildContext context, RaceManagementController controller) {
    return AvatarPicker(
      currentAvatar: controller.race.logo,
      onAvatarChanged: (bytes) => controller.updateLogo(bytes),
      size: _logoSize / 2,
    );
  }

  Widget _buildNameField(BuildContext context, RaceManagementController controller) {
    final s = S.of(context);
    return CustomTextField(
      label: s.enter_race_name,
      initialValue: controller.race.name,
      isRequired: true,
      onSaved: (value) => controller.updateName(value ?? ''),
      validator: (value) {
        if (value?.isEmpty ?? true) return s.enter_race_name;
        return null;
      },
    );
  }

  Widget _buildDescriptionField(
      BuildContext context, RaceManagementController controller) {
    final s = S.of(context);
    return FullscreenFieldPreview(
      label: s.description,
      value: controller.race.description,
      onTap: () => _openFullscreenEditor(
        context,
        controller,
        s.description,
        (value) => controller.updateDescription(value),
        controller.race.description,
      ),
      maxPreviewLines: 3,
    );
  }

  Widget _buildBiologyField(
      BuildContext context, RaceManagementController controller) {
    final s = S.of(context);
    return FullscreenFieldPreview(
      label: s.biology,
      value: controller.race.biology,
      onTap: () => _openFullscreenEditor(
        context,
        controller,
        s.biology,
        (value) => controller.updateBiology(value),
        controller.race.biology,
      ),
      maxPreviewLines: 5,
    );
  }

  Widget _buildBackstoryField(
      BuildContext context, RaceManagementController controller) {
    final s = S.of(context);
    return FullscreenFieldPreview(
      label: s.backstory,
      value: controller.race.backstory,
      onTap: () => _openFullscreenEditor(
        context,
        controller,
        s.backstory,
        (value) => controller.updateBackstory(value),
        controller.race.backstory,
      ),
      maxPreviewLines: 7,
    );
  }

  Future<void> _openFullscreenEditor(
    BuildContext context,
    RaceManagementController controller,
    String title,
    Function(String) onSave,
    String initialValue,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenTextEditor(
          title: title,
          initialValue: initialValue,
          onChanged: onSave,
        ),
      ),
    );
    if (result != null) {
      onSave(result);
    }
  }
}
