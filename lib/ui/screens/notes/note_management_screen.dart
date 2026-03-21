import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/repositories/folder_repository.dart';
import 'package:characterbook/repositories/note_repository.dart';
import 'package:characterbook/services/folder_service.dart';
import 'package:characterbook/services/note_service.dart';
import 'package:characterbook/ui/controllers/note_management_controller.dart';
import 'package:characterbook/ui/widgets/appbar/common_edit_app_bar.dart';
import 'package:characterbook/ui/widgets/avatar_widget.dart';
import 'package:characterbook/ui/widgets/buttons/save_button_widget.dart';
import 'package:characterbook/ui/widgets/fields/custom_text_field.dart';
import 'package:characterbook/ui/widgets/markdown_context_menu.dart';
import 'package:characterbook/ui/widgets/sections/tags_and_folder_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hive/hive.dart';
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

  const _NoteManagementScreenContent(
      {this.note, this.isCopyMode = false});

  @override
  State<_NoteManagementScreenContent> createState() =>
      _NoteManagementScreenContentState();
}

class _NoteManagementScreenContentState extends State<_NoteManagementScreenContent> {
  static const _fieldSpacing = 16.0;

  final GlobalKey<FormState> _formKey = GlobalKey();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  bool _isPreviewMode = false;
  bool _isMetaCardExpanded = true;
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
    final controller = context.read<NoteManagementController>();
    controller.updateTitle(_titleController.text);
  }

  void _onContentChanged() {
    final controller = context.read<NoteManagementController>();
    controller.updateContent(_contentController.text);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _contentController.removeListener(_onContentChanged);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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

        final additionalActions = [
          IconButton.filledTonal(
            onPressed: () => _shareNote(context, controller),
            icon: const Icon(Icons.share_rounded),
            tooltip: s.share,
            style: IconButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed: () => _copyToClipboard(context, controller),
            icon: const Icon(Icons.copy_rounded),
            tooltip: s.copy,
            style: IconButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed: _togglePreviewMode,
            icon: Icon(
                _isPreviewMode ? Icons.edit_rounded : Icons.preview_rounded),
            tooltip: _isPreviewMode ? s.edit : s.grid_view,
            style: IconButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(width: 8),
        ];

        return WillPopScope(
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
          child: Scaffold(
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
              additionalActions: additionalActions,
            ),
            body: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _buildContentField(controller),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    top: _isMetaCardExpanded ? 16 : 0,
                    left: 16,
                    right: 16,
                    child: _isMetaCardExpanded
                        ? _buildMetaCard(controller)
                        : _buildCollapsedMetaCard(controller),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

  void _toggleMetaCard() {
    setState(() => _isMetaCardExpanded = !_isMetaCardExpanded);
  }

  Widget _buildMetaCard(NoteManagementController controller) {
    final s = S.of(context);
    return Card(
      elevation: 8,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _titleController,
                    label: s.name,
                    isRequired: true,
                  ),
                ),
                IconButton(
                  onPressed: _toggleMetaCard,
                  icon: const Icon(Icons.keyboard_arrow_up),
                  tooltip: "Collapse",
                ),
              ],
            ),
            const SizedBox(height: _fieldSpacing),
            TagsAndFolderSection(
              tags: controller.tags,
              onTagsChanged: controller.setTags,
              folderService: context.read<FolderService>(),
              folderType: FolderType.note,
              selectedFolder: controller.selectedFolder,
              onFolderSelected: controller.setSelectedFolder,
              folders: controller.availableFolders,
            ),
            const SizedBox(height: _fieldSpacing),
            _CharacterSelectorSection(
              selectedCharacterIds: controller.selectedCharacterIds,
              onAddCharacter: controller.addCharacterId,
              onRemoveCharacter: controller.removeCharacterId,
            ),
            const SizedBox(height: _fieldSpacing),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedMetaCard(NoteManagementController controller) {
    final charactersBox = Hive.box<Character>('characters');
    final selectedCharacters = controller.selectedCharacterIds
        .map((id) => charactersBox.get(id))
        .where((character) => character != null)
        .cast<Character>()
        .toList();

    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.title.isEmpty
                        ? S.of(context).name
                        : controller.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (controller.tags.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      controller.tags.join(', '),
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (selectedCharacters.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    _buildSelectedCharactersPreview(selectedCharacters),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: _toggleMetaCard,
              icon: const Icon(Icons.keyboard_arrow_down),
              tooltip: "Expand",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentField(NoteManagementController controller) {
    if (_isPreviewMode) {
      return Container(
        margin: EdgeInsets.only(top: _isMetaCardExpanded ? 180 : 60),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: MarkdownBody(
            data: _contentController.text,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: _isMetaCardExpanded ? 180 : 60),
      child: SingleChildScrollView(
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
      ),
    );
  }

  Widget _buildSelectedCharactersPreview(List<Character> characters) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: characters.map((character) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AvatarWidget.character(
              imageBytes: character.imageBytes,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              character.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      }).toList(),
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
    final characters = Hive.box<Character>('characters').values.toList();
    final charactersBox = Hive.box<Character>('characters');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: null,
          decoration: InputDecoration(
            labelText:
                '${S.of(context).choose_character} ${S.of(context).character.toLowerCase()}',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          dropdownColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          style: Theme.of(context).textTheme.bodyLarge,
          borderRadius: BorderRadius.circular(12),
          items: characters.map((character) {
            final characterKey =
                charactersBox.keyAt(characters.indexOf(character)).toString();
            final isSelected = selectedCharacterIds.contains(characterKey);
            return DropdownMenuItem(
              value: characterKey,
              child: Row(
                children: [
                  if (isSelected)
                    Icon(Icons.check,
                        color: Theme.of(context).colorScheme.primary, size: 20),
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
              context, selectedCharacterIds, charactersBox, onRemoveCharacter),
      ],
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
        final character = charactersBox.get(characterId);
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
