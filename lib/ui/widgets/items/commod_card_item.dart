import 'package:flutter/material.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/swipe_action.dart';
import 'package:characterbook/providers/swipe_action_settings_provider.dart';
import 'package:provider/provider.dart';

class CommonCardItem extends StatelessWidget {
  final String id;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final VoidCallback? onDuplicate;
  final VoidCallback? onSettings;
  final String? deleteConfirmationMessage;
  final EdgeInsetsGeometry margin;
  final double? elevation;
  final Color? selectedColor;
  final Color? defaultColor;
  final ShapeBorder? shape;
  final Widget child;

  const CommonCardItem({
    super.key,
    required this.id,
    required this.isSelected,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDelete,
    this.onShare,
    this.onDuplicate,
    this.onSettings,
    this.deleteConfirmationMessage,
    this.margin = const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
    this.elevation,
    this.selectedColor,
    this.defaultColor,
    this.shape,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final swipeSettings = context.watch<SwipeActionSettingsProvider>();

    final Map<SwipeAction, VoidCallback> availableActions = {};
    if (onEdit != null) availableActions[SwipeAction.edit] = onEdit!;
    if (onDelete != null) availableActions[SwipeAction.delete] = onDelete!;
    if (onShare != null) availableActions[SwipeAction.share] = onShare!;
    if (onDuplicate != null) {
      availableActions[SwipeAction.duplicate] = onDuplicate!;
    }
    if (onSettings != null) {
      availableActions[SwipeAction.settings] = onSettings!;
    }

    final leftAction = swipeSettings.leftAction;
    final rightAction = swipeSettings.rightAction;

    final hasLeft = availableActions.containsKey(leftAction);
    final hasRight = availableActions.containsKey(rightAction);
    final canDismiss = hasLeft || hasRight;

    DismissDirection dismissDirection = DismissDirection.none;
    if (hasLeft && hasRight) {
      dismissDirection = DismissDirection.horizontal;
    } else if (hasLeft) {
      dismissDirection = DismissDirection.startToEnd;
    } else if (hasRight) {
      dismissDirection = DismissDirection.endToStart;
    }

    Widget card = Card(
      margin: margin,
      elevation: elevation ?? (isSelected ? 2.0 : 1.0),
      color: _resolveBackgroundColor(colorScheme),
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected
                ? BorderSide(color: colorScheme.primary, width: 2)
                : BorderSide.none,
          ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress,
        child: child,
      ),
    );

    if (canDismiss) {
      Widget leftBackground = hasLeft
          ? _buildSwipeBackground(
              context,
              action: leftAction,
              alignment: Alignment.centerLeft,
            )
          : const SizedBox.shrink();

      Widget rightBackground = hasRight
          ? _buildSwipeBackground(
              context,
              action: rightAction,
              alignment: Alignment.centerRight,
            )
          : const SizedBox.shrink();

      card = Dismissible(
        key: Key('common_card_$id'),
        direction: dismissDirection,
        background: leftBackground,
        secondaryBackground: rightBackground,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd && hasLeft) {
            availableActions[leftAction]!();
            return false;
          } else if (direction == DismissDirection.endToStart && hasRight) {
            if (rightAction == SwipeAction.delete && onDelete != null) {
              final confirm = await _showDeleteConfirmation(context);
              if (confirm) onDelete!();
              return false;
            } else {
              availableActions[rightAction]!();
              return false;
            }
          }
          return false;
        },
        child: card,
      );
    }

    return card;
  }

  Color _resolveBackgroundColor(ColorScheme colorScheme) {
    if (isSelected) {
      return selectedColor ?? colorScheme.secondaryContainer;
    }
    return defaultColor ?? colorScheme.surfaceContainerHigh;
  }

  Widget _buildSwipeBackground(
    BuildContext context, {
    required SwipeAction action,
    required Alignment alignment,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: action.backgroundColor(colorScheme),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: alignment == Alignment.centerLeft
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Icon(action.icon,
              size: 20, color: action.foregroundColor(colorScheme)),
          const SizedBox(width: 8),
          Text(
            action.label(context),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: action.foregroundColor(colorScheme),
                ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    final s = S.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(s.delete),
            content: Text(deleteConfirmationMessage ?? s.deleteConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(s.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: Text(s.delete),
              ),
            ],
          ),
        ) ??
        false;
  }
}
