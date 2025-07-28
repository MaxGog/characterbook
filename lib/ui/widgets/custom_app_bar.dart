import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../pages/settings_page.dart';

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
    final s = S.of(context);

    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              child: child,
            ),
          );
        },
        child: isSearching
            ? _buildSearchField(context, theme, s)
            : _buildTitle(context, theme),
      ),
      centerTitle: false,
      titleSpacing: 24,
      elevation: 0,
      scrolledUnderElevation: 3,
      shadowColor: theme.colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      actions: _buildActions(context, theme, s),
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return Text(
      title,
      key: const ValueKey('title'),
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
        height: 1.1,
        letterSpacing: -0.8,
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, ThemeData theme, S s) {
    return ConstrainedBox(
      key: const ValueKey('search'),
      constraints: const BoxConstraints(maxWidth: 500),
      child: TextField(
        controller: searchController,
        autofocus: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 8),
            child: Icon(
              Icons.search_rounded,
              size: 24,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: onSearchToggle,
          ),
          hintText: searchHint ?? s.search_hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHigh,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        onChanged: onSearchChanged,
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, ThemeData theme, S s) {
    final actions = <Widget>[];
    const actionSpacing = 4.0;

    if (isSearching) {
      return [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Center(
            key: ValueKey(isSearching),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton.tonal(
                onPressed: onSearchToggle,
                style: FilledButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ];
    }

    actions.add(
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Center(
          key: ValueKey(!isSearching),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: actionSpacing),
            child: IconButton.filledTonal(
              icon: const Icon(Icons.search_rounded),
              onPressed: onSearchToggle,
              tooltip: s.search,
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ),
    );

    if (showViewModeToggle && onViewModePressed != null) {
      actions.add(
        AnimatedOpacity(
          opacity: isSearching ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: actionSpacing),
              child: IconButton.filledTonal(
                icon: const Icon(Icons.grid_view_rounded),
                onPressed: onViewModePressed,
                tooltip: s.grid_view,
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (showTemplatesToggle && onTemplatesPressed != null) {
      actions.add(
        AnimatedOpacity(
          opacity: isSearching ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: actionSpacing),
              child: IconButton.filledTonal(
                icon: const Icon(Icons.library_books_rounded),
                onPressed: onTemplatesPressed,
                tooltip: s.templates,
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (additionalActions != null) {
      for (final action in additionalActions!) {
        if (action is IconButton) {
          actions.add(
            AnimatedOpacity(
              opacity: isSearching ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: actionSpacing),
                  child: IconButton.filledTonal(
                    icon: action.icon,
                    onPressed: action.onPressed,
                    tooltip: action.tooltip,
                    style: IconButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          actions.add(
            AnimatedOpacity(
              opacity: isSearching ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: action,
            ),
          );
        }
      }
    }

    actions.add(
      AnimatedOpacity(
        opacity: isSearching ? 0 : 1,
        duration: const Duration(milliseconds: 200),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: actionSpacing, right: 12),
            child: IconButton.filledTonal(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ),
              tooltip: s.settings,
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ),
    );

    if (actions.length > 5) {
      final overflowActions = actions.sublist(4, actions.length - 1);
      actions.removeRange(4, actions.length - 1);
      actions.insert(
        4,
        AnimatedOpacity(
          opacity: isSearching ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: _buildOverflowMenu(overflowActions),
        ),
      );
    }

    return actions;
  }

  Widget _buildOverflowMenu(List<Widget> actions) {
    return Center(
      child: PopupMenuButton(
        icon: const Icon(Icons.more_vert_rounded),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        itemBuilder: (context) => actions
            .whereType<AnimatedOpacity>()
            .map((animated) => animated.child)
            .whereType<Padding>()
            .map((padding) => padding.child as IconButton)
            .map((action) => PopupMenuItem(
                  height: 48,
                  onTap: action.onPressed,
                  child: ListTile(
                    leading: action.icon,
                    title: Text(action.tooltip ?? ''),
                    minLeadingWidth: 24,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}