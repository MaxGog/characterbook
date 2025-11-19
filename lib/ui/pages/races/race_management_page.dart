import 'dart:typed_data';
import 'package:characterbook/ui/handlers/unsaved_changes_handler.dart';
import 'package:characterbook/ui/widgets/appbar/common_edit_app_bar.dart';
import 'package:characterbook/ui/widgets/sections/tags_and_folder_section.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../generated/l10n.dart';
import '../../../models/race_model.dart';
import '../../../models/folder_model.dart';
import '../../../services/folder_service.dart';
import '../../widgets/avatar_picker_widget.dart';
import '../../widgets/fields/custom_text_field.dart';
import '../../widgets/save_button_widget.dart';
import '../../widgets/base_edit_page_scaffold.dart';

class RaceManagementPage extends StatefulWidget {
  final Race? race;

  const RaceManagementPage({super.key, this.race});

  @override
  State<RaceManagementPage> createState() => _RaceManagementPageState();
}

class _RaceManagementPageState extends State<RaceManagementPage> with UnsavedChangesHandler {
  static const _logoSize = 120.0;
  static const _borderRadius = 12.0;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _biologyController;
  late final TextEditingController _backstoryController;
  Uint8List? _logoBytes;

  late final FolderService _folderService;
  List<Folder> _raceFolders = [];
  Folder? _selectedFolder;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _folderService = FolderService(Hive.box<Folder>('folders'));
    final race = widget.race;
    _nameController = TextEditingController(text: race?.name ?? '');
    _descriptionController = TextEditingController(text: race?.description ?? '');
    _biologyController = TextEditingController(text: race?.biology ?? '');
    _backstoryController = TextEditingController(text: race?.backstory ?? '');
    _logoBytes = race?.logo;
    _tags = List.from(widget.race?.tags ?? []);
    hasUnsavedChanges = widget.race == null;
    _setupControllers();
    _loadFolders();
  }

  @override
  Future<void> saveChanges() async => await _saveRace();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _biologyController.dispose();
    _backstoryController.dispose();
    super.dispose();
  }

  Future<void> _loadFolders() async {
    final folders = _folderService.getFoldersByType(FolderType.race);
    setState(() {
      _raceFolders = folders;
      _selectedFolder = widget.race?.folderId != null 
        ? _folderService.getFolderById(widget.race!.folderId!) 
        : null;
    });
  }

  void _setupControllers() {
    _nameController.addListener(() => setState(() => hasUnsavedChanges = true));
    _descriptionController.addListener(() => setState(() => hasUnsavedChanges = true));
    _biologyController.addListener(() => setState(() => hasUnsavedChanges = true));
    _backstoryController.addListener(() => setState(() => hasUnsavedChanges = true));
  }

  Future<void> _saveRace() async {
    if (!_formKey.currentState!.validate()) return;
    if (_nameController.text.isEmpty) {
      _showError(S.of(context).enter_race_name);
      return;
    }

    try {
      final raceBox = Hive.box<Race>('races');
      final race = widget.race ?? Race(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
      )
        ..name = _nameController.text
        ..description = _descriptionController.text
        ..biology = _biologyController.text
        ..backstory = _backstoryController.text
        ..logo = _logoBytes
        ..folderId = _selectedFolder?.id
        ..tags = _tags;

      int? raceKey;
      if (widget.race == null) {
        raceKey = await raceBox.add(race);
      } else {
        await race.save();
        raceKey = widget.race!.key;
      }

      if (_selectedFolder == null) {
        for (final folder in _raceFolders) {
          if (folder.contentIds.contains(raceKey.toString())) {
            await _folderService.removeFromFolder(folder.id, raceKey.toString());
          }
        }
      } else {
        for (final folder in _raceFolders) {
          if (folder.id != _selectedFolder!.id && 
              folder.contentIds.contains(raceKey.toString())) {
            await _folderService.removeFromFolder(folder.id, raceKey.toString());
          }
        }
        await _folderService.addToFolder(_selectedFolder!.id, raceKey.toString());
      }
    
      setState(() => hasUnsavedChanges = false);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      _showError('${S.of(context).save_error}: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    
    final title = widget.race == null ? s.new_race : s.edit_race;

    return BaseEditPageScaffold(
      onWillPop: () => handleUnsavedChanges(context),
      appBar: CommonEditAppBar(
        title: title,
        onSave: _saveRace,
        saveTooltip: s.save,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TagsAndFolderSection(
              tags: _tags,
              onTagsChanged: (tags) {
                setState(() {
                  _tags = tags;
                  hasUnsavedChanges = true;
                });
              },
              folderService: _folderService,
              folderType: FolderType.race,
              selectedFolder: _selectedFolder,
              onFolderSelected: (folder) {
                setState(() {
                  _selectedFolder = folder;
                  hasUnsavedChanges = true;
                });
              },
              folders: _raceFolders,
            ),
            const SizedBox(height: 24),
            AvatarPicker(
              currentAvatar: _logoBytes,
              onAvatarChanged: (bytes) {
                setState(() {
                  _logoBytes = bytes;
                  hasUnsavedChanges = true;
                });
              },
              size: _logoSize / 2,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _nameController,
              label: s.enter_race_name,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              label: s.description,
              maxLines: 3,
              alignLabel: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _biologyController,
              label: s.biology,
              maxLines: 5,
              alignLabel: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _backstoryController,
              label: s.backstory,
              maxLines: 7,
              alignLabel: true,
            ),
            const SizedBox(height: 32),
            SaveButton(
              onPressed: _saveRace,
              text: s.save_race,
            ),
          ],
        ),
      ),
    );
  }
}