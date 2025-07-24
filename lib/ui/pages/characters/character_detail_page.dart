import 'dart:typed_data';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/services/folder_service.dart';
import 'package:characterbook/ui/pages/folders/folder_list_page.dart';
import 'package:characterbook/ui/pages/notes/note_management_page.dart';
import 'package:characterbook/ui/widgets/avatar_widget.dart';
import 'package:characterbook/ui/widgets/context_menu.dart';
import 'package:characterbook/ui/widgets/sections/build_section.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../../generated/l10n.dart';
import '../../../models/character_model.dart';
import '../../../models/note_model.dart';
import '../../../services/character_service.dart';
import '../../../services/clipboard_service.dart';
import 'character_management_page.dart';

class CharacterDetailPage extends StatefulWidget {
  final Character character;
  const CharacterDetailPage({super.key, required this.character});

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  final _expandedSections = <String, bool>{
    'basic': true, 'reference': true, 'appearance': true,
    'personality': true, 'biography': true, 'abilities': true,
    'other': true, 'customFields': true, 'additionalImages': true,
    'notes': true, 'race': true,
  };

  List<Note> _relatedNotes = [];
  late final CharacterService _exportService;

  static const _genderMale = 'male';
  static const _genderFemale = 'female';
  static const _genderAnother = 'another';

  late final FolderService _folderService;
  Folder? _currentFolder;

  @override
  void initState() {
    super.initState();
    _exportService = CharacterService.forExport(widget.character);
    _loadRelatedNotes();
    _folderService = FolderService(Hive.box<Folder>('folders'));
    _loadRelatedNotes();
    _loadFolder();
  }

  Future<void> _loadFolder() async {
    if (widget.character.folderId != null) {
      final folder = _folderService.getFolderById(widget.character.folderId!);
      setState(() {
        _currentFolder = folder;
      });
    }
  }

  String _getLocalizedGender(String gender) {
    final s = S.of(context);
    return switch (gender) {
      _genderMale => s.male,
      _genderFemale => s.female,
      _genderAnother => s.another,
      _ => gender,
    };
  }

  Color _getGenderColor(String gender) {
    final theme = Theme.of(context);
    return switch (gender) {
      _genderMale => theme.colorScheme.primaryContainer,
      _genderFemale => theme.colorScheme.tertiaryContainer,
      _genderAnother => theme.colorScheme.secondaryContainer,
      _ => theme.colorScheme.surfaceContainerHighest,
    };
  }

  Future<void> _loadRelatedNotes() async {
    if (!mounted) return;

    try {
      final notesBox = await Hive.openBox<Note>('notes');
      final notes = notesBox.values
          .where((note) => note.characterIds.contains(widget.character.key.toString()))
          .toList();
      
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      if (mounted) {
        setState(() => _relatedNotes = notes);
      }
    } catch (e) {
      debugPrint('${S.of(context).error_loading_notes}: $e');
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await _showConfirmationDialog(
      title: S.of(context).character_delete_title,
      message: S.of(context).character_delete_confirm,
      confirmText: S.of(context).delete,
      isDestructive: true,
    );

    if (confirmed == true) await _deleteCharacter();
  }

  Future<bool?> _showConfirmationDialog({
    required String title,
    required String message,
    required String confirmText,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmText,
              style: TextStyle(color: isDestructive ? Colors.red : null),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCharacter() async {
    try {
      if (widget.character.key != null) {
        final box = Hive.box<Character>('characters');
        await box.delete(widget.character.key);

        if (mounted) {
          _showSnackBar(S.of(context).character_deleted, isError: false);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      _showSnackBar('${S.of(context).delete_error}: ${e.toString()}');
    }
  }

  Future<void> _exportToPdf() async {
    try {
      await _exportService.exportToPdf(context);
      _showSnackBar(S.of(context).pdf_export_success, isError: false);
    } catch (e) {
      _showSnackBar('${S.of(context).export_error}: ${e.toString()}');
    }
  }

  Future<void> _exportToJson() async {
    try {
      await _exportService.exportToJson(context);
      _showSnackBar(S.of(context).file_ready, isError: false);
    } catch (e) {
      _showSnackBar('${S.of(context).export_error}: ${e.toString()}');
    }
  }

  Future<void> _copyToClipboard() async {
    try {
      await ClipboardService.copyCharacterToClipboard(
        context: context,
        name: widget.character.name,
        age: widget.character.age,
        gender: widget.character.gender,
        raceName: widget.character.race?.name,
        biography: widget.character.biography,
        appearance: widget.character.appearance,
        personality: widget.character.personality,
        abilities: widget.character.abilities,
        other: widget.character.other,
        customFields: widget.character.customFields
            .map((field) => {'key': field.key, 'value': field.value})
            .toList(),
      );
      _showSnackBar(S.of(context).copied_to_clipboard, isError: false);
    } catch (e) {
      _showSnackBar('${S.of(context).copy_error}: ${e.toString()}');
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError 
          ? Theme.of(context).colorScheme.errorContainer 
          : null,
      ),
    );
  }

  void _showFullImage(Uint8List imageBytes, String title) => showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            backgroundColor: Colors.black,
            title: Text(title),
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          InteractiveViewer(
            panEnabled: true,
            minScale: 0.1,
            maxScale: 4.0,
            child: Image.memory(imageBytes),
          ),
        ],
      ),
    ),
  );

