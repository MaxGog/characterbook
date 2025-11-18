import 'package:flutter/material.dart';
import 'package:characterbook/models/characters/character_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/folder_model.dart';
import '../../../../generated/l10n.dart';

class SearchResultItem extends StatelessWidget {
  final dynamic item;
  final VoidCallback onTap;

  const SearchResultItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final s = S.of(context);

    final isCharacter = item is Character;
    final isRace = item is Race;
    final isNote = item is Note;
    final isFolder = item is Folder;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        color: colorScheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                _buildLeadingIcon(context),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCharacter
                            ? item.name
                            : isRace
                                ? item.name
                                : isNote
                                    ? item.title
                                    : isFolder
                                        ? item.name
                                        : item.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isCharacter
                            ? item.race?.name ?? s.no_race
                            : isRace
                                ? (item.description?.isNotEmpty ?? false)
                                    ? item.description!
                                    : s.no_description
                                : isNote
                                    ? (item.content.isNotEmpty)
                                        ? item.content
                                        : s.no_content
                                    : isFolder
                                        ? s.folder
                                        : s.fields_count(
                                            item.standardFields.length + item.customFields.length),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.outline,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (item is Character) {
      return item.imageBytes != null
          ? CircleAvatar(
              radius: 20,
              backgroundImage: MemoryImage(item.imageBytes!),
            )
          : CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.surfaceContainerHigh,
              child: Icon(
                Icons.person_outline,
                size: 20,
                color: colorScheme.primary,
              ),
            );
    } else if (item is Race) {
      return item.logo != null
          ? CircleAvatar(
              radius: 20,
              backgroundImage: MemoryImage(item.logo!),
            )
          : CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.surfaceContainerHigh,
              child: Icon(
                Icons.emoji_people_outlined,
                size: 20,
                color: colorScheme.primary,
              ),
            );
    } else if (item is Note) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: colorScheme.surfaceContainerHigh,
        child: Icon(
          Icons.note_outlined,
          size: 20,
          color: colorScheme.primary,
        ),
      );
    } else if (item is Folder) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: colorScheme.surfaceContainerHigh,
        child: Icon(
          Icons.folder_outlined,
          size: 20,
          color: colorScheme.primary,
        ),
      );
    } else {
      return CircleAvatar(
        radius: 20,
        backgroundColor: colorScheme.surfaceContainerHigh,
        child: Icon(
          Icons.library_books_outlined,
          size: 20,
          color: colorScheme.primary,
        ),
      );
    }
  }
}