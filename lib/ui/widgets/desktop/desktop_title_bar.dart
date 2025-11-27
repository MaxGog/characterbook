import 'package:flutter/material.dart';
import 'app_title.dart';
import 'window_controls.dart';

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
