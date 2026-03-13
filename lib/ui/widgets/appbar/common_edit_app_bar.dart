import 'package:characterbook/ui/widgets/appbar/common_app_bar.dart';
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
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return CommonAppBar.edit(
      context: context,
      title: title,
      additionalActions: additionalActions,
      onSave: onSave,
      saveTooltip: saveTooltip,
      centerTitle: true,
      showBackButton: true,
    );
  }
}
