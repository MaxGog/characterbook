import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/data/models/character_model.dart';
import 'package:characterbook/data/models/folder_model.dart';
import 'package:characterbook/data/models/note_model.dart';
import 'package:characterbook/data/repositories/folder_repository.dart';
import 'package:characterbook/data/repositories/note_repository.dart';
import 'package:characterbook/data/services/folder_service.dart';
import 'package:characterbook/data/services/note_service.dart';
import 'package:characterbook/ui/controllers/note_management_controller.dart';
import 'package:characterbook/ui/widgets/appbar/common_edit_app_bar.dart';
import 'package:characterbook/ui/widgets/avatar_widget.dart';
import 'package:characterbook/ui/widgets/fields/custom_text_field.dart';
import 'package:characterbook/ui/widgets/markdown_context_menu.dart';
import 'package:characterbook/ui/widgets/sections/tags_and_folder_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class NoteManagementScreen extends StatelessWidget {
  final Note? note;
  final bool isCopyMode;

  const NoteManagementScreen({super.key, this.note, this.isCopyMode = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoteManagementController(
        noteRepo: context.read<NoteRepository>(),
        folderRepo: context.read<FolderRepository>(),
        noteService: context.read<NoteService>(),
        note: note,
        isCopyMode: isCopyMode,
      ),
      child: _NoteManagementScreenContent(
        note: note,
        isCopyMode: isCopyMode,
      ),
    );
  }
}

class _NoteManagementScreenContent extends StatefulWidget {
  final Note? note;
  final bool isCopyMode;

  const _NoteManagementScreenContent({this.note, this.isCopyMode = false});

  @override
  State<_NoteManagementScreenContent> createState() =>
      _NoteManagementScreenContentState();
}

