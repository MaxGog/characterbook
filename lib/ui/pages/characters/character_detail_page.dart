import 'dart:typed_data';
import 'package:characterbook/ui/widgets/avatar_widget.dart';
import 'package:characterbook/ui/widgets/build_section.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  @override
  void initState() {
    super.initState();
    _exportService = CharacterService.forExport(widget.character);
    _loadRelatedNotes();
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${note.updatedAt.day}.${note.updatedAt.month}.${note.updatedAt.year}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.content.length > 100 
                ? '${note.content.substring(0, 100)}...' 
                : note.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (note.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: note.tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: SelectableText(value)),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.character.name, style: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.share),
            onSelected: (value) => switch (value) {
              'file' => _exportToJson(),
              'pdf' => _exportToPdf(),
              _ => null,
            },
            tooltip: S.of(context).share_character,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'file', child: Text(S.of(context).file_character)),
              PopupMenuItem(value: 'pdf', child: Text(S.of(context).file_pdf)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyToClipboard,
            tooltip: S.of(context).copy_character,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CharacterEditPage(character: widget.character),
              ),
            ),
            tooltip: S.of(context).edit_character,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
            tooltip: S.of(context).delete_character,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${S.of(context).last_updated}: ${widget.character.lastEdited}',
                style: textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle(S.of(context).basic_info, 'basic', Icons.info),
            if (_expandedSections['basic']!) ...[
              Center(
                child: InkWell(
                  onTap: widget.character.imageBytes != null
                      ? () => _showFullImage(
                          widget.character.imageBytes!, 
                          S.of(context).character_avatar)
                      : null,
                  child: AvatarWidget.character(
                    imageBytes: widget.character.imageBytes,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoRow(S.of(context).name, widget.character.name, Icons.badge),
              _buildInfoRow(S.of(context).age, '${widget.character.age} ${S.of(context).years}', Icons.cake),
              _buildInfoRow(S.of(context).gender, _getLocalizedGender(widget.character.gender), Icons.transgender),
              if (widget.character.race != null)
                _buildInfoRow(S.of(context).race, widget.character.race!.name, Icons.people),
              const SizedBox(height: 16),
            ],

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
}