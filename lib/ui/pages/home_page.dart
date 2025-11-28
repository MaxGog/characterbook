import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../models/character_model.dart';
import '../../models/race_model.dart';
import '../../services/character_service.dart';
import '../../services/race_service.dart';
import '../cards/character_modal_card.dart';
import '../widgets/appbar/common_main_app_bar.dart';
import '../widgets/buttons/common_list_floating_buttons.dart';
import '../widgets/cards/character_keep_card.dart';
import '../widgets/cards/race_keep_card.dart';
import '../widgets/tools_context_menu.dart';
import 'calendar_page.dart';
import 'character_management_page.dart';
import 'export_pdf_settings_page.dart';
import 'race_management_page.dart';
import 'random_number_page.dart';
import 'templates_page.dart';

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
  List<Character> _filteredCharacters = [];
  List<Race> _filteredRaces = [];
  String _searchQuery = '';
  HomeContentType _selectedContentType = HomeContentType.characters;

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _filterData();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final characters = await _characterService.getAllCharacters();
    final races = await _raceService.getAllRaces();

    setState(() {
      _characters = characters;
      _races = races;
      _filteredCharacters = characters;
      _filteredRaces = races;
    });
  }

  void _changeContentType(HomeContentType type) {
    setState(() {
      _selectedContentType = type;
    });
  }

  void _filterData() {
    if (_searchQuery.isEmpty) {
      setState(() {
        _filteredCharacters = _characters;
        _filteredRaces = _races;
      });
    } else {
      final query = _searchQuery.toLowerCase();
      setState(() {
        _filteredCharacters = _characters.where((character) {
          return character.name.toLowerCase().contains(query);
        }).toList();

        _filteredRaces = _races.where((race) {
          return race.name.toLowerCase().contains(query);
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
    setState(() {
      _searchQuery = value;
      _filterData();
    });
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
          Navigator.pop(context);
          _editCharacter(character);
        },
        onDelete: () {
          Navigator.pop(context);
          _deleteCharacter(character);
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
          Navigator.pop(context);
          _editRace(race);
        },
        onDelete: () {
          Navigator.pop(context);
          _deleteRace(race);
        },
      ),
    );
  }

  void _editCharacter(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterEditPage(character: character),
      ),
    ).then((_) => _loadData());
  }

  void _editRace(Race race) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RaceManagementPage(race: race),
      ),
    ).then((_) => _loadData());
  }

  Future<void> _deleteCharacter(Character character) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).character_delete_title),
        content: Text(S.of(context).character_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _characterService.deleteCharacter(character);
        if (mounted) {
          _loadData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).character_deleted)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('${S.of(context).delete_error}: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _deleteRace(Race race) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).race_delete_title),
        content: Text(S.of(context).race_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _raceService.deleteRace(race.key);
        if (mounted) {
          _loadData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).race_deleted)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('${S.of(context).delete_error}: ${e.toString()}')),
          );
        }
      }
    }
  }

  void _createNewContent() {
    if (_selectedContentType == HomeContentType.characters) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CharacterEditPage()),
      ).then((_) => _loadData());
    } else if (_selectedContentType == HomeContentType.races) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RaceManagementPage()),
      ).then((_) => _loadData());
    }
  }

  void _importContent() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).import_cancelled)),
    );
  }

  void _createFromTemplate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              '${S.of(context).templates_not_found} - ${S.of(context).import_cancelled}')),
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
      appBar: CustomAppBar(
        title: s.app_name,
        isSearching: _isSearching,
        searchController: _searchController,
        onSearchToggle: _onSearchToggle,
        searchHint: _selectedContentType == HomeContentType.characters
            ? s.search_characters
            : s.search,
        onSearchChanged: _onSearchChanged,
        showViewModeToggle: false,
        showTemplatesToggle: false,
      ),
      floatingActionButton: _selectedContentType != HomeContentType.tools
          ? CommonListFloatingButtons(
              onAdd: _createNewContent,
              onImport: _importContent,
              onTemplate: _createFromTemplate,
              showImportButton: true,
              addTooltip: _selectedContentType == HomeContentType.characters
                  ? s.new_character
                  : s.new_race,
              importTooltip: s.import,
              templateTooltip: s.create_from_template_tooltip,
              createFromScratchTooltip:
                  _selectedContentType == HomeContentType.characters
                      ? s.new_character
                      : s.new_race,
              heroTag: "home_list",
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<HomeContentType>(
              segments: [
                ButtonSegment<HomeContentType>(
                  value: HomeContentType.characters,
                  label: Text(s.characters),
                ),
                ButtonSegment<HomeContentType>(
                  value: HomeContentType.races,
                  label: Text(s.races),
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
          const SizedBox(height: 16),
          Expanded(
            child: _selectedContentType == HomeContentType.tools
                ? _buildToolsContent()
                : _buildContentGrid(),
          ),
        ],
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: tool.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(tool.icon, color: tool.iconColor),
            ),
            title: Text(
              tool.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              tool.subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
            onTap: tool.onTap,
          ),
        );
      },
    );
  }

  Widget _buildContentGrid() {
    if (_selectedContentType == HomeContentType.characters) {
      if (_filteredCharacters.isEmpty) {
        return _buildEmptyState();
      }
      return _buildCharactersKeepGrid();
    } else {
      if (_filteredRaces.isEmpty) {
        return _buildEmptyState();
      }
      return _buildRacesKeepGrid();
    }
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _selectedContentType == HomeContentType.characters
                ? Icons.person_outline_rounded
                : Icons.people_outline_rounded,
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
    );
  }

  Widget _buildCharactersKeepGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: _filteredCharacters.length,
      itemBuilder: (context, index) {
        final character = _filteredCharacters[index];
        return CharacterKeepCard(
          character: character,
          onTap: () => _showCharacterDetail(character),
          onContextMenuTap: () => _showCharacterContextMenu(character),
          formattedDate: _formatDate(character.lastEdited),
        );
      },
    );
  }

  Widget _buildRacesKeepGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: _filteredRaces.length,
      itemBuilder: (context, index) {
        final race = _filteredRaces[index];
        return RaceKeepCard(
          race: race,
          characterCount: _getCharacterCountForRace(race),
          onTap: () => _editRace(race),
          onContextMenuTap: () => _showRaceContextMenu(race),
        );
      },
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
  characters,
  races,
  tools,
}
