import 'package:flutter/material.dart';
import 'package:characterbook/data/models/race_model.dart';
import 'package:characterbook/generated/l10n.dart';
import 'flip_keep_card_item.dart';

class RaceKeepCardItem extends StatelessWidget {
  final Race race;
  final int characterCount;
  final VoidCallback onTap;
  final VoidCallback onContextMenuTap;

  const RaceKeepCardItem({
    super.key,
    required this.race,
    required this.characterCount,
    required this.onTap,
    required this.onContextMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlipKeepCardItem(
      onTap: onTap,
      onContextMenuTap: onContextMenuTap,
      frontBuilder: (context, theme, colorScheme, flipValue, isFront) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48.0,
                    height: 48.0,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: race.logo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.memory(
                              race.logo!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.people_rounded,
                              size: 32.0,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                  ),
                  Text(
                    race.name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: colorScheme.primary.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 12.0,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          '$characterCount',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          S.of(context).characters.toLowerCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color:
                                colorScheme.onPrimaryContainer.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      backBuilder: (context, theme, colorScheme, flipValue, isFront) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16.0,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    S.of(context).description,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        race.description.isNotEmpty
                            ? race.description
                            : S.of(context).no_description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11.0,
                          color:
                              colorScheme.onSecondaryContainer.withOpacity(0.9),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      if (race.tags.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).tags,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 10.0,
                                color: colorScheme.onSecondaryContainer
                                    .withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 4.0,
                              children: race.tags
                                  .take(4)
                                  .map((tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 4.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.secondary
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          border: Border.all(
                                            color: colorScheme.secondary
                                                .withOpacity(0.3),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                            fontSize: 10.0,
                                            color: colorScheme
                                                .onSecondaryContainer,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.flip_rounded,
                  size: 14.0,
                  color: colorScheme.onSecondaryContainer.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
