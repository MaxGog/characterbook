import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/ui/screens/race_management_screen.dart';
import 'package:characterbook/ui/widgets/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'commod_card_item.dart';

class RaceCardItem extends StatelessWidget {
  final Race race;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool enableDrag;
  final VoidCallback? onShare;
  final VoidCallback? onDuplicate;
  final VoidCallback? onSettings;

  const RaceCardItem({
    super.key,
    required this.race,
    this.isSelected = false,
    required this.onTap,
    required this.onLongPress,
    this.enableDrag = false,
    this.onShare,
    this.onDuplicate,
    this.onSettings
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return CommonCardItem(
      id: race.id,
      isSelected: isSelected,
      onTap: onTap,
      onLongPress: enableDrag ? null : onLongPress,
      onEdit: () async {
        await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => RaceManagementScreen(race: race),
          ),
        );
      },
      onDelete: () async {
        await Hive.box<Race>('races').delete(race.key);
      },
      deleteConfirmationMessage: s.race_delete_confirm,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarWidget.race(
                  imageBytes: race.logo,
                  size: 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        race.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (race.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          race.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
