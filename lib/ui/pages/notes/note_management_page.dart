import 'package:characterbook/ui/handlers/unsaved_changes_handler.dart';
import 'package:characterbook/ui/widgets/appbar/common_edit_app_bar.dart';
import 'package:characterbook/ui/widgets/sections/tags_and_folder_section.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../generated/l10n.dart';
import '../../../models/characters/character_model.dart';
import '../../../models/folder_model.dart';
import '../../../models/note_model.dart';
import '../../../services/clipboard_service.dart';
import '../../../services/folder_service.dart';
import '../../widgets/fields/custom_text_field.dart';
import '../../widgets/markdown_context_menu.dart';
import '../../widgets/save_button_widget.dart';

class NoteEditPage extends StatefulWidget {
  final Note? note;
  final bool isCopyMode;

  const NoteEditPage({super.key, this.note, this.isCopyMode = false});

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> with UnsavedChangesHandler {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final List<String> _selectedCharacterIds = [];
  bool _isPreviewMode = false;
  bool _isMetaCardExpanded = true;

  late final FolderService _folderService;
  List<Folder> _noteFolders = [];
  Folder? _selectedFolder;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _folderService = FolderService(Hive.box<Folder>('folders'));
    _titleController = TextEditingController(
      text: widget.isCopyMode ? '${S.of(context).copy}: ${widget.note?.title ?? ''}' 
                            : widget.note?.title ?? '',
    );
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _selectedCharacterIds.addAll(widget.note?.characterIds ?? []);
    _isPreviewMode = widget.note != null && !widget.isCopyMode;
    _selectedFolder = widget.note?.folderId != null 
        ? _folderService.getFolderById(widget.note!.folderId!) 
        : null;
    _tags = List.from(widget.note?.tags ?? []);

    _titleController.addListener(_checkForChanges);
    _contentController.addListener(_checkForChanges);
    _loadFolders();
    hasUnsavedChanges = widget.note == null || widget.isCopyMode;
  }

  @override
  Future<void> saveChanges() async => await _saveNote();

  Future<void> _loadFolders() async {
    final folders = _folderService.getFoldersByType(FolderType.note);
    setState(() {
      _noteFolders = folders;
    });
  }

