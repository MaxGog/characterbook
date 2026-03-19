import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/swipe_action.dart';
import 'package:characterbook/providers/swipe_action_settings_provider.dart';

class SwipeActionSettingsScreen extends StatelessWidget {
  const SwipeActionSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.swipeActions),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        children: [
          _buildDirectionSelector(
            context,
            title: s.leftSwipeAction,
            selectedAction:
                context.watch<SwipeActionSettingsProvider>().leftAction,
            onChanged: (action) => context
                .read<SwipeActionSettingsProvider>()
                .setLeftAction(action),
            icon: Icons.swipe_left_rounded,
          ),
          const SizedBox(height: 16),
          _buildDirectionSelector(
            context,
            title: s.rightSwipeAction,
            selectedAction:
                context.watch<SwipeActionSettingsProvider>().rightAction,
            onChanged: (action) => context
                .read<SwipeActionSettingsProvider>()
                .setRightAction(action),
            icon: Icons.swipe_right_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionSelector(
    BuildContext context, {
    required String title,
    required SwipeAction selectedAction,
    required ValueChanged<SwipeAction> onChanged,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<SwipeAction>(
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
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: Icon(Icons.arrow_drop_down_rounded,
                  color: colorScheme.onSurfaceVariant),
              borderRadius: BorderRadius.circular(12),
              dropdownColor: colorScheme.surfaceContainerHighest,
            ),
          ],
        ),
      ),
    );
  }
}
