import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../models/race_model.dart';
import 'items/race_card.dart';

class RaceListView extends StatelessWidget {
  final List<Race> allRaces;
  final List<Race> racesToShow;
  final List<String> tags;
  final TextEditingController searchController;
  final bool isSearching;
  final String? selectedTag;
  final ScrollController? scrollController;
  final Function(int, int) onReorder;
  final Function(Race) onRaceTap;
  final Function(Race) onRaceLongPress;
  final VoidCallback? onImportRace;

  const RaceListView({
    super.key,
    this.scrollController,
    required this.allRaces,
    required this.racesToShow,
    required this.tags,
    required this.searchController,
    required this.isSearching,
    required this.selectedTag,
    required this.onReorder,
    required this.onRaceTap,
    required this.onRaceLongPress,
    this.onImportRace,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (racesToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_people, size: 48, color: theme.colorScheme.onSurface),
            const SizedBox(height: 16),
            Text(
              isSearching && searchController.text.isNotEmpty
                  ? S.of(context).empty_list
                  : S.of(context).empty_list,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
            ),
            if (onImportRace != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onImportRace,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: Text(S.of(context).import_race),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      children: [
        if (tags.isNotEmpty)
          SizedBox(
            height: 56,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (context, index) {
                final tag = tags[index];
                return FilterChip(
                  label: Text(tag),
                  selected: selectedTag == tag,
                  onSelected: (selected) {
                    // TODO: Сделать теги для рас
                  },
                  shape: StadiumBorder(side: BorderSide(color: theme.colorScheme.outline)),
                  showCheckmark: false,
                  side: BorderSide.none,
                  selectedColor: theme.colorScheme.secondaryContainer,
                  labelStyle: theme.textTheme.labelLarge?.copyWith(
                    color: selectedTag == tag
                        ? theme.colorScheme.onSecondaryContainer
                        : theme.colorScheme.onSurface,
                  ),
                );
              },
            ),
          ),
        Expanded(
          child: ReorderableListView.builder(
            scrollController: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: racesToShow.length,
            itemBuilder: (context, index) => RaceCard(
              key: ValueKey(racesToShow[index].key),
              race: racesToShow[index],
              onTap: () => onRaceTap(racesToShow[index]),
              onLongPress: () => onRaceLongPress(racesToShow[index]),
            ),
            onReorder: onReorder,
          ),
        ),
      ],
    );
  }
}