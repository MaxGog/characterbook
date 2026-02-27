import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/services/clipboard_service.dart';
import 'package:characterbook/services/folder_service.dart';
import 'package:characterbook/services/race_service.dart';
import 'package:characterbook/ui/pages/race_management_page.dart';
import 'package:characterbook/ui/widgets/common_modal.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class RaceModalCard extends StatefulWidget {
  final Race race;

  const RaceModalCard({super.key, required this.race});

  @override
  State<RaceModalCard> createState() => _RaceModalCardState();
}

class _RaceModalCardState extends State<RaceModalCard> {
  final Map<String, bool> _expandedSections = {
    'description': true,
    'biology': true,
    'backstory': true,
    'additionalImages': true,
  };

  late final RaceService _exportService;
  late final FolderService _folderService;
  Folder? _currentFolder;

  @override
  void initState() {
    super.initState();
    _exportService = RaceService.forExport(widget.race);
    _folderService = FolderService(Hive.box<Folder>('folders'));
    _loadFolder();
  }

  Future<void> _loadFolder() async {
    if (widget.race.folderId != null) {
      final folder = _folderService.getFolderById(widget.race.folderId!);
      if (mounted) setState(() => _currentFolder = folder);
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: S.of(context).race_delete_title,
      message: S.of(context).race_delete_confirm,
      confirmText: S.of(context).delete,
      isDestructive: true,
    );
    if (confirmed == true) await _deleteRace();
  }

  Future<void> _deleteRace() async {
    try {
      if (widget.race.key != null) {
        await Hive.box<Race>('races').delete(widget.race.key);
        if (mounted) {
          showSnackBar(context, S.of(context).race_deleted, isError: false);
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
      await ClipboardService.copyRaceToClipboard(
        context: context,
        name: widget.race.name,
        description: widget.race.description,
        biology: widget.race.biology,
        backstory: widget.race.backstory,
      );
      showSnackBar(context, S.of(context).copied_to_clipboard, isError: false);
    } catch (e) {
      showSnackBar(context, '${S.of(context).copy_error}: ${e.toString()}');
    }
  }

  Future<void> _navigateToEdit() async {
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RaceManagementPage(race: widget.race)),
    );
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

    final chips = <Widget>[
      _buildChip(
        icon: Icons.update_rounded,
        label: DateFormat('dd.MM.yyyy').format(widget.race.lastEdited),
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
      ...widget.race.tags.map((tag) => _buildChip(
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
          title: Text(s.share),
        ),
      ),
      PopupMenuItem(
        value: 'copy',
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading:
              Icon(Icons.copy_rounded, color: colorScheme.onSurfaceVariant),
          title: Text(s.copy),
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        value: 'delete',
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.delete_rounded, color: colorScheme.error),
          title:
              Text(s.delete, style: TextStyle(color: colorScheme.error)),
        ),
      ),
    ];

    return ModalScaffold(
      title: widget.race.name,
      menuItems: menuItems,
      onMenuItemSelected: (value) => switch (value) {
        'share' => showShareMenu(
            context: context,
            title: s.share,
            onJsonExport: _exportToJson,
            onPdfExport: _exportToPdf,
          ),
        'copy' => _copyToClipboard(),
        'delete' => _handleDelete(),
        _ => null,
      },
      onClose: () => Navigator.pop(context),
      onEdit: _navigateToEdit,
      heroSection: HeroSection(
        avatarBytes: widget.race.logo,
        name: widget.race.name,
        chips: chips,
        onAvatarTap: widget.race.logo != null
            ? () => showFullImage(context, widget.race.logo!, widget.race.name)
            : null,
        heroTag: 'race-logo-${widget.race.key}',
      ),
      contentSections: _buildContentSections(),
    );
  }

  Widget _buildContentSections() {
    final s = S.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.race.description.isNotEmpty)
          ExpandableSection(
            title: s.description,
            icon: Icons.description_rounded,
            isExpanded: _expandedSections['description']!,
            onToggle: (value) =>
                setState(() => _expandedSections['description'] = value),
            child: SelectableText(widget.race.description,
                style: theme.textTheme.bodyLarge),
          ),
        if (widget.race.biology.isNotEmpty)
          ExpandableSection(
            title: s.biology,
            icon: Icons.science_rounded,
            isExpanded: _expandedSections['biology']!,
            onToggle: (value) =>
                setState(() => _expandedSections['biology'] = value),
            child: SelectableText(widget.race.biology,
                style: theme.textTheme.bodyLarge),
          ),
        if (widget.race.backstory.isNotEmpty)
          ExpandableSection(
            title: s.backstory,
            icon: Icons.history_edu_rounded,
            isExpanded: _expandedSections['backstory']!,
            onToggle: (value) =>
                setState(() => _expandedSections['backstory'] = value),
            child: SelectableText(widget.race.backstory,
                style: theme.textTheme.bodyLarge),
          ),
        if (widget.race.additionalImages.isNotEmpty) ...[
          ExpandableSection(
            title: s.character_gallery,
            icon: Icons.photo_library_rounded,
            isExpanded: _expandedSections['additionalImages']!,
            onToggle: (value) =>
                setState(() => _expandedSections['additionalImages'] = value),
            child: GallerySection(
              images: widget.race.additionalImages,
              onImageTap: (bytes, title) =>
                  showFullImage(context, bytes, title),
            ),
          ),
        ],
      ],
    );
  }
}
