import 'package:flutter/material.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/generated/l10n.dart';
import 'flip_keep_card.dart';

class CharacterKeepCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;
  final VoidCallback onContextMenuTap;
  final String formattedDate;

  const CharacterKeepCard({
    super.key,
    required this.character,
    required this.onTap,
    required this.onContextMenuTap,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return FlipKeepCard(
      onTap: onTap,
      onContextMenuTap: onContextMenuTap,
      frontBuilder: (context, theme, colorScheme, flipValue, isFront) {
        final hasImage = character.imageBytes != null;
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.memory(
                    character.imageBytes!,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  color: colorScheme.primaryContainer,
                ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      character.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6.0),
                    Container(
                      constraints:
                          const BoxConstraints(maxWidth: double.infinity),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (character.race != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people_rounded,
                                  size: 12.0,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                const SizedBox(width: 4.0),
                                Flexible(
                                  child: Text(
                                    character.race!.name,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          if (character.age > 0)
                            Padding(
                              padding: EdgeInsets.only(
                                top: character.race != null ? 4.0 : 0.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.cake_rounded,
                                    size: 12.0,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Flexible(
                                    child: Text(
                                      '${character.age}',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      formattedDate,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      backBuilder: (context, theme, colorScheme, flipValue, isFront) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  ClipRect(
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 16.0,
                                color: colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                S.of(context).information,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          if (character.tags.isNotEmpty) ...[
                            Text(
                              S.of(context).tags,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer
                                    .withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 4.0,
                              children: character.tags
                                  .take(3)
                                  .map((tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                          vertical: 3.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          border: Border.all(
                                            color: colorScheme.primary
                                                .withOpacity(0.3),
                                            width: 1.0,
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                            fontSize: 10.0,
                                            color:
                                                colorScheme.onPrimaryContainer,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 12.0),
                          ],
                          Text(
                            S.of(context).last_updated,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10.0,
                              color: colorScheme.onPrimaryContainer
                                  .withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            formattedDate,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11.0,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          if (character.race != null) ...[
                            Text(
                              S.of(context).race,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 10.0,
                                color: colorScheme.onPrimaryContainer
                                    .withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              character.race!.name,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11.0,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 30,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              colorScheme.primaryContainer,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: Icon(
                        Icons.flip_rounded,
                        size: 14.0,
                        color: colorScheme.onPrimaryContainer.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
