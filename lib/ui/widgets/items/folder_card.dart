import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/ui/widgets/context_menu.dart';
import 'package:flutter/material.dart';

class FolderItem extends StatelessWidget {
  final Folder folder;
  final bool isSelected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool enableDrag;
  final List<Widget> children;

  const FolderItem({
    super.key,
    required this.folder,
    this.isSelected = false,
    required this.onEdit,
    required this.onDelete,
    this.enableDrag = false,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    final backgroundColor = folder.color.withOpacity(0.1);


    return Dismissible(
      key: Key(folder.id),
      direction: DismissDirection.horizontal,
      background: _buildSwipeBackground(
        context,
        alignment: Alignment.centerLeft,
        icon: Icons.edit_rounded,
        color: theme.colorScheme.tertiaryContainer,
        label: S.of(context).edit,
      ),
      secondaryBackground: _buildSwipeBackground(
        context,
        alignment: Alignment.centerRight,
        icon: Icons.delete_rounded,
        color: theme.colorScheme.errorContainer,
        label: S.of(context).delete,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit;
          return false;
        } else {
          return await _showDeleteConfirmation(context);
        }
      },
      onDismissed: (direction) async {
        onDelete;
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        elevation: 0,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
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
                        _getFolderIcon(folder.type),
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            folder.name,
                            style: theme.textTheme.bodyLarge,
                          ),
                          Text(
                            '${folder.contentIds.length} ${_getContentLabel(folder.contentIds.length, s)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert, 
                        color: theme.colorScheme.onSurfaceVariant),
                      onPressed: () => _showFolderContextMenu(context, folder, s),
                    ),
                  ],
                ),
                if (children.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...children,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(
    BuildContext context, {
    required Alignment alignment,
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: alignment == Alignment.centerLeft
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onTertiaryContainer),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  void _showFolderContextMenu(BuildContext context, Folder folder, S s) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28))
      ),
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

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).delete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(S.of(context).delete),
          ),
        ],
      ),
    ) ?? false;
  }

  String _getContentLabel(int count, S s) {
    if (count % 10 == 1 && count % 100 != 11) return s.items;
    if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return s.items;
    }
    return s.items;
  }

  IconData _getFolderIcon(FolderType type) {
    return Icons.folder_outlined;
  }
}