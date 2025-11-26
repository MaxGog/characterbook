import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/services/folder_service.dart';
import 'package:characterbook/ui/pages/character_management_page.dart';
import 'package:characterbook/ui/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onMenuPressed;
  final bool enableDrag;

  const CharacterCard({
    super.key,
    required this.character,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onMenuPressed,
    this.enableDrag = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    final folder = character.folderId != null
        ? FolderService(Hive.box<Folder>('folders'))
            .getFolderById(character.folderId!)
        : null;

    return Dismissible(
      key: Key(character.id),
      direction: DismissDirection.horizontal,
      background: _buildSwipeBackground(
        context,
        alignment: Alignment.centerLeft,
        icon: Icons.edit_rounded,
        color: colorScheme.tertiaryContainer,
        label: s.edit,
      ),
      secondaryBackground: _buildSwipeBackground(
        context,
        alignment: Alignment.centerRight,
        icon: Icons.delete_rounded,
        color: colorScheme.errorContainer,
        label: s.delete,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterEditPage(character: character),
            ),
          );
          return false;
        } else {
          return await _showDeleteConfirmation(context);
        }
      },
      onDismissed: (direction) async => {await Hive.box<Character>('characters').delete(character.key)},
      child: Card(
        key: key,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        elevation: isSelected ? 3.0 : 1.0,
        color: isSelected
            ? colorScheme.secondaryContainer
            : colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          onLongPress: enableDrag ? null : onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'avatar-${character.key ?? character.id}',
                      child: AvatarWidget.character(
                        imageBytes: character.imageBytes,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            character.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              Chip(
                                avatar: Icon(
                                  Icons.cake_rounded,
                                  size: 18,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                                label: Text('${character.age} ${s.years}'),
                                backgroundColor: colorScheme.secondaryContainer,
                              ),
                              Chip(
                                avatar: Icon(
                                  _getGenderIcon(character.gender),
                                  size: 18,
                                  color: _getGenderIconColor(
                                      context, character.gender),
                                ),
                                label: Text(_getLocalizedGender(
                                    context, character.gender)),
                                backgroundColor:
                                    _getGenderColor(context, character.gender),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert_rounded),
                      onPressed: onMenuPressed,
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                if (folder != null || character.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (folder != null)
                        Chip(
                          label: Text(folder.name),
                          avatar: Icon(
                            Icons.folder_rounded,
                            size: 18,
                            color: folder.color,
                          ),
                          backgroundColor: folder.color.withOpacity(0.1),
                        ),
                      ...character.tags.map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                          )),
                    ],
                  ),
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
        borderRadius: BorderRadius.circular(12),
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

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(S.of(context).delete),
            content: Text(S.of(context).delete),
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
        ) ??
        false;
  }

  String _getLocalizedGender(BuildContext context, String genderKey) {
    final s = S.of(context);
    return switch (genderKey) {
      'male' => s.male,
      'female' => s.female,
      'another' => s.another,
      _ => genderKey,
    };
  }

  IconData _getGenderIcon(String genderKey) {
    return switch (genderKey) {
      'male' => Icons.male_rounded,
      'female' => Icons.female_rounded,
      _ => Icons.transgender_rounded,
    };
  }

  Color _getGenderColor(BuildContext context, String genderKey) {
    final theme = Theme.of(context);
    return switch (genderKey) {
      'male' => theme.colorScheme.primaryContainer,
      'female' => theme.colorScheme.errorContainer,
      _ => theme.colorScheme.secondaryContainer,
    };
  }

  Color _getGenderIconColor(BuildContext context, String genderKey) {
    final theme = Theme.of(context);
    return switch (genderKey) {
      'male' => theme.colorScheme.onPrimaryContainer,
      'female' => theme.colorScheme.onErrorContainer,
      _ => theme.colorScheme.onSecondaryContainer,
    };
  }
}
