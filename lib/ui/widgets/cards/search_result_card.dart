import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/folder_model.dart';

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
    final s = S.of(context);

    final isCharacter = item is Character;
    final isRace = item is Race;
    final isNote = item is Note;
    final isFolder = item is Folder;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Card(
        elevation: 1,
        color: colorScheme.surfaceContainerHigh,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                _buildLeadingIcon(context),
                const SizedBox(width: 16),
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
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isCharacter
                            ? item.race?.name ?? s.no_race
                            : isRace
                                ? (item.description.isNotEmpty)
                                    ? item.description
                                    : s.no_description
                                : isNote
                                    ? (item.content.isNotEmpty)
                                        ? item.content
                                        : s.no_content
                                    : isFolder
                                        ? s.folder
                                        : s.fields_count(
                                            item.standardFields.length + item.customFields.length),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
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
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.person_rounded,
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
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.emoji_people_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
            );
    } else if (item is Note) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.note_rounded,
          size: 20,
          color: colorScheme.primary,
        ),
      );
    } else if (item is Folder) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.folder_rounded,
          size: 20,
          color: colorScheme.primary,
        ),
      );
    } else {
      return CircleAvatar(
        radius: 20,
        backgroundColor: colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.library_books_rounded,
          size: 20,
          color: colorScheme.primary,
        ),
      );
    }
  }
}