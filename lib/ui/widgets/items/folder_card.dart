import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/ui/widgets/context_menu.dart';
import 'package:flutter/material.dart';

class FolderItem extends StatelessWidget {
  final Folder folder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final List<Widget> children;

  const FolderItem({
    super.key,
    required this.folder,
    required this.onEdit,
    required this.onDelete,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final s = S.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: folder.color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getFolderIcon(folder.type),
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          folder.name,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${folder.contentIds.length} ${_getContentLabel(folder.contentIds.length, s)}',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () => _showFolderContextMenu(context, folder, s),
        ),
        children: children,
      ),
    );
  }

  void _showFolderContextMenu(BuildContext context, Folder folder, S s) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
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