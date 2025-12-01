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
import 'package:characterbook/ui/widgets/avatar_widget.dart';
import 'package:characterbook/ui/widgets/cards/note_card.dart';
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
  final _expandedSections = <String, bool>{
    'basic': true,
    'gallery': true,
    'appearance': true,
    'personality': true,
    'biography': true,
    'abilities': true,
    'other': true,
    'customFields': true,
    'notes': true,
    'race': true,
  };

  List<Note> _relatedNotes = [];
  late final CharacterService _exportService;
  late final FolderService _folderService;
  Folder? _currentFolder;

  static const _genderMale = 'male';
  static const _genderFemale = 'female';
  static const _genderAnother = 'another';

  @override
  void initState() {
    super.initState();
    _exportService = CharacterService.forExport(widget.character);
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
          .where((note) =>
              note.characterIds.contains(widget.character.key.toString()))
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
    final colorScheme = Theme.of(context).colorScheme;
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
              style: TextStyle(color: isDestructive ? colorScheme.error : null),
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
        backgroundColor:
            isError ? Theme.of(context).colorScheme.errorContainer : null,
      ),
    );
  }

  Future<void> _navigateToEdit() async {
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterEditPage(character: widget.character),
      ),
    );
  }

  void _showFullImage(Uint8List imageBytes, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close_rounded, color: colorScheme.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              title,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.1,
              maxScale: 4.0,
              child: Image.memory(imageBytes),
            ),
          ),
        ),
        fullscreenDialog: true,
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

  void _showShareMenu() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                S.of(context).share_character,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.insert_drive_file_rounded,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                S.of(context).file_character,
                style: textTheme.bodyLarge,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              onTap: () {
                Navigator.pop(context);
                _exportToJson();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                color: colorScheme.outlineVariant,
              ),
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                S.of(context).file_pdf,
                style: textTheme.bodyLarge,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
              onTap: () {
                Navigator.pop(context);
                _exportToPdf();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  side: BorderSide(color: colorScheme.outline),
                ),
                child: Text(S.of(context).cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: FloatingActionButton(
                onPressed: _navigateToEdit,
                tooltip: S.of(context).edit_character,
                child: const Icon(Icons.edit_rounded),
              ),
            ),
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 120,
                          collapsedHeight: 80,
                          pinned: true,
                          floating: false,
                          snap: false,
                          surfaceTintColor: Colors.transparent,
                          shadowColor: colorScheme.shadow,
                          backgroundColor: colorScheme.surfaceContainerLowest,
                          shape: const ContinuousRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                          ),
                          leading: IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                            tooltip: S.of(context).close,
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            titlePadding: const EdgeInsets.only(bottom: 16),
                            title: Text(
                              widget.character.name,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                letterSpacing: -0.5,
                              ),
                            ),
                            background: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    colorScheme.surfaceContainerLowest,
                                    colorScheme.surfaceContainerLowest
                                        .withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            IconButton.filledTonal(
                              onPressed: _showShareMenu,
                              icon: const Icon(Icons.share_outlined),
                              tooltip: S.of(context).share_character,
                              style: IconButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert_rounded,
                                  color: colorScheme.onSurface),
                              position: PopupMenuPosition.under,
                              surfaceTintColor:
                                  colorScheme.surfaceContainerHighest,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'copy',
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(Icons.copy_rounded,
                                        color: colorScheme.onSurfaceVariant),
                                    title: Text(S.of(context).copy_character),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(Icons.edit_rounded,
                                        color: colorScheme.onSurfaceVariant),
                                    title: Text(S.of(context).edit_character),
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(Icons.delete_rounded,
                                        color: colorScheme.error),
                                    title: Text(
                                      S.of(context).delete_character,
                                      style:
                                          TextStyle(color: colorScheme.error),
                                    ),
                                  ),
                                ),
                              ],
                              onSelected: (value) => switch (value) {
                                'copy' => _copyToClipboard(),
                                'edit' => _navigateToEdit(),
                                'delete' => _handleDelete(),
                                _ => null,
                              },
                            ),
                          ],
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              _buildHeroSection(context),
                              const SizedBox(height: 24),
                              _buildContentSections(context),
                              const SizedBox(height: 32),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline,
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: widget.character.imageBytes != null
                    ? () => _showFullImage(widget.character.imageBytes!,
                        S.of(context).character_avatar)
                    : null,
                borderRadius: BorderRadius.circular(60),
                child: Hero(
                  tag: 'character-avatar-${widget.character.key}',
                  child: AvatarWidget.character(
                    imageBytes: widget.character.imageBytes,
                    size: 120,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SelectableText(
            widget.character.name,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              if (widget.character.age > 0)
                _buildExpressiveChip(
                  icon: Icons.cake_rounded,
                  label: '${widget.character.age} ${S.of(context).years}',
                  color: colorScheme.tertiaryContainer,
                ),
              _buildExpressiveChip(
                icon: _getGenderIcon(widget.character.gender),
                label: _getLocalizedGender(widget.character.gender),
                color: _getGenderColor(widget.character.gender),
              ),
              if (widget.character.race != null)
                _buildExpressiveChip(
                  icon: Icons.people_rounded,
                  label: widget.character.race!.name,
                  color: colorScheme.surfaceContainerHigh,
                ),
              _buildExpressiveChip(
                icon: Icons.update_rounded,
                label: DateFormat('dd.MM.yyyy')
                    .format(widget.character.lastEdited),
                color: colorScheme.surfaceContainerHigh,
              ),
              if (_currentFolder != null)
                Chip(
                  avatar: Icon(
                    Icons.folder_rounded,
                    size: 18,
                    color: _currentFolder!.color,
                  ),
                  label: SelectableText(_currentFolder!.name),
                  backgroundColor: _currentFolder!.color.withOpacity(0.2),
                  side: BorderSide(
                    color: _currentFolder!.color.withOpacity(0.4),
                    width: 1,
                  ),
                  visualDensity: VisualDensity.compact,
                  labelStyle: textTheme.labelLarge?.copyWith(
                    color: _currentFolder!.color,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ...widget.character.tags.map((tag) => _buildExpressiveChip(
                    icon: Icons.label_outline_rounded,
                    label: tag,
                    color: colorScheme.surfaceContainerHighest,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpressiveChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: color,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      labelStyle: theme.textTheme.labelLarge,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildContentSections(BuildContext context) {
    final s = S.of(context);

    final List<Uint8List> allImages = [];

    if (widget.character.referenceImageBytes != null) {
      allImages.add(widget.character.referenceImageBytes!);
    }

    allImages.addAll(widget.character.additionalImages);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (allImages.isNotEmpty) ...[
          _buildExpressiveSectionHeader(
            title: s.character_gallery,
            icon: Icons.photo_library_rounded,
            isExpanded: _expandedSections['gallery']!,
            onTap: () => setState(() =>
                _expandedSections['gallery'] = !_expandedSections['gallery']!),
          ),
          if (_expandedSections['gallery']!) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: allImages.length,
                itemBuilder: (context, index) {
                  String imageTitle;
                  if (widget.character.referenceImageBytes != null &&
                      index == 0) {
                    imageTitle = s.character_reference;
                  } else {
                    imageTitle =
                        '${s.character_gallery} ${allImages.length > 1 ? index + 1 : ''}';
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _showFullImage(
                        allImages[index],
                        imageTitle.trim(),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Image.memory(
                              allImages[index],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            if (widget.character.referenceImageBytes != null &&
                                index == 0)
                              Positioned(
                                bottom: 4,
                                left: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    s.reference_image,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],

        if (widget.character.customFields.isNotEmpty) ...[
          _buildExpressiveSectionHeader(
            title: s.custom_fields,
            icon: Icons.list_alt_rounded,
            isExpanded: _expandedSections['customFields']!,
            onTap: () => setState(() => _expandedSections['customFields'] =
                !_expandedSections['customFields']!),
          ),
          if (_expandedSections['customFields']!) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: widget.character.customFields
                  .map((field) => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              field.key,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            SelectableText(
                              field.value,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],
        ],

        if (widget.character.appearance.isNotEmpty)
          _buildExpressiveContentSection(
            title: s.appearance,
            content: widget.character.appearance,
            icon: Icons.face_retouching_natural_rounded,
            isExpanded: _expandedSections['appearance']!,
            onToggle: () => setState(() => _expandedSections['appearance'] =
                !_expandedSections['appearance']!),
          ),

        if (widget.character.personality.isNotEmpty)
          _buildExpressiveContentSection(
            title: s.personality,
            content: widget.character.personality,
            icon: Icons.psychology_rounded,
            isExpanded: _expandedSections['personality']!,
            onToggle: () => setState(() => _expandedSections['personality'] =
                !_expandedSections['personality']!),
          ),

        if (widget.character.biography.isNotEmpty)
          _buildExpressiveContentSection(
            title: s.biography,
            content: widget.character.biography,
            icon: Icons.history_edu_rounded,
            isExpanded: _expandedSections['biography']!,
            onToggle: () => setState(() => _expandedSections['biography'] =
                !_expandedSections['biography']!),
          ),

        if (widget.character.abilities.isNotEmpty)
          _buildExpressiveContentSection(
            title: s.abilities,
            content: widget.character.abilities,
            icon: Icons.auto_awesome_rounded,
            isExpanded: _expandedSections['abilities']!,
            onToggle: () => setState(() => _expandedSections['abilities'] =
                !_expandedSections['abilities']!),
          ),

        if (widget.character.other.isNotEmpty)
          _buildExpressiveContentSection(
            title: s.other,
            content: widget.character.other,
            icon: Icons.more_horiz_rounded,
            isExpanded: _expandedSections['other']!,
            onToggle: () => setState(() =>
                _expandedSections['other'] = !_expandedSections['other']!),
          ),

        if (_relatedNotes.isNotEmpty) ...[
          _buildExpressiveSectionHeader(
            title: s.related_notes,
            icon: Icons.note_rounded,
            isExpanded: _expandedSections['notes']!,
            onTap: () => setState(() =>
                _expandedSections['notes'] = !_expandedSections['notes']!),
          ),
          if (_expandedSections['notes']!) ...[
            const SizedBox(height: 12),
            ..._relatedNotes.map((note) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildExpressiveNoteCard(note),
                )),
          ],
        ],
      ],
    );
  }

  Widget _buildExpressiveSectionHeader({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              isExpanded
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded,
              color: colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Icon(icon, color: colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            SelectableText(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpressiveContentSection({
    required String title,
    required String content,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExpressiveSectionHeader(
          title: title,
          icon: icon,
          isExpanded: isExpanded,
          onTap: onToggle,
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                    child: SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: -1.0,
                      child: child,
                    ),
                  ),
                  child: SelectableText(
                    key: ValueKey(content.hashCode),
                    content,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpressiveNoteCard(Note note) {
    return NoteCard(
      key: ValueKey(note.id),
      note: note,
      onTap: () => _openNoteForEditing(note),
      onEdit: () => _openNoteForEditing(note),
      onDelete: () => _deleteNote(note),
      enableDrag: false,
    );
  }

  IconData _getGenderIcon(String genderKey) {
    return switch (genderKey) {
      'male' => Icons.male_rounded,
      'female' => Icons.female_rounded,
      _ => Icons.transgender_rounded,
    };
  }
}
