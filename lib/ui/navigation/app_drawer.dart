import 'package:characterbook/ui/navigation/menu_content.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  final VoidCallback? onHelpTap;
  final VoidCallback? onAboutTap;

  const AppDrawer({
    super.key,
    this.onSettingsTap,
    this.onHelpTap,
    this.onAboutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MenuContent(
        onSettingsTap: onSettingsTap,
        onHelpTap: onHelpTap,
        onAboutTap: onAboutTap,
      ),
    );
  }
}
