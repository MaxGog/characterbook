import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/navigation/app_menu_bottom_sheet.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final VoidCallback? onBack;
  final bool showBackButton;
  final Color? backgroundColor;
  final double toolbarHeight;
  final bool isSearching;
  final TextEditingController? searchController;
  final VoidCallback? onSearchToggle;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFoldersPressed;
  final VoidCallback? onTemplatesPressed;
  final VoidCallback? onViewModePressed;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onHelpPressed;
  final VoidCallback? onAboutPressed;
  final BorderRadiusGeometry? bottomBorderRadius;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.onBack,
    this.showBackButton = true,
    this.backgroundColor,
    this.toolbarHeight = 64,
    this.isSearching = false,
    this.searchController,
    this.onSearchToggle,
    this.searchHint,
    this.onSearchChanged,
    this.onFoldersPressed,
    this.onTemplatesPressed,
    this.onViewModePressed,
    this.onSettingsPressed,
    this.onHelpPressed,
    this.onAboutPressed,
    this.bottomBorderRadius,
  });

  factory CommonAppBar.main({
    Key? key,
    required BuildContext context,
    required String title,
    required bool isSearching,
    required VoidCallback onSearchToggle,
    TextEditingController? searchController,
    String? searchHint,
    ValueChanged<String>? onSearchChanged,
    List<Widget>? additionalActions,
    bool showAppIcon = true,
    VoidCallback? onFoldersPressed,
    VoidCallback? onTemplatesPressed,
    VoidCallback? onViewModePressed,
    VoidCallback? onSettingsPressed,
    VoidCallback? onHelpPressed,
    VoidCallback? onAboutPressed,
  }) {
    final actions = _buildMainActions(
      context: context,
      isSearching: isSearching,
      onSearchToggle: onSearchToggle,
      additionalActions: additionalActions,
      onFoldersPressed: onFoldersPressed,
      onTemplatesPressed: onTemplatesPressed,
      onViewModePressed: onViewModePressed,
      onSettingsPressed: onSettingsPressed,
      onHelpPressed: onHelpPressed,
      onAboutPressed: onAboutPressed,
    );

    return CommonAppBar(
      key: key,
      title: title,
      centerTitle: true,
      showBackButton: false,
      toolbarHeight: 64,
      isSearching: isSearching,
      searchController: searchController,
      onSearchToggle: onSearchToggle,
      searchHint: searchHint,
      onSearchChanged: onSearchChanged,
      onFoldersPressed: onFoldersPressed,
      onTemplatesPressed: onTemplatesPressed,
      onViewModePressed: onViewModePressed,
      onSettingsPressed: onSettingsPressed,
      onHelpPressed: onHelpPressed,
      onAboutPressed: onAboutPressed,
      actions: actions,
      bottomBorderRadius: BorderRadius.zero,
    );
  }

  factory CommonAppBar.edit({
    Key? key,
    required BuildContext context,
    required String title,
    List<Widget>? additionalActions,
    VoidCallback? onSave,
    String saveTooltip = 'Save',
    bool centerTitle = true,
    VoidCallback? onBack,
    bool showBackButton = true,
  }) {
    final actions = <Widget>[
      if (additionalActions != null) ...additionalActions,
      Padding(
        padding: const EdgeInsets.only(right: 8),
        child: IconButton(
          onPressed: onSave,
          icon: const Icon(Icons.save_rounded),
          tooltip: saveTooltip,
        ),
      ),
    ];

    return CommonAppBar(
      key: key,
      title: title,
      centerTitle: centerTitle,
      showBackButton: showBackButton,
      onBack: onBack,
      toolbarHeight: 64,
      actions: actions,
      bottomBorderRadius: BorderRadius.zero,
    );
  }

  factory CommonAppBar.standard({
    Key? key,
    required BuildContext context,
    required String title,
    List<Widget>? actions,
    bool centerTitle = true,
    VoidCallback? onBack,
    bool showBackButton = true,
  }) {
    return CommonAppBar(
      key: key,
      title: title,
      centerTitle: centerTitle,
      showBackButton: showBackButton,
      onBack: onBack,
      toolbarHeight: 64,
      actions: actions,
      bottomBorderRadius: BorderRadius.zero,
    );
  }

  static List<Widget> _buildMainActions({
    required BuildContext context,
    required bool isSearching,
    required VoidCallback onSearchToggle,
    List<Widget>? additionalActions,
    VoidCallback? onFoldersPressed,
    VoidCallback? onTemplatesPressed,
    VoidCallback? onViewModePressed,
    required VoidCallback? onSettingsPressed,
    VoidCallback? onHelpPressed,
    VoidCallback? onAboutPressed,
  }) {
    if (isSearching) {
      return [];
    }

    final actions = <Widget>[
      IconButton(
        onPressed: onSearchToggle,
        icon: const Icon(Icons.search_rounded),
        tooltip: S.of(context).search,
      ),
      IconButton(
        onPressed: () => showAppMenuBottomSheet(
          context,
          onSettingsTap: onSettingsPressed,
          onHelpTap: onHelpPressed,
          onAboutTap: onAboutPressed,
        ),
        icon: const Icon(Icons.account_circle_rounded),
        iconSize: 32,
        tooltip: S.of(context).more_options,
      ),
    ];

    if (additionalActions != null) {
      actions.addAll(additionalActions);
    }

    return actions;
  }

  Widget _buildSearchField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: searchHint ?? s.search_hint,
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          textAlignVertical: TextAlignVertical.center,
          autofocus: true,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final s = S.of(context);

    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.1, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: isSearching
            ? _buildSearchField(context)
            : Text(
                title,
                key: const ValueKey('title'),
                style: centerTitle
                    ? textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w500)
                    : textTheme.headlineMedium,
              ),
      ),
      centerTitle: centerTitle,
      toolbarHeight: toolbarHeight,
      titleSpacing: isSearching ? 0 : 24,
      elevation: 0,
      scrolledUnderElevation: 3,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      leading: isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                onSearchToggle?.call();
              },
              tooltip: s.close,
            )
          : null,
      actions: actions,
      shape: ContinuousRectangleBorder(
        borderRadius: bottomBorderRadius ?? BorderRadius.zero,
      ),
    );
  }
}
