import 'package:characterbook/ui/pages/settings_page.dart';
import 'package:characterbook/ui/pages/export_pdf_settings_page.dart';
import 'package:characterbook/ui/pages/random_number_page.dart';
import 'package:characterbook/ui/pages/templates_page.dart';
import 'package:characterbook/ui/widgets/buttons/custom_floating_buttons.dart';
import 'package:characterbook/ui/widgets/cards/character_keep_card.dart';
import 'package:characterbook/ui/widgets/cards/race_keep_card.dart';
import 'package:characterbook/ui/widgets/tools_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:characterbook/models/characters/character_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/services/character_service.dart';
import 'package:characterbook/services/race_service.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/ui/pages/character_management_page.dart';
import 'package:characterbook/ui/pages/race_management_page.dart';
import 'package:characterbook/ui/cards/character_modal_card.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData();
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
      await _characterService.deleteCharacter(int.parse(character.id));
      if (mounted) {
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).character_deleted)),
        );
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
      await _raceService.deleteRace(int.parse(race.id));
      if (mounted) {
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).race_deleted)),
        );
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
    // TODO: Реализовать импорт контента
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Импорт будет реализован позже')),
    );
  }

  void _createFromTemplate() {
    // TODO: Реализовать создание из шаблона
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Создание из шаблона будет реализовано позже')),
    );
  }

  void _openSettings() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingsPage()));
  }

  void _navigateToTool(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return S.of(context).days_ago(date.day);
    } else if (difference.inDays == 1) {
      return S.of(context).days_ago(date.day);
    } else if (difference.inDays < 7) {
      return S.of(context).days_ago(difference.inDays);
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else {
      return '${(difference.inDays / 30).floor()}mo ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CharacterBook',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
            tooltip: s.settings,
          ),
        ],
      ),
      floatingActionButton: _selectedContentType != HomeContentType.tools
          ? CustomFloatingButtons(
              onAdd: _createNewContent,
              onImport: _importContent,
              onTemplate: _createFromTemplate,
              showImportButton: true,
              addTooltip: _selectedContentType == HomeContentType.characters
                  ? 'Создать персонажа'
                  : 'Создать расу',
              importTooltip: 'Импортировать',
              templateTooltip: 'Создать из шаблона',
              createFromScratchTooltip:
                  _selectedContentType == HomeContentType.characters
                      ? 'Создать персонажа'
                      : 'Создать расу',
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
                  label: Text('${s.characters} (${_characters.length})'),
                ),
                ButtonSegment<HomeContentType>(
                  value: HomeContentType.races,
                  label: Text('${s.races} (${_races.length})'),
                ),
                ButtonSegment<HomeContentType>(
                  value: HomeContentType.tools,
                  label: const Text('Инструменты'),
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

    final tools = [
      _ToolItem(
        title: 'Генератор случайных чисел',
        subtitle: 'Генерация случайных чисел в заданном диапазоне',
        icon: Icons.casino_rounded,
        iconColor: colorScheme.primary,
        onTap: () => _navigateToTool(const RandomNumberPage()),
      ),
      _ToolItem(
        title: 'Настройки PDF экспорта',
        subtitle: 'Настройка параметров экспорта персонажей в PDF',
        icon: Icons.picture_as_pdf_rounded,
        iconColor: colorScheme.primary,
        onTap: () => _navigateToTool(const ExportPdfSettingsPage()),
      ),
      _ToolItem(
        title: 'Шаблоны',
        subtitle: 'Управление шаблонами персонажей',
        icon: Icons.library_books_rounded,
        iconColor: colorScheme.primary,
        onTap: () => _navigateToTool(const TemplatesPage()),
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