  void _checkForChanges() {
    final hasTitleChanges = widget.note?.title != _titleController.text;
    final hasContentChanges = widget.note?.content != _contentController.text;
    setState(() {
      hasUnsavedChanges = hasTitleChanges || hasContentChanges;
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_checkForChanges);
    _contentController.removeListener(_checkForChanges);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).save_error)),
      );
      return;
    }

    final notesBox = Hive.box<Note>('notes');
    final now = DateTime.now();

    int? noteKey;
    if (widget.note != null && !widget.isCopyMode) {
      widget.note!
        ..title = title
        ..content = _contentController.text.trim()
        ..characterIds = _selectedCharacterIds
        ..folderId = _selectedFolder?.id
        ..updatedAt = now
        ..tags = _tags;
      await notesBox.put(widget.note!.key, widget.note!);
      noteKey = widget.note!.key;
    } else {
      noteKey = await notesBox.add(Note(
        id: now.millisecondsSinceEpoch.toString(),
        title: title,
        content: _contentController.text.trim(),
        characterIds: _selectedCharacterIds,
        folderId: _selectedFolder?.id,
        tags: _tags,
      ));
    }

    if (_selectedFolder == null) {
      for (final folder in _noteFolders) {
        if (folder.contentIds.contains(noteKey.toString())) {
          await _folderService.removeFromFolder(folder.id, noteKey.toString());
        }
      }
    } else {
      for (final folder in _noteFolders) {
        if (folder.id != _selectedFolder!.id && 
            folder.contentIds.contains(noteKey.toString())) {
          await _folderService.removeFromFolder(folder.id, noteKey.toString());
        }
      }
      await _folderService.addToFolder(_selectedFolder!.id, noteKey.toString());
    }
  
    setState(() => hasUnsavedChanges = false);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _copyToClipboard() async {
    await ClipboardService.copyNoteToClipboard(
      context: context,
      content: _contentController.text,
    );

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

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    
    final title = widget.note == null
        ? s.create
        : widget.isCopyMode
            ? '${s.copy} ${s.posts.toLowerCase()}'
            : s.edit;

    final additionalActions = [
      IconButton.filledTonal(
        onPressed: _copyToClipboard,
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
        icon: Icon(_isPreviewMode ? Icons.edit_rounded : Icons.preview_rounded),
        tooltip: _isPreviewMode ? s.edit : s.grid_view,
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
        ),
      ),
      const SizedBox(width: 8),
    ];

    return Scaffold(
      appBar: CommonEditAppBar(
        title: title,
        onSave: _saveNote,
        saveTooltip: s.save,
        additionalActions: additionalActions,
      ),
      body: WillPopScope(
        onWillPop: () => handleUnsavedChanges(context),
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Positioned.fill(
                child: _buildContentField(),
              ),
              
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: _isMetaCardExpanded ? 16 : 0,
                left: 16,
                right: 16,
                child: _isMetaCardExpanded 
                    ? _buildMetaCard() 
                    : _buildCollapsedMetaCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaCard() {
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
                    label: S.of(context).name,
                    isRequired: true,
                    onChanged: (value) => _checkForChanges(),
                  ),
                ),
                IconButton(
                  onPressed: _toggleMetaCard,
                  icon: const Icon(Icons.keyboard_arrow_up),
                  tooltip: "Collapse",
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            TagsAndFolderSection(
              tags: _tags,
              onTagsChanged: (tags) {
                setState(() {
                  _tags = tags;
                  hasUnsavedChanges = true;
                });
              },
              folderService: _folderService,
              folderType: FolderType.note,
              selectedFolder: _selectedFolder,
              onFolderSelected: (folder) {
                setState(() {
                  _selectedFolder = folder;
                  hasUnsavedChanges = true;
                });
              },
              folders: _noteFolders,
            ),
            
            const SizedBox(height: 16),
            
            _CharacterSelectorSection(
              selectedCharacterIds: _selectedCharacterIds,
              onCharactersChanged: (characterIds) {
                setState(() {
                  _selectedCharacterIds.clear();
                  _selectedCharacterIds.addAll(characterIds);
                  hasUnsavedChanges = true;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            SaveButton(
              onPressed: _saveNote,
              text: S.of(context).save,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedMetaCard() {
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
                    _titleController.text.isEmpty 
                        ? S.of(context).name 
                        : _titleController.text,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_tags.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      _tags.join(', '),
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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

  Widget _buildContentField() {
    if (_isPreviewMode) {
      return Container(
        margin: EdgeInsets.only(top: _isMetaCardExpanded ? 180 : 60),
        padding: const EdgeInsets.all(16),
        child: MarkdownBody(
          data: _contentController.text,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: _isMetaCardExpanded ? 180 : 60),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: _contentController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Start writing...',
          hintStyle: TextStyle(fontSize: 16),
          contentPadding: EdgeInsets.zero,
        ),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          height: 1.5,
        ),
        onChanged: (value) => _checkForChanges(),
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

class _CharacterSelectorSection extends StatefulWidget {
  final List<String> selectedCharacterIds;
  final ValueChanged<List<String>> onCharactersChanged;

  const _CharacterSelectorSection({
    required this.selectedCharacterIds,
    required this.onCharactersChanged,
  });

  @override
  State<_CharacterSelectorSection> createState() => _CharacterSelectorSectionState();
}

class _CharacterSelectorSectionState extends State<_CharacterSelectorSection> {
  final List<String> _localSelectedIds = [];

  @override
  void initState() {
    super.initState();
    _localSelectedIds.addAll(widget.selectedCharacterIds);
  }

  void _toggleCharacter(String characterId) {
    setState(() {
      if (_localSelectedIds.contains(characterId)) {
        _localSelectedIds.remove(characterId);
      } else {
        _localSelectedIds.add(characterId);
      }
    });
    widget.onCharactersChanged(_localSelectedIds);
  }

  void _removeCharacter(String characterId) {
    setState(() {
      _localSelectedIds.remove(characterId);
    });
    widget.onCharactersChanged(_localSelectedIds);
  }

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
            labelText: '${S.of(context).create} ${S.of(context).character.toLowerCase()}',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          dropdownColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          style: Theme.of(context).textTheme.bodyLarge,
          borderRadius: BorderRadius.circular(12),
          items: characters.map((character) {
            final characterKey = charactersBox.keyAt(characters.indexOf(character)).toString();
            final isSelected = _localSelectedIds.contains(characterKey);
            return DropdownMenuItem(
              value: characterKey,
              child: Row(
                children: [
                  if (isSelected)
                    Icon(Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20),
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
              _toggleCharacter(value);
            }
          },
        ),
        const SizedBox(height: 16),
        if (_localSelectedIds.isNotEmpty) 
          _buildSelectedCharactersChips(charactersBox),
      ],
    );
  }

  Widget _buildSelectedCharactersChips(Box<Character> charactersBox) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _localSelectedIds.map((characterId) {
        final character = charactersBox.get(characterId);
        return character != null
            ? InputChip(
                label: Text(character.name),
                onDeleted: () => _removeCharacter(characterId),
                deleteIcon: Icon(
                  Icons.close,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              )
            : const SizedBox();
      }).toList(),
    );
  }
}