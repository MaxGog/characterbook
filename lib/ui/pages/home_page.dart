import 'package:characterbook/ui/pages/random_number_page.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'characters/character_list_page.dart';
import 'notes/note_list_page.dart';
import 'races/race_list_page.dart';
import 'search_page.dart';
import 'settings_page.dart';
import 'home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static const List<Widget> _pages = [
    HomeScreen(),
    CharacterListPage(),
    RaceListPage(),
    NotesListPage(),
    SearchPage(),
    SettingsPage(),
    RandomNumberPage(),
  ];

  static const List<IconData> _pageIcons = [
    Icons.home_outlined,
    Icons.people_alt_outlined,
    Icons.emoji_people_outlined,
    Icons.note_alt_outlined,
    Icons.search_outlined,
    Icons.settings_outlined,
    Icons.casino_outlined,
  ];

  static const List<IconData> _selectedPageIcons = [
    Icons.home_rounded,
    Icons.people_alt_rounded,
    Icons.emoji_people_rounded,
    Icons.note_alt_rounded,
    Icons.search_rounded,
    Icons.settings_rounded,
    Icons.casino_rounded,
  ];

  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _widthAnimation = Tween<double>(
      begin: 80.0,
      end: 200.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<String> _getPageTitles(BuildContext context) => [
        S.of(context).home,
        S.of(context).characters,
        S.of(context).races,
        S.of(context).posts,
        S.of(context).search,
        S.of(context).settings,
        S.of(context).dnd_tools,
      ];

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return _DesktopLayout(
                currentIndex: _currentIndex,
                pages: _pages,
                pageTitles: _getPageTitles(context),
                pageIcons: _pageIcons,
                selectedPageIcons: _selectedPageIcons,
                onIndexChanged: _updateIndex,
                isExpanded: _isExpanded,
                widthAnimation: _widthAnimation,
                onToggleExpanded: _toggleExpanded,
              );
            } else {
              return _MobileLayout(
                currentIndex: _currentIndex,
                pages: _pages,
                pageTitles: _getPageTitles(context),
                pageIcons: _pageIcons,
                selectedPageIcons: _selectedPageIcons,
                onIndexChanged: _updateIndex,
              );
            }
          },
        ),
      ),
    );
  }

  void _updateIndex(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.currentIndex,
    required this.pages,
    required this.pageTitles,
    required this.pageIcons,
    required this.selectedPageIcons,
    required this.onIndexChanged,
    required this.isExpanded,
    required this.widthAnimation,
    required this.onToggleExpanded,
  });

  final int currentIndex;
  final List<Widget> pages;
  final List<String> pageTitles;
  final List<IconData> pageIcons;
  final List<IconData> selectedPageIcons;
  final ValueChanged<int> onIndexChanged;
  final bool isExpanded;
  final Animation<double> widthAnimation;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AnimatedNavigationRail(
          currentIndex: currentIndex,
          pageTitles: pageTitles,
          pageIcons: pageIcons,
          selectedPageIcons: selectedPageIcons,
          onIndexChanged: onIndexChanged,
          isExpanded: isExpanded,
          widthAnimation: widthAnimation,
          onToggleExpanded: onToggleExpanded,
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: pages[currentIndex],
          ),
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.currentIndex,
    required this.pages,
    required this.pageTitles,
    required this.pageIcons,
    required this.selectedPageIcons,
    required this.onIndexChanged,
  });

  final int currentIndex;
  final List<Widget> pages;
  final List<String> pageTitles;
  final List<IconData> pageIcons;
  final List<IconData> selectedPageIcons;
  final ValueChanged<int> onIndexChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onIndexChanged,
            backgroundColor: Colors.transparent,
            elevation: 0,
            height: 72,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            animationDuration: const Duration(milliseconds: 400),
            destinations: [
              _buildExpressiveDestination(
                context,
                icon: pageIcons[0],
                selectedIcon: selectedPageIcons[0],
                label: pageTitles[0],
              ),
              _buildExpressiveDestination(
                context,
                icon: pageIcons[1],
                selectedIcon: selectedPageIcons[1],
                label: pageTitles[1],
              ),
              _buildExpressiveDestination(
                context,
                icon: pageIcons[2],
                selectedIcon: selectedPageIcons[2],
                label: pageTitles[2],
              ),
              _buildExpressiveDestination(
                context,
                icon: pageIcons[3],
                selectedIcon: selectedPageIcons[3],
                label: pageTitles[3],
              ),
              _buildExpressiveDestination(
                context,
                icon: pageIcons[4],
                selectedIcon: selectedPageIcons[4],
                label: pageTitles[4],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpressiveDestination(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return NavigationDestination(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.surfaceContainerHighest.withOpacity(0.6),
        ),
        child: Icon(
          icon,
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),
      selectedIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.secondaryContainer,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          selectedIcon,
          color: colorScheme.onPrimaryContainer,
          size: 24,
        ),
      ),
      label: label,
    );
  }

}

