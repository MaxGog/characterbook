import 'package:characterbook/ui/widgets/items/race_card.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../models/race_model.dart';

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
  final VoidCallback? onCreateRace;

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
    this.onCreateRace,
  });

  @override
  Widget build(BuildContext context) {
    if (racesToShow.isEmpty) {
      return _buildEmptyState(context);
    }

    return Expanded(
        child: _buildRaceList(),
      );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_people,
            size: 48,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching && searchController.text.isNotEmpty
                ? S.of(context).empty_list
                : S.of(context).empty_list,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (onImportRace != null) _buildImportButton(context),
          if (onCreateRace != null) _buildCreateButton(context),
        ],
      ),
    );
  }

  Widget _buildImportButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        onPressed: onImportRace,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: Text(S.of(context).import_race),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ElevatedButton(
        onPressed: onCreateRace,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: Text(S.of(context).create),
      ),
    );
  }

  Widget _buildRaceList() {
    return ReorderableListView.builder(
      scrollController: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: racesToShow.length,
      itemBuilder: (context, index) {
        final race = racesToShow[index];
        return RaceCard(
          key: ValueKey(race.key),
          race: race,
          onTap: () => onRaceTap(race),
          onLongPress: () => onRaceLongPress(race),
        );
      },
      onReorder: onReorder,
    );
  }
}