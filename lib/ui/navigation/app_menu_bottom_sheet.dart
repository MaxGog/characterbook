import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/navigation/menu_content.dart';
import 'package:flutter/material.dart';

void showAppMenuBottomSheet(
  BuildContext context, {
  VoidCallback? onSettingsTap,
  VoidCallback? onHelpTap,
  VoidCallback? onAboutTap,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Material(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                    tooltip: S.of(context).close,
                  ),
                ],
              ),
            ),
            Expanded(
              child: MenuContent(
                onSettingsTap: onSettingsTap,
                onHelpTap: onHelpTap,
                onAboutTap: onAboutTap,
                scrollController: scrollController,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
