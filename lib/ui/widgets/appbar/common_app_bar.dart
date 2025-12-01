import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../pages/settings_page.dart';

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
  final bool showViewModeToggle;
  final bool showTemplatesToggle;
  final bool showFoldersToggle;

  const CommonAppBar({
    super.key,
    required BuildContext context,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.onBack,
    this.showBackButton = true,
    this.backgroundColor,
    this.toolbarHeight = 80,
    this.isSearching = false,
    this.searchController,
    this.onSearchToggle,
    this.searchHint,
    this.onSearchChanged,
    this.onFoldersPressed,
    this.onTemplatesPressed,
    this.onViewModePressed,
    this.showViewModeToggle = false,
    this.showTemplatesToggle = false,
    this.showFoldersToggle = false,
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
    bool showViewModeToggle = true,
    bool showTemplatesToggle = true,
    bool showFoldersToggle = true,
  }) {
    return CommonAppBar(
      key: key,
      context: context,
      title: title,
      centerTitle: false,
      showBackButton: false,
      isSearching: isSearching,
      searchController: searchController,
      onSearchToggle: onSearchToggle,
      searchHint: searchHint,
      onSearchChanged: onSearchChanged,
      onFoldersPressed: onFoldersPressed,
      onTemplatesPressed: onTemplatesPressed,
      onViewModePressed: onViewModePressed,
      showViewModeToggle: showViewModeToggle,
      showTemplatesToggle: showTemplatesToggle,
      showFoldersToggle: showFoldersToggle,
      actions: _buildMainActions(
        context,
        isSearching,
        onSearchToggle,
        additionalActions,
        onFoldersPressed,
        onTemplatesPressed,
        onViewModePressed,
        showViewModeToggle,
        showTemplatesToggle,
        showFoldersToggle,
      ),
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

    return CommonAppBar(
      key: key,
      title: title,
      actions: actions,
      centerTitle: centerTitle,
      onBack: onBack,
      showBackButton: showBackButton, 
      context: context,
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
    final finalActions = <Widget>[
      if (actions != null) ...actions,
    ];

    return CommonAppBar(
      key: key,
      title: title,
      actions: finalActions,
      centerTitle: centerTitle,
      onBack: onBack,
      showBackButton: showBackButton,
      context: context,
    );
  }

  static List<Widget> _buildMainActions(
    BuildContext context,
    bool isSearching,
    VoidCallback onSearchToggle,
    List<Widget>? additionalActions,
    VoidCallback? onFoldersPressed,
    VoidCallback? onTemplatesPressed,
    VoidCallback? onViewModePressed,
    bool showViewModeToggle,
    bool showTemplatesToggle,
    bool showFoldersToggle,
  ) {
    if (isSearching) {
      return [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton.filledTonal(
            onPressed: onSearchToggle,
            icon: const Icon(Icons.close_rounded),
            style: IconButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ];
    }

    final actions = <Widget>[];
    const actionSpacing = 8.0;

    actions.add(
      Padding(
        padding: const EdgeInsets.only(left: actionSpacing),
        child: IconButton.filledTonal(
          icon: const Icon(Icons.search_outlined),
          onPressed: onSearchToggle,
          tooltip: S.of(context).search,
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );

    final hasMenuItems = (showFoldersToggle && onFoldersPressed != null) ||
        (showTemplatesToggle && onTemplatesPressed != null) ||
        (showViewModeToggle && onViewModePressed != null);

    if (hasMenuItems) {
      actions.add(
        Padding(
          padding: const EdgeInsets.only(left: actionSpacing),
          child: _buildCombinedMenu(
            context: context,
            onFoldersPressed: onFoldersPressed,
            onTemplatesPressed: onTemplatesPressed,
            onViewModePressed: onViewModePressed,
            showFoldersToggle: showFoldersToggle,
            showTemplatesToggle: showTemplatesToggle,
            showViewModeToggle: showViewModeToggle,
          ),
        ),
      );
    }

    if (additionalActions != null) {
      for (var action in additionalActions) {
        actions.add(
          Padding(
            padding: const EdgeInsets.only(left: actionSpacing),
            child: action,
          ),
        );
      }
    }

    actions.add(
      Padding(
        padding: const EdgeInsets.only(left: actionSpacing, right: 12),
        child: IconButton.filledTonal(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          icon: const Icon(Icons.settings_outlined),
          tooltip: S.of(context).settings,
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );

    return actions;
  }

  static Widget _buildCombinedMenu({
    required BuildContext context,
    required VoidCallback? onFoldersPressed,
    required VoidCallback? onTemplatesPressed,
    required VoidCallback? onViewModePressed,
    required bool showFoldersToggle,
    required bool showTemplatesToggle,
    required bool showViewModeToggle,
  }) {
    final s = S.of(context);

    final hasFoldersItem = showFoldersToggle && onFoldersPressed != null;
    final hasTemplatesItem = showTemplatesToggle && onTemplatesPressed != null;
    final hasViewModeItem = showViewModeToggle && onViewModePressed != null;
    final hasAnyItem = hasFoldersItem || hasTemplatesItem || hasViewModeItem;

    return PopupMenuButton<String>(
      tooltip: s.more_options,
      position: PopupMenuPosition.under,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      icon: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: hasAnyItem
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.more_vert_outlined,
          color: hasAnyItem
              ? Theme.of(context).colorScheme.onSecondaryContainer
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      itemBuilder: (context) {
        final items = <PopupMenuEntry<String>>[];

        if (hasFoldersItem) {
          items.add(
            PopupMenuItem<String>(
              value: 'folders',
              child: Row(
                children: [
                  const Icon(Icons.folder_outlined, size: 20),
                  const SizedBox(width: 12),
                  Text(s.folders),
                ],
              ),
            ),
          );
        }

        if (hasTemplatesItem) {
          if (items.isNotEmpty) items.add(const PopupMenuDivider());
          items.add(
            PopupMenuItem<String>(
              value: 'templates',
              child: Row(
                children: [
                  const Icon(Icons.library_books_outlined, size: 20),
                  const SizedBox(width: 12),
                  Text(s.templates),
                ],
              ),
            ),
          );
        }

        if (hasViewModeItem) {
          if (items.isNotEmpty) items.add(const PopupMenuDivider());
          items.add(
            PopupMenuItem<String>(
              value: 'view_mode',
              child: Row(
                children: [
                  const Icon(Icons.grid_view_outlined, size: 20),
                  const SizedBox(width: 12),
                  Text(s.grid_view),
                ],
              ),
            ),
          );
        }

        return items;
      },
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
        }
      },
    );
  }

  Widget _buildSearchField(BuildContext context, ColorScheme colorScheme, S s) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: SearchBar(
        focusNode: FocusNode(),
        controller: searchController,
        hintText: searchHint ?? s.search_hint,
        leading: const Icon(Icons.search_rounded),
        trailing: [
          if (searchController?.text.isNotEmpty ?? false)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: onSearchToggle,
            ),
        ],
        elevation: const WidgetStatePropertyAll(0),
        shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        )),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        backgroundColor: WidgetStatePropertyAll(
          colorScheme.surfaceContainerHigh,
        ),
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        overlayColor: WidgetStatePropertyAll(colorScheme.surfaceContainer),
        onChanged: onSearchChanged,
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
      title: isSearching && onSearchToggle != null
          ? AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: isSearching
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                title,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  height: 1.1,
                  letterSpacing: -0.8,
                ),
              ),
              secondChild: _buildSearchField(context, colorScheme, s),
            )
          : Text(
              title,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: centerTitle ? FontWeight.w800 : FontWeight.w700,
                height: 1.2,
                letterSpacing: centerTitle ? -0.5 : -0.8,
                color: colorScheme.onSurface,
              ),
            ),
      centerTitle: centerTitle,
      titleSpacing: 24,
      toolbarHeight: toolbarHeight,
      elevation: 0,
      scrolledUnderElevation: 3,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor ?? colorScheme.surfaceContainerLowest,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
              tooltip: S.of(context).back,
            )
          : null,
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