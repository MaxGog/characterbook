import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/repositories/folder_repository.dart';
import 'package:characterbook/repositories/race_repository.dart';
import 'package:characterbook/services/clipboard_service.dart';
import 'package:characterbook/services/race_service.dart';
import 'package:characterbook/ui/controllers/race_modal_card_controller.dart';
import 'package:characterbook/ui/pages/race_management_page.dart';
import 'package:characterbook/ui/widgets/common_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RaceModalController(
        race: widget.race,
        raceRepo: context.read<RaceRepository>(),
        folderRepo: context.read<FolderRepository>(),
        raceService: context.read<RaceService>(),
        clipboardService: context.read<ClipboardService>(),
      ),
      child: Consumer<RaceModalController>(
        builder: (context, controller, child) {
          final s = S.of(context);
          final colorScheme = Theme.of(context).colorScheme;

          final chips = _buildChips(context, controller);

          final List<PopupMenuEntry<String>> menuItems = [
            PopupMenuItem(
              value: 'share',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.share_outlined,
                    color: colorScheme.onSurfaceVariant),
                title: Text(s.share),
              ),
            ),
            PopupMenuItem(
              value: 'copy',
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.copy_rounded,
                    color: colorScheme.onSurfaceVariant),
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
            onMenuItemSelected: (value) =>
                _handleMenuItemSelected(context, controller, value),
            onClose: () => Navigator.pop(context),
            onEdit: () => _navigateToEdit(context),
            heroSection: HeroSection(
              avatarBytes: widget.race.logo,
              name: widget.race.name,
              chips: chips,
              onAvatarTap: widget.race.logo != null
                  ? () => showFullImage(
                      context, widget.race.logo!, widget.race.name)
                  : null,
              heroTag: 'race-logo-${widget.race.key}',
            ),
            contentSections: _buildContentSections(context),
          );
        },
      ),
    );
  }

  List<Widget> _buildChips(
      BuildContext context, RaceModalController controller) {
    final colorScheme = Theme.of(context).colorScheme;

    return [
      _buildChip(
        icon: Icons.update_rounded,
        label: DateFormat('dd.MM.yyyy').format(widget.race.lastEdited),
        color: colorScheme.surfaceContainerHigh,
      ),
      if (controller.currentFolder != null)
        Chip(
          avatar: Icon(Icons.folder_rounded,
              size: 14, color: controller.currentFolder!.color),
          label: SelectableText(controller.currentFolder!.name,
              style: Theme.of(context).textTheme.labelSmall),
          backgroundColor: controller.currentFolder!.color.withOpacity(0.2),
          side: BorderSide(
              color: controller.currentFolder!.color.withOpacity(0.4),
              width: 1),
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
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
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

  Future<void> _handleMenuItemSelected(BuildContext context,
      RaceModalController controller, String value) async {
    final s = S.of(context);
    switch (value) {
      case 'share':
        showShareMenu(
          context: context,
          title: s.share,
          onJsonExport: () => _handleExportJson(context, controller),
          onPdfExport: () => _handleExportPdf(context, controller),
        );
        break;
      case 'copy':
        await _handleCopy(context, controller);
        break;
      case 'delete':
        await _handleDelete(context, controller);
        break;
    }
  }

  Future<void> _handleExportPdf(
      BuildContext context, RaceModalController controller) async {
    try {
      await controller.exportToPdf(context);
      if (mounted) {
        showSnackBar(context, S.of(context).pdf_export_success, isError: false);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, '${S.of(context).export_error}: ${e.toString()}');
      }
    }
  }

  Future<void> _handleExportJson(
      BuildContext context, RaceModalController controller) async {
    try {
      await controller.exportToJson(context);
      if (mounted) {
        showSnackBar(context, S.of(context).file_ready, isError: false);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, '${S.of(context).export_error}: ${e.toString()}');
      }
    }
  }

  Future<void> _handleCopy(
      BuildContext context, RaceModalController controller) async {
    try {
      await controller.copyToClipboard(context);
      if (mounted) {
        showSnackBar(context, S.of(context).copied_to_clipboard,
            isError: false);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, '${S.of(context).copy_error}: ${e.toString()}');
      }
    }
  }

  Future<void> _handleDelete(
      BuildContext context, RaceModalController controller) async {
    final s = S.of(context);
    final confirmed = await showConfirmationDialog(
      context: context,
      title: s.race_delete_title,
      message: s.race_delete_confirm,
      confirmText: s.delete,
      isDestructive: true,
    );
    if (confirmed == true) {
      try {
        await controller.deleteRace();
        if (mounted) {
          showSnackBar(context, s.race_deleted, isError: false);
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          showSnackBar(context, '${s.delete_error}: ${e.toString()}');
        }
      }
    }
  }

  Future<void> _navigateToEdit(BuildContext context) async {
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RaceManagementPage(race: widget.race)),
    );
  }

  Widget _buildContentSections(BuildContext context) {
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
