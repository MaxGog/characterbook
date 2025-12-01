import 'package:characterbook/ui/widgets/desktop/app_title.dart';
import 'package:characterbook/ui/widgets/desktop/window_controls.dart';
import 'package:flutter/material.dart';

class DesktopTitleBar extends StatelessWidget {
  const DesktopTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 36,
      color: theme.colorScheme.surfaceContainerLowest,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const AppTitle(),
          const Positioned(
            left: 16,
            child: WindowControls(),
          ),
        ],
      ),
    );
  }
}
