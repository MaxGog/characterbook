import 'dart:typed_data';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/services/character_service.dart';
import 'package:characterbook/services/clipboard_service.dart';
import 'package:characterbook/services/folder_service.dart';
import 'package:characterbook/ui/pages/character_management_page.dart';
import 'package:characterbook/ui/pages/note_management_page.dart';
import 'package:characterbook/ui/widgets/cards/note_card.dart';
import 'package:characterbook/ui/widgets/common_modal.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class CharacterModalCard extends StatefulWidget {
  final Character character;

  const CharacterModalCard({super.key, required this.character});

  @override
  State<CharacterModalCard> createState() => _CharacterModalCardState();
}

class _CharacterModalCardState extends State<CharacterModalCard> {
  final Map<String, bool> _expandedSections = {
    'gallery': true,
    'appearance': true,
    'personality': true,
    'biography': true,
    'abilities': true,
    'other': true,
    'customFields': true,
    'notes': true,
  };

  List<Note> _relatedNotes = [];
  late final CharacterService _exportService;
  late final FolderService _folderService;
  Folder? _currentFolder;

  static const String _genderMale = 'male';
  static const String _genderFemale = 'female';
  static const String _genderAnother = 'another';

  @override
  void initState() {
    super.initState();
    _exportService = CharacterService.forExport(widget.character);
    _folderService = FolderService(Hive.box<Folder>('folders'));
    _loadRelatedNotes();
    _loadFolder();
  }

  Future<void> _loadFolder() async {
    if (widget.character.folderId == null) return;
    final folder = _folderService.getFolderById(widget.character.folderId!);
    if (mounted) setState(() => _currentFolder = folder);
  }

  Future<void> _loadRelatedNotes() async {
    try {
      final notesBox = await Hive.openBox<Note>('notes');
      final notes = notesBox.values
          .where((note) =>
              note.characterIds.contains(widget.character.key.toString()))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      if (mounted) setState(() => _relatedNotes = notes);
    } catch (e) {
      debugPrint('${S.of(context).error_loading_notes}: $e');
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: S.of(context).character_delete_title,
      message: S.of(context).character_delete_confirm,
      confirmText: S.of(context).delete,
      isDestructive: true,
    );
    if (confirmed == true) await _deleteCharacter();
  }

  Future<void> _deleteCharacter() async {
    try {
      if (widget.character.key != null) {
        await Hive.box<Character>('characters').delete(widget.character.key);
        if (mounted) {
          showSnackBar(context, S.of(context).character_deleted,
              isError: false);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      showSnackBar(context, '${S.of(context).delete_error}: ${e.toString()}');
    }
  }

  Future<void> _exportToPdf() async {
    try {
      await _exportService.exportToPdf(context);
      showSnackBar(context, S.of(context).pdf_export_success, isError: false);
    } catch (e) {
      showSnackBar(context, '${S.of(context).export_error}: ${e.toString()}');
    }
  }

  Future<void> _exportToJson() async {
    try {
      await _exportService.exportToJson(context);
      showSnackBar(context, S.of(context).file_ready, isError: false);
    } catch (e) {
      showSnackBar(context, '${S.of(context).export_error}: ${e.toString()}');
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
            .map((f) => {'key': f.key, 'value': f.value})
            .toList(),
      );
      showSnackBar(context, S.of(context).copied_to_clipboard, isError: false);
    } catch (e) {
      showSnackBar(context, '${S.of(context).copy_error}: ${e.toString()}');
    }
  }

  Future<void> _duplicateCharacter() async {
    final s = S.of(context);
    try {
      final characterService = CharacterService.forDatabase();
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      await characterService.duplicateCharacter(widget.character);
      if (mounted) {
        Navigator.pop(context);
        showSnackBar(context, s.character_duplicated, isError: false);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      showSnackBar(context, '${s.duplicate_error}: ${e.toString()}');
    }
  }

  Future<void> _navigateToEdit() async {
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CharacterEditPage(character: widget.character)),
    );
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

  IconData _getGenderIcon(String gender) {
    return switch (gender) {
      _genderMale => Icons.male_rounded,
      _genderFemale => Icons.female_rounded,
      _ => Icons.transgender_rounded,
    };
  }

  Widget _buildChip(
      {required IconData icon, required String label, required Color color}) {
    return Chip(
      avatar: Icon(icon, size: 14),
      label: Text(label, style: Theme.of(context).textTheme.labelSmall),
      backgroundColor: color,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final List<Uint8List> allImages = [];
    if (widget.character.referenceImageBytes != null) {
      allImages.add(widget.character.referenceImageBytes!);
    }
    allImages.addAll(widget.character.additionalImages);

    final chips = <Widget>[
      if (widget.character.age > 0)
        _buildChip(
          icon: Icons.cake_rounded,
          label: '${widget.character.age} ${s.years}',
          color: colorScheme.tertiaryContainer,
        ),
      _buildChip(
        icon: _getGenderIcon(widget.character.gender),
        label: _getLocalizedGender(widget.character.gender),
        color: _getGenderColor(widget.character.gender),
      ),
      if (widget.character.race != null)
        _buildChip(
          icon: Icons.people_rounded,
          label: widget.character.race!.name,
          color: colorScheme.surfaceContainerHigh,
        ),
      _buildChip(
        icon: Icons.update_rounded,
        label: DateFormat('dd.MM.yyyy').format(widget.character.lastEdited),
        color: colorScheme.surfaceContainerHigh,
      ),
      if (_currentFolder != null)
        Chip(
          avatar: Icon(Icons.folder_rounded,
              size: 14, color: _currentFolder!.color),
          label: SelectableText(_currentFolder!.name,
              style: Theme.of(context).textTheme.labelSmall),
          backgroundColor: _currentFolder!.color.withOpacity(0.2),
          side: BorderSide(
              color: _currentFolder!.color.withOpacity(0.4), width: 1),
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ...widget.character.tags.map((tag) => _buildChip(
            icon: Icons.label_outline_rounded,
            label: tag,
            color: colorScheme.surfaceContainerHighest,
          )),
    ];

    final List<PopupMenuEntry<String>> menuItems = [
      PopupMenuItem(
        value: 'share',
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading:
              Icon(Icons.share_outlined, color: colorScheme.onSurfaceVariant),
          title: Text(s.share_character),
        ),
      ),
      PopupMenuItem(
        value: 'copy',
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading:
              Icon(Icons.copy_rounded, color: colorScheme.onSurfaceVariant),
          title: Text(s.copy_character),
        ),
      ),
      PopupMenuItem(
        value: 'duplicate',
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading:
              Icon(Icons.copy_all_rounded, color: colorScheme.onSurfaceVariant),
          title: Text(s.duplicate_character),
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        value: 'delete',
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.delete_rounded, color: colorScheme.error),
          title: Text(s.delete_character,
              style: TextStyle(color: colorScheme.error)),
        ),
      ),
    ];

