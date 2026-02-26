import 'dart:async';

import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/services/character_service.dart';
import 'package:characterbook/services/race_service.dart';
import 'package:characterbook/ui/cards/character_modal_card.dart';
import 'package:characterbook/ui/cards/race_modal_card.dart';
import 'package:characterbook/ui/pages/calendar_page.dart';
import 'package:characterbook/ui/pages/character_management_page.dart';
import 'package:characterbook/ui/pages/export_pdf_settings_page.dart';
import 'package:characterbook/ui/pages/race_management_page.dart';
import 'package:characterbook/ui/pages/random_number_page.dart';
import 'package:characterbook/ui/pages/templates_page.dart';
import 'package:characterbook/ui/widgets/appbar/common_main_app_bar.dart';
import 'package:characterbook/ui/widgets/buttons/common_list_floating_buttons.dart';
import 'package:characterbook/ui/widgets/cards/character_keep_card.dart';
import 'package:characterbook/ui/widgets/cards/race_keep_card.dart';
import 'package:characterbook/ui/widgets/tools_context_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CharacterService _characterService = CharacterService.forDatabase();
  final RaceService _raceService = RaceService.forDatabase();

  List<Character> _characters = [];
  List<Race> _races = [];
  List<dynamic> _allContent = [];
  List<dynamic> _filteredContent = [];
  String _searchQuery = '';
  HomeContentType _selectedContentType = HomeContentType.charactersAndRaces;

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();

    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
          _filterData();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final characters = await _characterService.getAllCharacters();
      final races = await _raceService.getAllRaces();

      if (mounted) {
        setState(() {
          _characters = characters;
          _races = races;
          _allContent = [...characters, ...races];
          _filteredContent = _allContent;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).error}: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _changeContentType(HomeContentType type) {
    setState(() {
      _selectedContentType = type;
      if (_isSearching) {
        _isSearching = false;
        _searchController.clear();
      }
    });
  }

  void _filterData() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredContent = _allContent;
      });
    } else {
      final query = _searchQuery.toLowerCase();
      setState(() {
        _filteredContent = _allContent.where((item) {
          if (item is Character) {
            return item.name.toLowerCase().contains(query);
          } else if (item is Race) {
            return item.name.toLowerCase().contains(query);
          }
          return false;
        }).toList();
      });
    }
  }

  void _onSearchToggle() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
        _filterData();
      }
    });
  }

  void _onSearchChanged(String value) {
    if (mounted) {
      setState(() {
        _searchQuery = value;
        _filterData();
      });
    }
  }

  int _getCharacterCountForRace(Race race) {
    return _characters
        .where((character) => character.race?.id == race.id)
        .length;
  }

  void _showCharacterDetail(Character character) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CharacterModalCard(character: character),
    );
  }

  void _showCharacterContextMenu(Character character) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu.character(
        character: character,
        onEdit: () {
          Navigator.of(context).pop();
          _editCharacter(character);
        },
        onDelete: () async {
          await _showDeleteCharacterDialog(character);
        },
      ),
    );
  }

  void _showRaceContextMenu(Race race) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu.race(
        race: race,
        onEdit: () {
          Navigator.of(context).pop();
          _editRace(race);
        },
        onDelete: () async {
          await _showDeleteRaceDialog(race);
        },
      ),
    );
  }

  Future<void> _editCharacter(Character character) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterEditPage(character: character),
      ),
    );

    if (result == true && mounted) {
      await _loadData();
    }
  }

  void _showRaceDetail(Race race) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RaceModalCard(race: race),
    );
  }

  Future<void> _editRace(Race race) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RaceManagementPage(race: race),
      ),
    );

    if (result == true && mounted) {
      await _loadData();
    }
  }

  Future<void> _showDeleteCharacterDialog(Character character) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).character_delete_title),
        content: Text(S.of(context).character_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _performDeleteCharacter(character);
    }
  }

  Future<void> _performDeleteCharacter(Character character) async {
    final originalCharacters = List<Character>.from(_characters);
    try {
      setState(() {
        _characters.removeWhere((c) => c.key == character.key);
        _allContent.removeWhere(
            (item) => item is Character && item.key == character.key);
        _filteredContent.removeWhere(
            (item) => item is Character && item.key == character.key);
      });

      await _characterService.deleteCharacter(character);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).character_deleted),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _characters = originalCharacters;
          _allContent = [..._characters, ..._races];
          _filteredContent = _allContent;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).delete_error}: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _showDeleteRaceDialog(Race race) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).race_delete_title),
        content: Text(S.of(context).race_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _performDeleteRace(race);
    }
  }

  Future<void> _performDeleteRace(Race race) async {
    final originalRaces = List<Race>.from(_races);
    try {
      setState(() {
        _races.removeWhere((r) => r.key == race.key);
        _allContent.removeWhere((item) => item is Race && item.key == race.key);
        _filteredContent
            .removeWhere((item) => item is Race && item.key == race.key);
      });

      await _raceService.deleteRace(race.key);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).race_deleted),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _races = originalRaces;
          _allContent = [..._characters, ..._races];
          _filteredContent = _allContent;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).delete_error}: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _createNewContent() async {
    Widget page;

    page = const CharacterEditPage();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    if (result == true && mounted) {
      await _loadData();
    }
  }

  void _importContent() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).import_cancelled),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _createFromTemplate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${S.of(context).templates_not_found} - ${S.of(context).import_cancelled}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToTool(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return S.of(context).just_now;
    } else if (difference.inDays == 1) {
      return S.of(context).days_ago(1);
    } else if (difference.inDays < 7) {
      return S.of(context).days_ago(difference.inDays);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${S.of(context).week}';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ${S.of(context).month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: CommonMainAppBar(
        title: s.app_name,
        isSearching: _isSearching,
        searchController: _searchController,
        onSearchToggle: _onSearchToggle,
        searchHint: s.search,
        onSearchChanged: _onSearchChanged,
        showViewModeToggle: false,
        showTemplatesToggle: false,
      ),
      floatingActionButton:
          _selectedContentType == HomeContentType.charactersAndRaces
              ? CommonListFloatingButtons(
                  onAdd: _createNewContent,
                  onImport: _importContent,
                  onTemplate: _createFromTemplate,
                  showImportButton: true,
                  addTooltip: s.new_character,
                  importTooltip: s.import,
                  templateTooltip: s.create_from_template_tooltip,
                  createFromScratchTooltip: s.new_character,
                  heroTag: "home_list",
                )
              : null,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<HomeContentType>(
                segments: [
                  ButtonSegment<HomeContentType>(
                    value: HomeContentType.charactersAndRaces,
                    label: Text(s.characters_and_races),
                  ),
                  ButtonSegment<HomeContentType>(
                    value: HomeContentType.tools,
                    label: Text(s.dnd_tools),
                  ),
                ],
                selected: <HomeContentType>{_selectedContentType},
                onSelectionChanged: (Set<HomeContentType> newSelection) {
                  _changeContentType(newSelection.first);
                },
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: _selectedContentType == HomeContentType.tools
                  ? _buildToolsContent()
                  : _buildContentGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolsContent() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    final tools = [
      _ToolItem(
        title: s.randomNumberGenerator,
        subtitle: '',
        icon: Icons.casino_rounded,
        iconColor: colorScheme.primary,
        onTap: () => _navigateToTool(const RandomNumberPage()),
      ),
      _ToolItem(
        title: s.export_pdf_settings,
        subtitle: '',
        icon: Icons.picture_as_pdf_rounded,
        iconColor: colorScheme.primary,
        onTap: () => _navigateToTool(const ExportPdfSettingsPage()),
      ),
      _ToolItem(
        title: s.templates,
        subtitle: '',
        icon: Icons.library_books_rounded,
        iconColor: colorScheme.primary,
        onTap: () => _navigateToTool(const TemplatesPage()),
      ),
      _ToolItem(
        title: s.calendar,
        subtitle: s.event_calendar,
        icon: Icons.calendar_today_rounded,
        iconColor: colorScheme.primary,
        onTap: () => _navigateToTool(const CalendarPage()),
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(4.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _calculateCrossAxisCount(context),
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: 1.0,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return ToolKeepCard(
          title: tool.title,
          subtitle: tool.subtitle,
          icon: tool.icon,
          iconColor: tool.iconColor,
          onTap: tool.onTap,
        );
      },
    );
  }

  Widget _buildContentGrid() {
    if (_filteredContent.isEmpty) {
      return _buildEmptyState();
    }
    return _buildCombinedGrid();
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 64,
                color: colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                _searchQuery.isEmpty ? s.no_content_home : s.nothing_found,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              if (_searchQuery.isEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  s.create_first_content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _createNewContent,
                  child: Text(s.create),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCombinedGrid() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: GridView.builder(
        padding: const EdgeInsets.all(4.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _calculateCrossAxisCount(context),
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: 1.0,
        ),
        itemCount: _filteredContent.length,
        itemBuilder: (context, index) {
          final item = _filteredContent[index];

          if (item is Character) {
            return CharacterKeepCard(
              character: item,
              onTap: () => _showCharacterDetail(item),
              onContextMenuTap: () => _showCharacterContextMenu(item),
              formattedDate: _formatDate(item.lastEdited),
            );
          } else if (item is Race) {
            return RaceKeepCard(
              race: item,
              characterCount: _getCharacterCountForRace(item),
              onTap: () => _showRaceDetail(item),
              onContextMenuTap: () => _showRaceContextMenu(item),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
  

  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1200) return 5;
    if (screenWidth >= 800) return 4;
    if (screenWidth >= 600) return 3;
    return 2;
  }
}

class ToolKeepCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const ToolKeepCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6.0),
        constraints: const BoxConstraints(
          minWidth: 160,
          minHeight: 160,
          maxWidth: 180,
          maxHeight: 180,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(4.0),
            onTap: onTap,
            splashColor: colorScheme.primary.withOpacity(0.2),
            highlightColor: colorScheme.primary.withOpacity(0.1),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 48,
                      color: iconColor.withOpacity(0.5),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  _ToolItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });
}

enum HomeContentType {
  charactersAndRaces,
  tools,
}