class _AnimatedNavigationRail extends StatelessWidget {
  const _AnimatedNavigationRail({
    required this.currentIndex,
    required this.pageTitles,
    required this.pageIcons,
    required this.selectedPageIcons,
    required this.onIndexChanged,
    required this.isExpanded,
    required this.widthAnimation,
    required this.onToggleExpanded,
  });

  final int currentIndex;
  final List<String> pageTitles;
  final List<IconData> pageIcons;
  final List<IconData> selectedPageIcons;
  final ValueChanged<int> onIndexChanged;
  final bool isExpanded;
  final Animation<double> widthAnimation;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => onToggleExpanded(),
      onExit: (_) => onToggleExpanded(),
      child: AnimatedBuilder(
        animation: widthAnimation,
        builder: (context, child) {
          return Container(
            width: widthAnimation.value,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              border: Border(
                right: BorderSide(
                  color: colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                _NavigationHeader(
                  isExpanded: isExpanded,
                  onToggle: onToggleExpanded,
                  widthAnimation: widthAnimation,
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        pageTitles.length,
                        (index) => _AnimatedNavItem(
                          icon: currentIndex == index 
                              ? selectedPageIcons[index] 
                              : pageIcons[index],
                          label: pageTitles[index],
                          isSelected: currentIndex == index,
                          isExpanded: isExpanded,
                          widthAnimation: widthAnimation,
                          onTap: () => onIndexChanged(index),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NavigationHeader extends StatelessWidget {
  const _NavigationHeader({
    required this.isExpanded,
    required this.onToggle,
    required this.widthAnimation,
  });

  final bool isExpanded;
  final VoidCallback onToggle;
  final Animation<double> widthAnimation;

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    
    return AnimatedBuilder(
      animation: widthAnimation,
      builder: (context, child) {
        return Container(
          height: 60,
          padding: EdgeInsets.symmetric(
            horizontal: widthAnimation.value == 80 ? 16 : 24,
          ),
          child: Row(
            mainAxisAlignment: widthAnimation.value == 80 
                ? MainAxisAlignment.center 
                : MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onToggle,
                icon: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: isExpanded ? 0.5 : 0,
                  child: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnimatedNavItem extends StatelessWidget {
  const _AnimatedNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.widthAnimation,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final Animation<double> widthAnimation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: widthAnimation,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widthAnimation.value == 80 ? 8 : 12,
            vertical: 4,
          ),
          child: Material(
            color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widthAnimation.value == 80 ? 12 : 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(
                          color: colorScheme.primary,
                          width: 1.5,
                        )
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: widthAnimation.value == 80 
                      ? MainAxisAlignment.center 
                      : MainAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      color: isSelected 
                          ? colorScheme.primary 
                          : colorScheme.onSurfaceVariant,
                      size: 22,
                    ),
                    if (widthAnimation.value > 80) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isExpanded ? 1.0 : 0.0,
                          child: Text(
                            label,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected 
                                  ? colorScheme.primary 
                                  : colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}