    return ModalScaffold(
      title: widget.character.name,
      menuItems: menuItems,
      onMenuItemSelected: (value) => switch (value) {
        'share' => showShareMenu(
            context: context,
            title: s.share_character,
            onJsonExport: _exportToJson,
            onPdfExport: _exportToPdf,
          ),
        'duplicate' => _duplicateCharacter(),
        'copy' => _copyToClipboard(),
        'delete' => _handleDelete(),
        _ => null,
      },
      onClose: () => Navigator.pop(context),
      onEdit: _navigateToEdit,
      heroSection: HeroSection(
        avatarBytes: widget.character.imageBytes,
        name: widget.character.name,
        chips: chips,
        onAvatarTap: widget.character.imageBytes != null
            ? () => showFullImage(
                context, widget.character.imageBytes!, s.character_avatar)
            : null,
        heroTag: 'character-avatar-${widget.character.key}',
      ),
      contentSections: _buildContentSections(),
    );
  }

  Widget _buildContentSections() {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Uint8List> allImages = [];
    if (widget.character.referenceImageBytes != null) {
      allImages.add(widget.character.referenceImageBytes!);
    }
    allImages.addAll(widget.character.additionalImages);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (allImages.isNotEmpty) ...[
          ExpandableSection(
            title: s.character_gallery,
            icon: Icons.photo_library_rounded,
            isExpanded: _expandedSections['gallery']!,
            onToggle: (value) =>
                setState(() => _expandedSections['gallery'] = value),
            child: GallerySection(
              images: allImages,
              onImageTap: (bytes, title) =>
                  showFullImage(context, bytes, title),
              referenceImageLabel: widget.character.referenceImageBytes != null
                  ? s.reference_image
                  : null,
            ),
          ),
        ],
        if (widget.character.customFields.isNotEmpty) ...[
          ExpandableSection(
            title: s.custom_fields,
            icon: Icons.list_alt_rounded,
            isExpanded: _expandedSections['customFields']!,
            onToggle: (value) =>
                setState(() => _expandedSections['customFields'] = value),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.character.customFields
                  .map((field) => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(field.key,
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            SelectableText(field.value,
                                style: theme.textTheme.bodyLarge),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
        _buildExpandableTextSection('appearance', s.appearance,
            Icons.face_retouching_natural_rounded, widget.character.appearance),
        _buildExpandableTextSection('personality', s.personality,
            Icons.psychology_rounded, widget.character.personality),
        _buildExpandableTextSection('biography', s.biography,
            Icons.history_edu_rounded, widget.character.biography),
        _buildExpandableTextSection('abilities', s.abilities,
            Icons.auto_awesome_rounded, widget.character.abilities),
        _buildExpandableTextSection(
            'other', s.other, Icons.more_horiz_rounded, widget.character.other),
        if (_relatedNotes.isNotEmpty) ...[
          ExpandableSection(
            title: s.related_notes,
            icon: Icons.note_rounded,
            isExpanded: _expandedSections['notes']!,
            onToggle: (value) =>
                setState(() => _expandedSections['notes'] = value),
            child: Column(
              children: _relatedNotes
                  .map((note) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: NoteCard(
                          key: ValueKey(note.id),
                          note: note,
                          onTap: () => _openNoteForEditing(note),
                          onEdit: () => _openNoteForEditing(note),
                          onDelete: () => _deleteNote(note),
                          enableDrag: false,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExpandableTextSection(
      String key, String title, IconData icon, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    return ExpandableSection(
      title: title,
      icon: icon,
      isExpanded: _expandedSections[key]!,
      onToggle: (value) => setState(() => _expandedSections[key] = value),
      child:
          SelectableText(content, style: Theme.of(context).textTheme.bodyLarge),
    );
  }

  Future<void> _deleteNote(Note note) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: S.of(context).delete,
      message: S.of(context).delete,
      confirmText: S.of(context).delete,
      isDestructive: true,
    );
    if (confirmed == true) {
      try {
        await Hive.box<Note>('notes').delete(note.key);
        if (mounted) {
          showSnackBar(context, S.of(context).delete, isError: false);
          await _loadRelatedNotes();
        }
      } catch (e) {
        showSnackBar(context, '${S.of(context).delete_error}: ${e.toString()}');
      }
    }
  }

  Future<void> _openNoteForEditing(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditPage(note: note)),
    );
    if (result == true) await _loadRelatedNotes();
  }
}
