import 'package:characterbook/ui/widgets/appbar/common_app_bar.dart';
import 'package:flutter/material.dart';

class CommonMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isSearching;
  final TextEditingController? searchController;
  final VoidCallback onSearchToggle;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final List<Widget>? additionalActions;
  final VoidCallback? onFoldersPressed;
  final VoidCallback? onTemplatesPressed;
  final VoidCallback? onViewModePressed;
  final VoidCallback? onSettingsPressed;
  final bool showViewModeToggle;
  final bool showTemplatesToggle;
  final bool showFoldersToggle;

  const CommonMainAppBar({
    super.key,
    required this.title,
    required this.isSearching,
    this.searchController,
    required this.onSearchToggle,
    this.searchHint,
    this.onSearchChanged,
    this.additionalActions,
    this.onFoldersPressed,
    this.onTemplatesPressed,
    this.onViewModePressed,
    this.onSettingsPressed,
    this.showViewModeToggle = true,
    this.showTemplatesToggle = true,
    this.showFoldersToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    return CommonAppBar.main(
      context: context,
      title: title,
      isSearching: isSearching,
      onSearchToggle: onSearchToggle,
      searchController: searchController,
      searchHint: searchHint,
      onSearchChanged: onSearchChanged,
      additionalActions: additionalActions,
      onFoldersPressed: onFoldersPressed,
      onTemplatesPressed: onTemplatesPressed,
      onViewModePressed: onViewModePressed,
      onSettingsPressed: onSettingsPressed,
      showViewModeToggle: showViewModeToggle,
      showTemplatesToggle: showTemplatesToggle,
      showFoldersToggle: showFoldersToggle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
