import 'package:characterbook/ui/pages/random_number_page.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'characters/character_list_page.dart';
import 'notes/note_list_page.dart';
import 'races/race_list_page.dart';
import 'search_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final bool _isExpanded = false;

  static final List<Widget> _pages = const [
    CharacterListPage(),
    RaceListPage(),
    NotesListPage(),
    SearchPage(),
    SettingsPage(),
    RandomNumberPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      body: SafeArea(
        child: isWideScreen
            ? _buildDesktopLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        _buildNavigationRail(context),
        Expanded(
          child: _pages[_currentIndex],
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _pages[_currentIndex],
        ),
        _buildBottomNavigationBar(context),
      ],
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return NavigationRail(
      minWidth: _isExpanded ? 180 : 72,
      backgroundColor: colorScheme.surfaceContainerLowest,
      elevation: 1,
      selectedIndex: _currentIndex,
      onDestinationSelected: _updateIndex,
      extended: _isExpanded,
      labelType: _isExpanded
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.selected,
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.people_alt_outlined,
              color: colorScheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.people_alt, color: colorScheme.primary),
          label: Text(
            S.of(context).characters,
            style: theme.textTheme.labelMedium?.copyWith(
              color: _currentIndex == 0
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.emoji_people_outlined,
              color: colorScheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.emoji_people, color: colorScheme.primary),
          label: Text(
            S.of(context).races,
            style: theme.textTheme.labelMedium?.copyWith(
              color: _currentIndex == 1
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.note_alt_outlined,
              color: colorScheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.note_alt, color: colorScheme.primary),
          label: Text(
            S.of(context).posts,
            style: theme.textTheme.labelMedium?.copyWith(
              color: _currentIndex == 2
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.search_outlined,
              color: colorScheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.search, color: colorScheme.primary),
          label: Text(
            S.of(context).search,
            style: theme.textTheme.labelMedium?.copyWith(
              color: _currentIndex == 3
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        /*NavigationRailDestination(
          icon: Icon(Icons.settings_outlined,
              color: colorScheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.settings, color: colorScheme.primary),
          label: Text(
            S.of(context).settings,
            style: theme.textTheme.labelMedium?.copyWith(
              color: _currentIndex == 3
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),*/
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return NavigationBar(
      height: 80,
      elevation: 1,
      backgroundColor: colorScheme.surfaceContainerLowest,
      selectedIndex: _currentIndex,
      onDestinationSelected: _updateIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.people_alt_outlined,
              color: colorScheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.people_alt, color: colorScheme.primary),
          label: S.of(context).characters,
        ),
        NavigationDestination(
          icon: Icon(Icons.emoji_people_outlined,
              color: colorScheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.emoji_people, color: colorScheme.primary),
          label: S.of(context).races,
        ),
        NavigationDestination(
          icon: Icon(Icons.note_alt_outlined,
              color: colorScheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.note_alt, color: colorScheme.primary),
          label: S.of(context).posts,
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined,
              color: colorScheme.onSurfaceVariant),
          selectedIcon: Icon(Icons.search, color: colorScheme.primary),
          label: S.of(context).search,
        ),
      ],
    );
  }

  void _updateIndex(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }
}