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

  static final List<Widget> _pages = const [
    CharacterListPage(),
    RaceListPage(),
    NotesListPage(),
    SearchPage(),
    RandomNumberPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(context),
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

  void _updateIndex(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}