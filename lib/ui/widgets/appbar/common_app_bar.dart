import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/screens/settings/settings_screen.dart';
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
  final bool showViewModeToggle;
  final bool showTemplatesToggle;
  final bool showFoldersToggle;
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
    this.showViewModeToggle = false,
    this.showTemplatesToggle = false,
    this.showFoldersToggle = false,
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
    VoidCallback? onFoldersPressed,
    VoidCallback? onTemplatesPressed,
    VoidCallback? onViewModePressed,
    VoidCallback? onSettingsPressed,
    bool showViewModeToggle = true,
    bool showTemplatesToggle = true,
    bool showFoldersToggle = true,
  }) {
    final actions = _buildMainActions(
      context: context,
      isSearching: isSearching,
      onSearchToggle: onSearchToggle,
      additionalActions: additionalActions,
      onFoldersPressed: onFoldersPressed,
      onTemplatesPressed: onTemplatesPressed,
      onViewModePressed: onViewModePressed,
      onSettingsPressed: onSettingsPressed ??
          () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
      showViewModeToggle: showViewModeToggle,
      showTemplatesToggle: showTemplatesToggle,
      showFoldersToggle: showFoldersToggle,
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
      showViewModeToggle: showViewModeToggle,
      showTemplatesToggle: showTemplatesToggle,
      showFoldersToggle: showFoldersToggle,
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
    required VoidCallback onSettingsPressed,
    required bool showViewModeToggle,
    required bool showTemplatesToggle,
    required bool showFoldersToggle,
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
      _buildMoreMenu(
        context: context,
        onFoldersPressed: onFoldersPressed,
        onTemplatesPressed: onTemplatesPressed,
        onViewModePressed: onViewModePressed,
        onSettingsPressed: onSettingsPressed,
        showFoldersToggle: showFoldersToggle,
        showTemplatesToggle: showTemplatesToggle,
        showViewModeToggle: showViewModeToggle,
      ),
    ];

    if (additionalActions != null) {
      actions.addAll(additionalActions);
    }

    return actions;
  }

  static Widget _buildMoreMenu({
    required BuildContext context,
    required VoidCallback? onFoldersPressed,
    required VoidCallback? onTemplatesPressed,
    required VoidCallback? onViewModePressed,
    required VoidCallback onSettingsPressed,
    required bool showFoldersToggle,
    required bool showTemplatesToggle,
    required bool showViewModeToggle,
  }) {
    final s = S.of(context);

    return PopupMenuButton<String>(
      tooltip: s.more_options,
      icon: const Icon(Icons.more_vert_rounded),
      position: PopupMenuPosition.under,
      onSelected: (value) {
        switch (value) {
          case 'folders':
            onFoldersPressed?.call();
            break;
          case 'templates':
            onTemplatesPressed?.call();
            break;
          case 'view_mode':
            onViewModePressed?.call();
            break;
          case 'settings':
            onSettingsPressed.call();
            break;
        }
      },
      itemBuilder: (context) {
        final items = <PopupMenuEntry<String>>[];

        if (showFoldersToggle && onFoldersPressed != null) {
          items.add(
            PopupMenuItem(
              value: 'folders',
              child: ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text(s.folders),
              ),
            ),
          );
        }

        if (showTemplatesToggle && onTemplatesPressed != null) {
          items.add(
            PopupMenuItem(
              value: 'templates',
              child: ListTile(
                leading: const Icon(Icons.library_books_outlined),
                title: Text(s.templates),
              ),
            ),
          );
        }

        if (showViewModeToggle && onViewModePressed != null) {
          items.add(
            PopupMenuItem(
              value: 'view_mode',
              child: ListTile(
                leading: const Icon(Icons.grid_view_outlined),
                title: Text(s.grid_view),
              ),
            ),
          );
        }

        if (items.isNotEmpty) {
          items.add(const PopupMenuDivider());
        }

        items.add(
          PopupMenuItem(
            value: 'settings',
            child: ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(s.settings),
            ),
          ),
        );

        return items;
      },
    );
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
        duration:
            const Duration(milliseconds: 250),
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
                key: ValueKey('title'),
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
          : (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                  tooltip: s.back,
                )
              : null),
      actions: actions,
      shape: ContinuousRectangleBorder(
        borderRadius: bottomBorderRadius ?? BorderRadius.zero,
      ),
    );
  }
}
