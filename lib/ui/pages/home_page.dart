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

  static final List<Widget> _pages = const [
    CharacterListPage(),
    RaceListPage(),
    NotesListPage(),
    SearchPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLargeScreen = mediaQuery.size.width >= 600;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: !isLargeScreen && _currentIndex < 4
          ? _buildBottomNavigationBar(context)
          : isLargeScreen
              ? null
              : _buildBottomAppBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              _currentIndex == 0 
                  ? Icons.people_alt 
                  : Icons.people_alt_outlined,
            ),
            onPressed: () => _updateIndex(0),
          ),
          IconButton(
            icon: Icon(
              _currentIndex == 1 
                  ? Icons.emoji_people 
                  : Icons.emoji_people_outlined,
            ),
            onPressed: () => _updateIndex(1),
          ),
          const SizedBox(width: 48),
          IconButton(
            icon: Icon(
              _currentIndex == 2 
                  ? Icons.note_alt 
                  : Icons.note_alt_outlined,
            ),
            onPressed: () => _updateIndex(2),
          ),
          IconButton(
            icon: Icon(
              _currentIndex == 3 
                  ? Icons.search 
                  : Icons.search_outlined,
            ),
            onPressed: () => _updateIndex(3),
          ),
        ],
      ),
    );
  }

  void _updateIndex(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}