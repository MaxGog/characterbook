import 'dart:typed_data';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/services/clipboard_service.dart';
import 'package:characterbook/services/folder_service.dart';
import 'package:characterbook/services/race_service.dart';
import 'package:characterbook/ui/pages/race_management_page.dart';
import 'package:characterbook/ui/widgets/avatar_widget.dart';
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
  final _expandedSections = <String, bool>{
    'logo': true, 'description': true, 'biology': true,
    'backstory': true, 'additionalImages': true,
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
      setState(() {
        _currentFolder = folder;
      });
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await _showConfirmationDialog(
      title: S.of(context).race_delete_title,
      message: S.of(context).race_delete_confirm,
      confirmText: S.of(context).delete,
      isDestructive: true,
    );

    if (confirmed == true) await _deleteRace();
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

  Future<void> _deleteRace() async {
    try {
      if (widget.race.key != null) {
        final box = Hive.box<Race>('races');
        await box.delete(widget.race.key);

        if (mounted) {
          _showSnackBar(S.of(context).race_deleted, isError: false);
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
      await ClipboardService.copyRaceToClipboard(
        context: context,
        name: widget.race.name,
        description: widget.race.description,
        biology: widget.race.biology,
        backstory: widget.race.backstory,
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

  Future<void> _navigateToEdit() async {
    Navigator.pop(context);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RaceManagementPage(race: widget.race),
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
                S.of(context).file_race,
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
                tooltip: S.of(context).edit_race,
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
                              widget.race.name,
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
                                    colorScheme.surfaceContainerLowest.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            IconButton.filledTonal(
                              onPressed: _showShareMenu,
                              icon: const Icon(Icons.share_outlined),
                              tooltip: S.of(context).share,
                              style: IconButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert_rounded, color: colorScheme.onSurface),
                              position: PopupMenuPosition.under,
                              surfaceTintColor: colorScheme.surfaceContainerHighest,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'copy',
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(Icons.copy_rounded, color: colorScheme.onSurfaceVariant),
                                    title: Text(S.of(context).copy),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'edit',
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(Icons.edit_rounded, color: colorScheme.onSurfaceVariant),
                                    title: Text(S.of(context).edit_race),
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(Icons.delete_rounded, color: colorScheme.error),
                                    title: Text(
                                      S.of(context).delete_character,
                                      style: TextStyle(color: colorScheme.error),
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
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                onTap: widget.race.logo != null
                    ? () => _showFullImage(widget.race.logo!, widget.race.name)
                    : null,
                borderRadius: BorderRadius.circular(60),
                child: Hero(
                  tag: 'race-logo-${widget.race.key}',
                  child: AvatarWidget.race(
                    imageBytes: widget.race.logo,
                    size: 120,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SelectableText(
            widget.race.name,
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
              _buildExpressiveChip(
                icon: Icons.update_rounded,
                label: DateFormat('dd.MM.yyyy').format(widget.race.lastEdited),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ...widget.race.tags.map((tag) => _buildExpressiveChip(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.race.description.isNotEmpty)
          _buildExpressiveContentSection(
            title: s.description,
            content: widget.race.description,
            icon: Icons.description_rounded,
            isExpanded: _expandedSections['description']!,
            onToggle: () => setState(() => _expandedSections['description'] = !_expandedSections['description']!),
          ),

        if (widget.race.biology.isNotEmpty)
          _buildExpressiveContentSection(
            title: s.biology,
            content: widget.race.biology,
            icon: Icons.science_rounded,
            isExpanded: _expandedSections['biology']!,
            onToggle: () => setState(() => _expandedSections['biology'] = !_expandedSections['biology']!),
          ),
        
        if (widget.race.backstory.isNotEmpty)
          _buildExpressiveContentSection(
            title: s.backstory,
            content: widget.race.backstory,
            icon: Icons.history_edu_rounded,
            isExpanded: _expandedSections['backstory']!,
            onToggle: () => setState(() => _expandedSections['backstory'] = !_expandedSections['backstory']!),
          ),

        if (widget.race.additionalImages.isNotEmpty) ...[
          _buildExpressiveSectionHeader(
            title: s.character_gallery,
            icon: Icons.photo_library_rounded,
            isExpanded: _expandedSections['additionalImages']!,
            onTap: () => setState(() => _expandedSections['additionalImages'] = !_expandedSections['additionalImages']!),
          ),
          if (_expandedSections['additionalImages']!) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.race.additionalImages.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _showFullImage(
                      widget.race.additionalImages[index],
                      '${s.character_gallery} ${index + 1}',
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(
                        widget.race.additionalImages[index],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
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
              isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
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
          crossFadeState: isExpanded 
              ? CrossFadeState.showSecond 
              : CrossFadeState.showFirst,
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
}

