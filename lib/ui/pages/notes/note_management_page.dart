import 'package:characterbook/ui/handlers/unsaved_changes_handler.dart';
import 'package:characterbook/ui/widgets/appbar/common_edit_app_bar.dart';
import 'package:characterbook/ui/widgets/sections/tags_and_folder_section.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../generated/l10n.dart';
import '../../../models/character_model.dart';
import '../../../models/folder_model.dart';
import '../../../models/note_model.dart';
import '../../../services/clipboard_service.dart';
import '../../../services/folder_service.dart';
import '../../widgets/fields/custom_text_field.dart';
import '../../widgets/markdown_context_menu.dart';
import '../../widgets/save_button_widget.dart';
import '../../widgets/base_edit_page_scaffold.dart';

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

    return BaseEditPageScaffold(
      onWillPop: () => handleUnsavedChanges(context),
      appBar: CommonEditAppBar(
        title: title,
        onSave: _saveNote,
        saveTooltip: s.save,
        additionalActions: additionalActions,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const SizedBox(height: 24),
            CustomTextField(
              controller: _titleController,
              label: S.of(context).name,
              isRequired: true,
              onChanged: (value) => _checkForChanges(),
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
            _buildContentField(),
            const SizedBox(height: 24),
            SaveButton(
              onPressed: _saveNote,
              text: S.of(context).save,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentField() {
    if (_isPreviewMode) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: MarkdownBody(
          data: _contentController.text,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        ),
      );
    }

    return CustomTextField(
      controller: _contentController,
      label: S.of(context).description,
      maxLines: null,
      alignLabel: true,
      keyboardType: TextInputType.multiline,
      onChanged: (value) => _checkForChanges(),
      contextMenuBuilder: (context, editableTextState) {
        return MarkdownContextMenu(
          controller: _contentController,
          editableTextState: editableTextState,
        );
      },
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