class _NoteManagementScreenContentState
    extends State<_NoteManagementScreenContent> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  bool _isPreviewMode = false;
  bool _listenersAdded = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller =
        Provider.of<NoteManagementController>(context, listen: false);

    if (_titleController.text != controller.title) {
      _titleController.text = controller.title;
    }
    if (_contentController.text != controller.content) {
      _contentController.text = controller.content;
    }

    if (!_listenersAdded) {
      _titleController.addListener(_onTitleChanged);
      _contentController.addListener(_onContentChanged);
      _listenersAdded = true;
    }
  }

  void _onTitleChanged() {
    context.read<NoteManagementController>().updateTitle(_titleController.text);
  }

  void _onContentChanged() {
    context
        .read<NoteManagementController>()
        .updateContent(_contentController.text);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _contentController.removeListener(_onContentChanged);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote(NoteManagementController controller) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final success = await controller.save();
    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).error),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _shareNote(
      BuildContext context, NoteManagementController controller) async {
    try {
      await controller.share(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${S.of(context).error}: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _copyToClipboard(
      BuildContext context, NoteManagementController controller) async {
    await controller.copyToClipboard(context);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).operationCompleted)),
      );
    }
  }

  void _togglePreviewMode() {
    setState(() => _isPreviewMode = !_isPreviewMode);
  }

  void _showMetadataSheet(
      BuildContext context, NoteManagementController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(ctx).settings,
              style: Theme.of(ctx).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _titleController,
                      label: S.of(ctx).name,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    TagsAndFolderSection(
                      tags: controller.tags,
                      onTagsChanged: controller.setTags,
                      folderService: context.read<FolderService>(),
                      folderType: FolderType.note,
                      selectedFolder: controller.selectedFolder,
                      onFolderSelected: controller.setSelectedFolder,
                      folders: controller.availableFolders,
                    ),
                    const SizedBox(height: 16),
                    _CharacterSelectorSection(
                      selectedCharacterIds: controller.selectedCharacterIds,
                      onAddCharacter: controller.addCharacterId,
                      onRemoveCharacter: controller.removeCharacterId,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(S.of(ctx).close),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteManagementController>(
      builder: (context, controller, child) {
        final s = S.of(context);
        final title = widget.note == null
            ? s.create
            : widget.isCopyMode
                ? '${s.copy} ${s.posts.toLowerCase()}'
                : s.edit;

        return PopScope(
          canPop: !controller.hasUnsavedChanges,
          onPopInvoked: (didPop) async {
            if (didPop) return;
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
            if (shouldLeave == true && mounted) {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            appBar: CommonEditAppBar(
              title: title,
              onSave: () {}, // Сохранение теперь в BottomAppBar
              saveTooltip: s.save,
            ),
            body: Form(
              key: _formKey,
              child: _buildContentField(controller),
            ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  if (controller.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox.square(
                        dimension: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else
                    IconButton(
                      onPressed: () => _saveNote(controller),
                      icon: const Icon(Icons.save_rounded),
                      tooltip: S.of(context).save,
                      style: IconButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  IconButton(
                    onPressed: controller.isLoading
                        ? null
                        : () => _shareNote(context, controller),
                    icon: const Icon(Icons.share_rounded),
                    tooltip: S.of(context).share,
                  ),
                  IconButton(
                    onPressed: controller.isLoading
                        ? null
                        : () => _copyToClipboard(context, controller),
                    icon: const Icon(Icons.copy_rounded),
                    tooltip: S.of(context).copy,
                  ),
                  IconButton(
                    onPressed: controller.isLoading
                        ? null
                        : () => _showMetadataSheet(context, controller),
                    icon: const Icon(Icons.edit_note_rounded),
                    tooltip: S.of(context).settings,
                  ),
                  const Spacer(),
                  FloatingActionButton(
                    onPressed: controller.isLoading ? null : _togglePreviewMode,
                    tooltip: _isPreviewMode
                        ? S.of(context).edit
                        : S.of(context).grid_view,
                    child: Icon(_isPreviewMode
                        ? Icons.edit_rounded
                        : Icons.preview_rounded),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentField(NoteManagementController controller) {
    if (_isPreviewMode) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: MarkdownBody(
          data: _contentController.text,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: _contentController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: S.of(context).start_writing,
          hintStyle: const TextStyle(fontSize: 16),
          contentPadding: EdgeInsets.zero,
        ),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              height: 1.5,
            ),
        contextMenuBuilder: (context, editableTextState) {
          return MarkdownContextMenu(
            controller: _contentController,
            editableTextState: editableTextState,
          );
        },
      ),
    );
  }
}

class _CharacterSelectorSection extends StatelessWidget {
  final List<String> selectedCharacterIds;
  final ValueChanged<String> onAddCharacter;
  final ValueChanged<String> onRemoveCharacter;

  const _CharacterSelectorSection({
    required this.selectedCharacterIds,
    required this.onAddCharacter,
    required this.onRemoveCharacter,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Character>('characters').listenable(),
      builder: (context, Box<Character> box, _) {
        // Безопасно получаем пары (ключ → персонаж), преобразуя ключ в строку
        final entries = box.keys
            .map((key) {
              final character = box.get(key);
              return MapEntry(key.toString(), character);
            })
            .where((entry) => entry.value != null)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: null,
              decoration: InputDecoration(
                labelText:
                    '${S.of(context).choose_character} ${S.of(context).character.toLowerCase()}',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              dropdownColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              style: Theme.of(context).textTheme.bodyLarge,
              borderRadius: BorderRadius.circular(12),
              items: entries.map((entry) {
                final character = entry.value!;
                final characterKey = entry.key; // уже String
                final isSelected = selectedCharacterIds.contains(characterKey);
                return DropdownMenuItem<String>(
                  value: characterKey,
                  child: Row(
                    children: [
                      if (isSelected)
                        Icon(Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20),
                      const SizedBox(width: 8),
                      AvatarWidget.character(
                        imageBytes: character.imageBytes,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        character.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  if (selectedCharacterIds.contains(value)) {
                    onRemoveCharacter(value);
                  } else {
                    onAddCharacter(value);
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            if (selectedCharacterIds.isNotEmpty)
              _buildSelectedCharactersChips(
                  context, selectedCharacterIds, box, onRemoveCharacter),
          ],
        );
      },
    );
  }

  Widget _buildSelectedCharactersChips(
    BuildContext context,
    List<String> selectedIds,
    Box<Character> charactersBox,
    ValueChanged<String> onRemove,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: selectedIds.map((characterId) {
        dynamic actualKey;
        try {
          actualKey = int.parse(characterId);
        } catch (_) {
          actualKey = characterId;
        }
        final character = charactersBox.get(actualKey);
        return character != null
            ? InputChip(
                avatar: AvatarWidget.character(
                  imageBytes: character.imageBytes,
                  size: 20,
                ),
                label: Text(character.name),
                onDeleted: () => onRemove(characterId),
                deleteIcon: Icon(
                  Icons.close,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              )
            : const SizedBox();
      }).toList(),
    );
  }
}
