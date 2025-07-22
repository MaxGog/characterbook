import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/services/folder_service.dart';
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
    final folder = character.folderId != null 
        ? FolderService(Hive.box<Folder>('folders')).getFolderById(character.folderId!)
        : null;

    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      elevation: 0,
      color: isSelected
          ? theme.colorScheme.secondaryContainer
          : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.secondary
              : theme.colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: enableDrag ? null : onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AvatarWidget.character(imageBytes: character.imageBytes, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(character.name, style: theme.textTheme.bodyLarge),
                        Row(
                          children: [
                            // Возраст с иконкой
                            _buildInfoChip(
                              context,
                              icon: Icons.cake_rounded,
                              text: '${character.age} ${S.of(context).years}',
                              color: theme.colorScheme.tertiaryContainer,
                              iconColor: theme.colorScheme.onTertiaryContainer,
                            ),
                            const SizedBox(width: 8),
                            // Пол с иконкой
                            _buildInfoChip(
                              context,
                              icon: _getGenderIcon(character.gender),
                              text: _getLocalizedGender(context, character.gender),
                              color: _getGenderColor(context, character.gender),
                              iconColor: _getGenderIconColor(context, character.gender),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, 
                      color: theme.colorScheme.onSurfaceVariant),
                    onPressed: onMenuPressed,
                  ),
                ],
              ),
              if (folder != null || character.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (folder != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.folder, 
                                size: 16, 
                                color: theme.colorScheme.onPrimaryContainer),
                              const SizedBox(width: 4),
                              Text(
                                folder.name,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (folder != null && character.tags.isNotEmpty)
                        const SizedBox(width: 8),
                      ...character.tags.map((tag) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
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