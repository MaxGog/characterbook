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
      title: isSearching
          ? _buildSearchField(context, theme, s)
          : Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontFamily: 'GoogleSans',
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.5,
                shadows: [
                  Shadow(
                    blurRadius: 1.0,
                    color: theme.colorScheme.onSurface,
                    offset: const Offset(0, 0.5),
                  ),
                ],
              ),
            ),
      centerTitle: true,
      titleSpacing: 20,
      elevation: 1,
      shadowColor: theme.colorScheme.shadow,
      surfaceTintColor: theme.colorScheme.surface,
      actions: _buildActions(context, theme, s),
    );
  }

  Widget _buildSearchField(BuildContext context, ThemeData theme, S s) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: searchController,
        autofocus: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
          hintText: searchHint ?? s.search_hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        style: theme.textTheme.bodyLarge,
        onChanged: onSearchChanged,
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, ThemeData theme, S s) {
    final actions = <Widget>[];

    if (isSearching) {
      actions.add(
        IconButton(
          icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
          onPressed: onSearchToggle,
          tooltip: s.cancel,
        ),
      );
    } else {
      actions.add(
        IconButton(
          icon: Icon(Icons.search, color: theme.colorScheme.onSurface),
          onPressed: onSearchToggle,
          tooltip: s.search,
        ),
      );

      if (showViewModeToggle && onViewModePressed != null) {
        actions.add(
          IconButton(
            icon: Icon(Icons.grid_view, color: theme.colorScheme.onSurface),
            onPressed: onViewModePressed,
            tooltip: s.grid_view,
          ),
        );
      }

      if (showTemplatesToggle && onTemplatesPressed != null) {
        actions.add(
          IconButton(
            icon: Icon(Icons.library_books_outlined, 
                color: theme.colorScheme.onSurface),
            onPressed: onTemplatesPressed,
            tooltip: s.templates,
          ),
        );
      }

      if (additionalActions != null) {
        actions.addAll(additionalActions!);
      }

      actions.add(
        IconButton(
          icon: Icon(Icons.settings_outlined, 
              color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          ),
          tooltip: s.settings,
        ),
      );

      if (actions.length > 4) {
        final overflowActions = actions.sublist(3, actions.length - 1);
        actions.removeRange(3, actions.length - 1);
        actions.insert(3, _buildOverflowMenu(overflowActions));
      }
    }

    return actions;
  }

  Widget _buildOverflowMenu(List<Widget> actions) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => actions
          .whereType<IconButton>()
          .map((action) => PopupMenuItem(
                child: ListTile(
                  leading: action.icon,
                  title: Text(action.tooltip ?? ''),
                ),
                onTap: action.onPressed,
              ))
          .toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}