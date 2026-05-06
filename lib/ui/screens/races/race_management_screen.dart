import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/data/models/folder_model.dart';
import 'package:characterbook/data/models/race_model.dart';
import 'package:characterbook/data/repositories/folder_repository.dart';
import 'package:characterbook/data/repositories/race_repository.dart';
import 'package:characterbook/data/services/folder_service.dart';
import 'package:characterbook/ui/controllers/race_management_controller.dart';
import 'package:characterbook/ui/screens/field_editor_screen.dart';
import 'package:characterbook/ui/widgets/avatar_picker_widget.dart';
import 'package:characterbook/ui/widgets/fields/custom_text_field.dart';
import 'package:characterbook/ui/widgets/fields/fullscreen_field_preview.dart';
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
  static const _sectionSpacing = 24.0;
  static const _maxFormWidth = 600.0;

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
          return Scaffold(
            body: WillPopScope(
              onWillPop: () => _onWillPop(context, controller),
              child: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(context, controller, s),
                  SliverToBoxAdapter(
                    child: SafeArea(
                      minimum: const EdgeInsets.all(16),
                      child: Center(
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(maxWidth: _maxFormWidth),
                          child: Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: _sectionSpacing),
                                _buildFolderAndTagsSection(context, controller),
                                const SizedBox(height: _sectionSpacing),
                                Center(
                                  child: _buildLogoSection(context, controller),
                                ),
                                const SizedBox(height: _sectionSpacing),
                                _buildNameField(context, controller),
                                const SizedBox(height: _fieldSpacing),
                                _buildDescriptionField(context, controller),
                                const SizedBox(height: _fieldSpacing),
                                _buildBiologyField(context, controller),
                                const SizedBox(height: _fieldSpacing),
                                _buildBackstoryField(context, controller),
                                const SizedBox(height: _sectionSpacing),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    RaceManagementController controller,
    S s,
  ) {
    final title = widget.race == null ? s.new_race : s.edit_race;
    return SliverAppBar.large(
      title: Text(title),
      pinned: true,
      floating: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: s.save,
          onPressed: () => _saveRace(controller, s),
        ),
      ],
    );
  }

  Future<bool> _onWillPop(
    BuildContext context,
    RaceManagementController controller,
  ) async {
    if (controller.hasUnsavedChanges) {
      final s = S.of(context);
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
  }

  Future<void> _saveRace(
    RaceManagementController controller,
    S s,
  ) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final success = await controller.save();
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.save)),
        );
        Navigator.of(context).pop(true);
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(s.error),
            content: Text(controller.error ?? s.error),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(s.ok),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget _buildFolderAndTagsSection(
    BuildContext context,
    RaceManagementController controller,
  ) {
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
    BuildContext context,
    RaceManagementController controller,
  ) {
    return AvatarPicker(
      currentAvatar: controller.race.logo,
      onAvatarChanged: (bytes) => controller.updateLogo(bytes),
      size: _logoSize / 2,
    );
  }

  Widget _buildNameField(
    BuildContext context,
    RaceManagementController controller,
  ) {
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
    BuildContext context,
    RaceManagementController controller,
  ) {
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
    BuildContext context,
    RaceManagementController controller,
  ) {
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
    BuildContext context,
    RaceManagementController controller,
  ) {
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
    String label,
    Function(String) onSave,
    String initialValue,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FieldEditorScreen(
          title: label,
          initialValue: initialValue,
          onAutoSave: (result) => onSave(result.value),
          initialKey: 'description',
        ),
      ),
    );
    if (result != null && mounted) {
      onSave(result.value);
    }
  }
}
