import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/services/folder_service.dart';
import 'package:flutter/material.dart';

class FolderSelectorWidget extends StatelessWidget {
  final Folder? selectedFolder;
  final ValueChanged<Folder?> onFolderSelected;
  final FolderService folderService;
  final FolderType folderType;

  const FolderSelectorWidget({
    super.key,
    required this.selectedFolder,
    required this.onFolderSelected,
    required this.folderService,
    required this.folderType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _selectFolder(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: S.of(context).folder,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerLow,
        ),
        child: Row(
          children: [
            Icon(
              Icons.folder_outlined,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                selectedFolder?.name ?? S.of(context).no_folder_selected,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            if (selectedFolder != null)
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                style: IconButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => onFolderSelected(null),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFolder(BuildContext context) async {
    final theme = Theme.of(context);
    final folders = folderService.getFoldersByType(folderType);

    final selected = await showModalBottomSheet<Folder>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _FolderSelectorDialog(
        folders: folders,
        selectedFolder: selectedFolder,
        noFolderText: S.of(context).no_folder_selected,
      ),
    );

    if (selected != null || selectedFolder != null) {
      onFolderSelected(selected);
    }
  }
}

class _FolderSelectorDialog extends StatelessWidget {
  final List<Folder> folders;
  final Folder? selectedFolder;
  final String noFolderText;

  const _FolderSelectorDialog({
    required this.folders,
    required this.selectedFolder,
    required this.noFolderText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    S.of(context).folder,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: folders.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      leading: Icon(
                        Icons.folder_off,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      title: Text(noFolderText, style: textTheme.bodyLarge),
                      onTap: () => Navigator.pop(context, null),
                    );
                  }

                  final folder = folders[index - 1];
                  return ListTile(
                    leading: Icon(
                      Icons.folder,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(folder.name, style: textTheme.bodyLarge),
                    trailing: selectedFolder?.id == folder.id
                        ? Icon(Icons.check, color: theme.colorScheme.primary)
                        : null,
                    onTap: () => Navigator.pop(context, folder),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
