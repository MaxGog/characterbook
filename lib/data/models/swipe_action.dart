import 'package:flutter/material.dart';
import 'package:characterbook/generated/l10n.dart';

enum SwipeAction {
  edit,
  delete,
  share,
  duplicate,
  settings,
}

extension SwipeActionExtension on SwipeAction {
  IconData get icon {
    switch (this) {
      case SwipeAction.edit:
        return Icons.edit_rounded;
      case SwipeAction.delete:
        return Icons.delete_rounded;
      case SwipeAction.share:
        return Icons.share_rounded;
      case SwipeAction.duplicate:
        return Icons.copy_all_rounded;
      case SwipeAction.settings:
        return Icons.settings_rounded;
    }
  }

  Color backgroundColor(ColorScheme colorScheme) {
    switch (this) {
      case SwipeAction.delete:
        return colorScheme.errorContainer;
      default:
        return colorScheme.tertiaryContainer;
    }
  }

  Color foregroundColor(ColorScheme colorScheme) {
    switch (this) {
      case SwipeAction.delete:
        return colorScheme.onErrorContainer;
      default:
        return colorScheme.onTertiaryContainer;
    }
  }

  String label(BuildContext context) {
    final s = S.of(context);
    switch (this) {
      case SwipeAction.edit:
        return s.edit;
      case SwipeAction.delete:
        return s.delete;
      case SwipeAction.share:
        return s.share;
      case SwipeAction.duplicate:
        return s.duplicate;
      case SwipeAction.settings:
        return s.settings;
    }
  }
}
