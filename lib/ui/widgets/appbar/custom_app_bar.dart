import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../pages/settings_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isSearching;
  final TextEditingController? searchController;
  final VoidCallback onSearchToggle;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final List<Widget>? additionalActions;
  final VoidCallback? onTemplatesPressed;
  final VoidCallback? onViewModePressed;
  final bool showViewModeToggle;
  final bool showTemplatesToggle;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.isSearching,
    this.searchController,
    required this.onSearchToggle,
    this.searchHint,
    this.onSearchChanged,
    this.additionalActions,
    this.onTemplatesPressed,
    this.onViewModePressed,
    this.showViewModeToggle = true,
    this.showTemplatesToggle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return AppBar(
      title: AnimatedCrossFade(
        duration: const Duration(milliseconds: 200),
        crossFadeState: isSearching 
            ? CrossFadeState.showSecond 
            : CrossFadeState.showFirst,
        firstChild: Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            height: 1.1,
            letterSpacing: -0.8,
          ),
        ),
        secondChild: _buildSearchField(context, colorScheme, s),
      ),
      centerTitle: false,
      titleSpacing: 24,
      toolbarHeight: 80,
      elevation: 0,
      scrolledUnderElevation: 3,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      backgroundColor: colorScheme.surfaceContainerLowest,
      actions: _buildActions(context, colorScheme, s),
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
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
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28)),
          )
        ),
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

  List<Widget> _buildActions(BuildContext context, ColorScheme colorScheme, S s) {
    final actions = <Widget>[];
    const maxVisibleActions = 4;
    const actionSpacing = 8.0;

    if (isSearching) {
      return [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filledTonal(
              key: const ValueKey('search-close'),
              onPressed: onSearchToggle,
              icon: const Icon(Icons.close_rounded),
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ),
      ];
    }

    final mainActions = <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: actionSpacing),
        child: IconButton.filledTonal(
          icon: const Icon(Icons.search_outlined),
          onPressed: onSearchToggle,
          tooltip: s.search,
          style: IconButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
        ),
      ),
    ];

    if (showViewModeToggle && onViewModePressed != null) {
      mainActions.add(
        Padding(
          padding: const EdgeInsets.only(left: actionSpacing),
          child: IconButton.filledTonal(
            icon: const Icon(Icons.grid_view_outlined),
            onPressed: onViewModePressed,
            tooltip: s.grid_view,
            style: IconButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      );
    }

    if (showTemplatesToggle && onTemplatesPressed != null) {
      mainActions.add(
        Padding(
          padding: const EdgeInsets.only(left: actionSpacing),
          child: IconButton.filledTonal(
            icon: const Icon(Icons.library_books_outlined),
            onPressed: onTemplatesPressed,
            tooltip: s.templates,
            style: IconButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      );
    }

    actions.addAll(mainActions);

    if (additionalActions != null) {
      for (var action in additionalActions!) {
        actions.add(
          Padding(
            padding: const EdgeInsets.only(left: actionSpacing),
            child: action is IconButton 
                ? IconButton.filledTonal(
                    icon: action.icon,
                    onPressed: action.onPressed,
                    tooltip: action.tooltip,
                    style: IconButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                  )
                : action,
          ),
        );
      }
    }

    final settingsAction = Padding(
      padding: const EdgeInsets.only(left: actionSpacing, right: 12),
      child: IconButton.filledTonal(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        ),
        icon: const Icon(Icons.settings_outlined),
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
        ),
      ),
    );

    if (actions.length + 1 > maxVisibleActions) {
      final visibleActions = actions.take(maxVisibleActions - 1).toList();
      
      final menuActions = [
        ...actions.skip(maxVisibleActions - 1),
        settingsAction,
      ];

      return [
        ...visibleActions,
        Padding(
          padding: const EdgeInsets.only(left: actionSpacing),
          child: PopupMenuButton(
            icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
            itemBuilder: (context) => menuActions.map((action) {
              if (action is Padding && action.child is IconButton) {
                final iconButton = action.child as IconButton;
                return PopupMenuItem(
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      iconButton.onPressed?.call();
                    });
                  },
                  child: ListTile(
                    leading: iconButton.icon,
                    title: Text(iconButton.tooltip ?? ''),
                  ),
                );
              }
              return PopupMenuItem(child: action);
            }).toList(),
          ),
        ),
      ];
    } else {
      actions.add(settingsAction);
      return actions;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}