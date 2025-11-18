import 'package:flutter/material.dart';

class CommonEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? additionalActions;
  final VoidCallback? onSave;
  final String saveTooltip;

  const CommonEditAppBar({
    super.key,
    required this.title,
    this.additionalActions,
    this.onSave,
    this.saveTooltip = 'Save',
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final actions = <Widget>[
      if (additionalActions != null) ...additionalActions!,
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: IconButton.filledTonal(
          onPressed: onSave,
          icon: const Icon(Icons.save_rounded),
          tooltip: saveTooltip,
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
        ),
      ),
    ];

    return AppBar(
      title: Text(
        title,
        style: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          height: 1.2,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: true,
      titleSpacing: 24,
      toolbarHeight: 80,
      scrolledUnderElevation: 3,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      backgroundColor: colorScheme.surfaceContainerLowest,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      actions: actions,
    );
  }
}