  Widget _buildSectionTitle(String title, String sectionKey, IconData icon) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => setState(() => _expandedSections[sectionKey] = !_expandedSections[sectionKey]!),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(
              _expandedSections[sectionKey]! ? Icons.expand_less : Icons.expand_more,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    final theme = Theme.of(context);
    final characterBox = Hive.box<Character>('characters');
    final characters = note.characterIds
        .map((id) => characterBox.get(id))
        .whereType<Character>()
        .toList();
    final folder = note.folderId != null 
        ? _folderService.getFolderById(note.folderId!)
        : null;

    void showNoteContextMenu() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ContextMenu.note(
          note: note,
          onEdit: () => _openNoteForEditing(note),
          onDelete: () => _deleteNote(note),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openNoteForEditing(note),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, 
                        color: theme.colorScheme.onSurfaceVariant),
                    onPressed: showNoteContextMenu,
                  ),
                ],
              ),
              if (folder != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.folder, 
                        size: 16, 
                        color: theme.colorScheme.onPrimaryContainer),
                      const SizedBox(width: 4),
                      Text(
                        folder.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                note.content,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (characters.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: characters.map((character) => Chip(
                    label: Text(character.name),
                    labelStyle: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    visualDensity: VisualDensity.compact,
                  )).toList(),
                ),
              ],
              if (note.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: note.tags.map((tag) => Chip(
                    label: Text(tag),
                    labelStyle: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    visualDensity: VisualDensity.compact,
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteNote(Note note) async {
    final confirmed = await _showConfirmationDialog(
      title: S.of(context).delete,
      message: S.of(context).delete,
      confirmText: S.of(context).delete,
      isDestructive: true,
    );

    if (confirmed == true) {
      try {
        final box = Hive.box<Note>('notes');
        await box.delete(note.key);
        if (mounted) {
          _showSnackBar(S.of(context).delete, isError: false);
          await _loadRelatedNotes();
        }
      } catch (e) {
        _showSnackBar('${S.of(context).delete_error}: ${e.toString()}');
      }
    }
  }

  Future<void> _openNoteForEditing(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditPage(note: note),
      ),
    );
    
    if (result == true) {
      await _loadRelatedNotes();
    }
  }


  Widget _buildInfoRow(String label, String value, IconData icon, {Color? valueColor}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              value,
              style: valueColor != null 
                ? TextStyle(color: valueColor) 
                : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceImage() {
    final theme = Theme.of(context);
    return InkWell(
      onTap: widget.character.referenceImageBytes != null
          ? () => _showFullImage(
              widget.character.referenceImageBytes!, 
              S.of(context).character_reference)
          : null,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          image: widget.character.referenceImageBytes != null
              ? DecorationImage(
                  image: MemoryImage(widget.character.referenceImageBytes!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: widget.character.referenceImageBytes == null
            ? Icon(Icons.people, size: 40, color: theme.colorScheme.onSurfaceVariant)
            : null,
      ),
    );
  }

  Widget _buildGallery() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: widget.character.additionalImages.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () => _showFullImage(
          widget.character.additionalImages[index],
          '${S.of(context).character_gallery} ${index + 1}',
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            widget.character.additionalImages[index],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomFields() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.character.customFields.map((field) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field.key, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              SelectableText(field.value),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildSection(String title, String key, String content, IconData icon) {
    return BuildSection(
      title: title,
      content: content,
      icon: icon,
      isExpanded: _expandedSections[key]!,
      onToggleExpand: () => setState(() => _expandedSections[key] = !_expandedSections[key]!),
    );
  }

  Widget _buildBasicInfoSection() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 40,
              width: 2,
              color: theme.colorScheme.outline,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surfaceContainer,
              ),
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: widget.character.imageBytes != null
                    ? () => _showFullImage(
                        widget.character.imageBytes!, 
                        S.of(context).character_avatar)
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: AvatarWidget.character(
                    imageBytes: widget.character.imageBytes,
                    size: 80,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            border: Border.all(
              color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildInfoRow(S.of(context).name, widget.character.name, Icons.badge),
              Divider(height: 20, color: theme.colorScheme.outline),
              _buildInfoRow(S.of(context).age, '${widget.character.age} ${S.of(context).years}', Icons.cake),
              Divider(height: 20, color: theme.colorScheme.outline),
              _buildInfoRow(
                S.of(context).gender, 
                _getLocalizedGender(widget.character.gender), 
                Icons.transgender,
                valueColor: _getGenderColor(widget.character.gender),
              ),
              if (widget.character.race != null) ...[
                Divider(height: 20, color: theme.colorScheme.outline),
                _buildInfoRow(S.of(context).race, widget.character.race!.name, Icons.people),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _showShareMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.topRight(Offset.zero)),
        button.localToGlobal(button.size.bottomRight(Offset.zero)),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'file',
          child: ListTile(
            leading: Icon(Icons.insert_drive_file, color: Theme.of(context).colorScheme.onSurfaceVariant),
            title: Text(S.of(context).file_character),
          ),
        ),
        PopupMenuItem<String>(
          value: 'pdf',
          child: ListTile(
            leading: Icon(Icons.picture_as_pdf, color: Theme.of(context).colorScheme.onSurfaceVariant),
            title: Text(S.of(context).file_pdf),
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'file': _exportToJson(); break;
          case 'pdf': _exportToPdf(); break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.character.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => _showShareMenu(context),
            tooltip: S.of(context).share_character,
          ),

          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurface),
            position: PopupMenuPosition.under,
            surfaceTintColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            onSelected: (value) => switch (value) {
              'copy' => _copyToClipboard(),
              'edit' => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterEditPage(character: widget.character),
                ),
              ),
              'delete' => _handleDelete(),
              _ => null,
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'copy',
                child: ListTile(
                  leading: Icon(Icons.copy, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  title: Text(S.of(context).copy_character),
                ),
              ),
              PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  title: Text(S.of(context).edit_character),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                  title: Text(
                    S.of(context).delete_character,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.update,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${S.of(context).last_updated}: ${_formatLastEdited(widget.character.lastEdited)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )
                ),
              ],
            ),

           if (_currentFolder != null || widget.character.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (_currentFolder != null)
                    InputChip(
                      avatar: Icon(Icons.folder, size: 18, 
                          color: theme.colorScheme.onSecondaryContainer),
                      label: Text(_currentFolder!.name),
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoldersScreen(
                              folderType: FolderType.character,
                            ),
                          ),
                        );
                      },
                    ),
                  ...widget.character.tags.map((tag) => InputChip(
                    label: Text(tag),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    onPressed: () {},
                  )),
                ],
              ),
            const SizedBox(height: 16),
            _buildBasicInfoSection(),
            const SizedBox(height: 16),

            _buildSectionTitle(S.of(context).character_reference, 'reference', Icons.image_search),
            if (_expandedSections['reference']!) ...[
              Center(child: _buildReferenceImage()),
              const SizedBox(height: 16),
            ],
            if (widget.character.appearance.isNotEmpty) _buildSection(S.of(context).appearance, 'appearance', widget.character.appearance, Icons.face_retouching_natural),
            if (widget.character.personality.isNotEmpty) _buildSection(S.of(context).personality, 'personality', widget.character.personality, Icons.psychology),
            if (widget.character.biography.isNotEmpty) _buildSection(S.of(context).biography, 'biography', widget.character.biography, Icons.history_edu),
            if (widget.character.abilities.isNotEmpty) _buildSection(S.of(context).abilities, 'abilities', widget.character.abilities, Icons.auto_awesome),
            if (widget.character.other.isNotEmpty) _buildSection(S.of(context).other, 'other', widget.character.other, Icons.more_horiz),

            if (widget.character.additionalImages.isNotEmpty) ...[
              _buildSectionTitle(S.of(context).character_gallery, 'additionalImages', Icons.photo_library),
              if (_expandedSections['additionalImages']!) ...[
                _buildGallery(),
                const SizedBox(height: 16),
              ],
            ],

            if (widget.character.customFields.isNotEmpty) ...[
              _buildSectionTitle(S.of(context).custom_fields, 'customFields', Icons.list_alt),
              if (_expandedSections['customFields']!) ...[
                _buildCustomFields(),
                const SizedBox(height: 16),
              ],
            ],

            if (_relatedNotes.isNotEmpty) ...[
              _buildSectionTitle(S.of(context).related_notes, 'notes', Icons.note),
              if (_expandedSections['notes']!) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _relatedNotes.length,
                  itemBuilder: (context, index) => _buildNoteCard(_relatedNotes[index]),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  String _formatLastEdited(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}