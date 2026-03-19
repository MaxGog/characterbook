import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/ui/widgets/tools_context_menu.dart';
import 'package:flutter/material.dart';

import 'commod_card_item.dart';

class FolderItem extends StatelessWidget {
  final Folder folder;
  final bool isSelected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool enableDrag;
  final List<Widget> children;
  final VoidCallback? onSettings;

  const FolderItem({
    super.key,
    required this.folder,
    this.isSelected = false,
    required this.onEdit,
    required this.onDelete,
    this.enableDrag = false,
    required this.children,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return CommonCardItem(
      id: folder.id,
      isSelected: isSelected,
      onEdit: onEdit,
      onDelete: onDelete,
      deleteConfirmationMessage: s.delete,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: folder.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.folder_rounded,
                    color: colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        folder.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${folder.contentIds.length} ${_getContentLabel(folder.contentIds.length, s)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert,
                      color: colorScheme.onSurfaceVariant),
                  onPressed: () => _showFolderContextMenu(context),
                ),
              ],
            ),
            if (children.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...children,
            ],
          ],
        ),
      ),
    );
  }


  void _showFolderContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu(
        item: folder,
        onEdit: onEdit,
        onDelete: onDelete,
        showExportPdf: false,
        showCopy: false,
        showShare: false,
      ),
    );
  }

  String _getContentLabel(int count, S s) {
    if (count == 1) return s.items;
    return s.items;
  }
}
