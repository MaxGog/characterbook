import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/data/models/swipe_action.dart';
import 'package:characterbook/providers/swipe_action_settings_provider.dart';

class SwipeActionSettingsScreen extends StatelessWidget {
  const SwipeActionSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text(s.swipeActions),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    _SwipeDirectionCard(
                      title: s.leftSwipeAction,
                      selectedAction: context
                          .watch<SwipeActionSettingsProvider>()
                          .leftAction,
                      onChanged: (action) => context
                          .read<SwipeActionSettingsProvider>()
                          .setLeftAction(action),
                      icon: Icons.swipe_left_rounded,
                    ),
                    const SizedBox(height: 16),
                    _SwipeDirectionCard(
                      title: s.rightSwipeAction,
                      selectedAction: context
                          .watch<SwipeActionSettingsProvider>()
                          .rightAction,
                      onChanged: (action) => context
                          .read<SwipeActionSettingsProvider>()
                          .setRightAction(action),
                      icon: Icons.swipe_right_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeDirectionCard extends StatelessWidget {
  final String title;
  final SwipeAction selectedAction;
  final ValueChanged<SwipeAction> onChanged;
  final IconData icon;

  const _SwipeDirectionCard({
    required this.title,
    required this.selectedAction,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: DropdownButtonFormField<SwipeAction>(
                value: selectedAction,
                onChanged: (value) => onChanged(value!),
                items: SwipeAction.values.map((action) {
                  return DropdownMenuItem(
                    value: action,
                    child: Row(
                      children: [
                        Icon(action.icon,
                            size: 20, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 12),
                        Text(
                          action.label(context),
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                icon: Icon(Icons.arrow_drop_down_rounded,
                    color: colorScheme.onSurfaceVariant),
                borderRadius: BorderRadius.circular(12),
                dropdownColor: colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
