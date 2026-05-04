import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/data/models/folder_model.dart';
import 'package:flutter/material.dart';

class EmptyFoldersState extends StatelessWidget {
  final FolderType folderType;
  final VoidCallback onCreate;

  const EmptyFoldersState({
    super.key,
    required this.folderType,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final s = S.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getFolderIcon(folderType),
            size: 48,
            color: colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          Text(
            s.none,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onCreate,
            child: Text(s.create),
          ),
        ],
      ),
    );
  }

  IconData _getFolderIcon(FolderType type) {
    return Icons.folder_outlined;
  }
}