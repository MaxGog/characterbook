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
  bool _isExpanded = true;

  static final List<Widget> _pages = const [
    CharacterListPage(),
    RaceListPage(),
    NotesListPage(),
    SearchPage(),
    RandomNumberPage(),
    SettingsPage(),
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
    return SizedBox(
      width: _isExpanded ? 200 : 72,
      child: NavigationRail(
        minWidth: _isExpanded ? 200 : 72,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedIndex: _currentIndex,
        onDestinationSelected: _updateIndex,
        extended: _isExpanded,
        labelType: _isExpanded
            ? NavigationRailLabelType.all
            : NavigationRailLabelType.selected,
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.people_alt_outlined),
            selectedIcon: const Icon(Icons.people_alt),
            label: Text(S.of(context).characters),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.emoji_people_outlined),
            selectedIcon: const Icon(Icons.emoji_people),
            label: Text(S.of(context).races),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.note_alt_outlined),
            selectedIcon: const Icon(Icons.note_alt),
            label: Text(S.of(context).posts),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
            label: Text(S.of(context).search),
          ),
        ],
        trailing: IconButton(
          icon: Icon(_isExpanded ? Icons.chevron_left : Icons.chevron_right),
          onPressed: () => setState(() => _isExpanded = !_isExpanded),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: _updateIndex,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.people_alt_outlined),
          selectedIcon: const Icon(Icons.people_alt),
          label: S.of(context).characters,
        ),
        NavigationDestination(
          icon: const Icon(Icons.emoji_people_outlined),
          selectedIcon: const Icon(Icons.emoji_people),
          label: S.of(context).races,
        ),
        NavigationDestination(
          icon: const Icon(Icons.note_alt_outlined),
          selectedIcon: const Icon(Icons.note_alt),
          label: S.of(context).posts,
        ),
        NavigationDestination(
          icon: const Icon(Icons.search),
          selectedIcon: const Icon(Icons.search_outlined),
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