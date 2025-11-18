import 'package:flutter/material.dart';
import 'package:characterbook/models/characters/character_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/services/character_service.dart';
import 'package:characterbook/services/race_service.dart';
import 'package:characterbook/ui/widgets/search_bar.dart';
import 'package:characterbook/ui/widgets/category_chip.dart';
import 'package:characterbook/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CharacterService _characterService = CharacterService.forDatabase();
  final RaceService _raceService = RaceService.forDatabase();
  
  List<Character> _characters = [];
  List<Race> _races = [];
  List<Character> _filteredCharacters = [];
  List<Race> _filteredRaces = [];
  String _searchQuery = '';
  HomeContentType _selectedContentType = HomeContentType.characters;

  final List<Color> _cardColors = [
    const Color(0xFFF28B82), // Красный
    const Color(0xFFFBBC04), // Желтый
    const Color(0xFFFFF475), // Светло-желтый
    const Color(0xFFCCFF90), // Светло-зеленый
    const Color(0xFFA7FFEB), // Бирюзовый
    const Color(0xFFCBF0F8), // Голубой
    const Color(0xFFAECBFA), // Синий
    const Color(0xFFD7AEFB), // Фиолетовый
    const Color(0xFFFDCFE8), // Розовый
    const Color(0xFFE6C9A8), // Коричневый
    const Color(0xFFE8EAED), // Серый
  ];

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

  void _filterContent(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      
      if (_selectedContentType == HomeContentType.characters) {
        _filteredCharacters = _characters.where((character) =>
          character.name.toLowerCase().contains(_searchQuery) ||
          (character.race?.name.toLowerCase().contains(_searchQuery) ?? false) ||
          character.tags.any((tag) => tag.toLowerCase().contains(_searchQuery))
        ).toList();
      } else {
        _filteredRaces = _races.where((race) =>
          race.name.toLowerCase().contains(_searchQuery) ||
          race.description.toLowerCase().contains(_searchQuery) ||
          race.tags.any((tag) => tag.toLowerCase().contains(_searchQuery))
        ).toList();
      }
    });
  }

  void _changeContentType(HomeContentType type) {
    setState(() {
      _selectedContentType = type;
      _filterContent(_searchQuery);
    });
  }

  Color _getCardColor(Character character) {
    final index = character.name.hashCode % _cardColors.length;
    return _cardColors[index.abs()];
  }

  Color _getRaceCardColor(Race race) {
    final index = race.name.hashCode % _cardColors.length;
    return _cardColors[index.abs()];
  }

  Widget _buildCharacterKeepCard(Character character, int index) {
    final theme = Theme.of(context);
    final cardColor = _getCardColor(character);
    final textColor = ThemeData.estimateBrightnessForColor(cardColor) == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Container(
      margin: const EdgeInsets.all(8),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 1,
        color: cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            // TODO: Показать информацию о персонаже
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                if (character.race != null || character.age > 0)
                  Text(
                    [
                      if (character.race != null) character.race!.name,
                      if (character.age > 0) '${character.age} ${S.of(context).years}',
                    ].join(' • '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                
                if (character.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: character.tags.take(3).map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: textColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: textColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: textColor.withOpacity(0.9),
                        ),
                      ),
                    )).toList(),
                  ),
                ],
                
                const Spacer(),
                
                Row(
                  children: [
                    if (character.imageBytes != null)
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: textColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.memory(
                            character.imageBytes!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: textColor.withOpacity(0.6),
                      ),
                    
                    Text(
                      character.race!.name,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        size: 16,
                        color: textColor.withOpacity(0.6),
                      ),
                      onPressed: () {
                        // TODO: Показать контекстное меню
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRaceKeepCard(Race race, int index) {
    final theme = Theme.of(context);
    final cardColor = _getRaceCardColor(race);
    final textColor = ThemeData.estimateBrightnessForColor(cardColor) == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Container(
      margin: const EdgeInsets.all(8),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 1,
        color: cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (race.logo != null)
                  Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: textColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.memory(
                          race.logo!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                
                  Text(
                    race.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                
                  const SizedBox(height: 8),
                
                  if (race.description.isNotEmpty)
                    Text(
                      race.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textColor.withOpacity(0.8),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                
                  if (race.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: race.tags.take(3).map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: textColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: textColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          tag,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: textColor.withOpacity(0.9),
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                
                  const Spacer(),
                
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 16,
                        color: textColor.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_getCharacterCountForRace(race)} ${S.of(context).characters}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getCharacterCountForRace(Race race) {
    return _characters.where((character) => character.race?.id == race.id).length;
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Перейдите к созданию персонажа/ расы на основе выбранного типа контента
        },
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CharacterBook',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.home_subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(72),
              child: Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpressiveSearchBar(
                  onChanged: _filterContent,
                  hintText: s.search_home,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ExpressiveCategoryChip(
                      label: s.characters,
                      count: _characters.length,
                      isSelected: _selectedContentType == HomeContentType.characters,
                      onTap: () => _changeContentType(HomeContentType.characters),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ExpressiveCategoryChip(
                      label: s.races,
                      count: _races.length,
                      isSelected: _selectedContentType == HomeContentType.races,
                      onTap: () => _changeContentType(HomeContentType.races),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_selectedContentType == HomeContentType.characters)
            _buildCharactersKeepGrid()
          else
            _buildRacesKeepGrid(),

          if ((_selectedContentType == HomeContentType.characters && _filteredCharacters.isEmpty) ||
              (_selectedContentType == HomeContentType.races && _filteredRaces.isEmpty))
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _selectedContentType == HomeContentType.characters
                          ? Icons.person_outline
                          : Icons.people_outline,
                      size: 64,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _searchQuery.isEmpty
                          ? s.no_content_home
                          : s.nothing_found,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
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
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCharactersKeepGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final character = _filteredCharacters[index];
            return _buildCharacterKeepCard(character, index);
          },
          childCount: _filteredCharacters.length,
        ),
      ),
    );
  }

  Widget _buildRacesKeepGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final race = _filteredRaces[index];
            return _buildRaceKeepCard(race, index);
          },
          childCount: _filteredRaces.length,
        ),
      ),
    );
  }
}

enum HomeContentType {
  characters,
  races,
}