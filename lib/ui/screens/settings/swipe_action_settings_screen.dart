import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/swipe_action.dart';
import 'package:characterbook/providers/swipe_action_settings_provider.dart';

class SwipeActionSettingsScreen extends StatelessWidget {
  const SwipeActionSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.swipeActions),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ActionSelector(
            title: s.leftSwipeAction,
            selectedAction:
                context.watch<SwipeActionSettingsProvider>().leftAction,
            onChanged: (action) => context
                .read<SwipeActionSettingsProvider>()
                .setLeftAction(action),
          ),
          const SizedBox(height: 24),
          _ActionSelector(
            title: s.rightSwipeAction,
            selectedAction:
                context.watch<SwipeActionSettingsProvider>().rightAction,
            onChanged: (action) => context
                .read<SwipeActionSettingsProvider>()
                .setRightAction(action),
          ),
        ],
      ),
    );
  }
}

class _ActionSelector extends StatelessWidget {
  final String title;
  final SwipeAction selectedAction;
  final ValueChanged<SwipeAction> onChanged;

  const _ActionSelector({
    required this.title,
    required this.selectedAction,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<SwipeAction>(
          value: selectedAction,
          onChanged: (value) => onChanged(value!),
          items: SwipeAction.values.map((action) {
            return DropdownMenuItem(
              value: action,
              child: Row(
                children: [
                  Icon(action.icon, size: 20),
                  const SizedBox(width: 8),
                  Text(action.label(context)),
                ],
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          isExpanded: true,
        ),
      ],
    );
  }
}
