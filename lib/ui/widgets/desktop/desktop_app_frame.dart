import 'package:characterbook/ui/widgets/desktop/desktop_title_bar.dart';
import 'package:flutter/material.dart';
import 'package:characterbook/ui/pages/app_navigation_bar.dart';

class DesktopAppFrame extends StatelessWidget {
  const DesktopAppFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: Column(
        children: [
          const DesktopTitleBar(),
          const Expanded(child: AppNavigationBar()),
        ],
      ),
    );
  }
}
