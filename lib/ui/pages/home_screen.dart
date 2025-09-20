import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/services/character_service.dart';
import 'package:characterbook/services/race_service.dart';
import 'package:characterbook/ui/widgets/expressive_avatar.dart';
import 'package:characterbook/ui/widgets/search_bar.dart';
import 'package:characterbook/ui/widgets/category_chip.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.secondaryContainer,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CharacterBook',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onPrimaryContainer,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ваша коллекция персонажей и рас',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpressiveSearchBar(
                  onChanged: _filterContent,
                  hintText: 'Поиск персонажей и рас...',
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ExpressiveCategoryChip(
                      label: 'Персонажи',
                      count: _characters.length,
                      isSelected: _selectedContentType == HomeContentType.characters,
                      onTap: () => _changeContentType(HomeContentType.characters),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ExpressiveCategoryChip(
                      label: 'Расы',
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
            _buildCharactersGrid()
          else
            _buildRacesGrid(),

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
                          ? '${_selectedContentType == HomeContentType.characters ? 'Персонажей' : 'Рас'} пока нет'
                          : 'Ничего не найдено',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCharactersGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final character = _filteredCharacters[index];
            return _buildCharacterCard(character);
          },
          childCount: _filteredCharacters.length,
        ),
      ),
    );
  }

  Widget _buildRacesGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final race = _filteredRaces[index];
            return _buildRaceCard(race);
          },
          childCount: _filteredRaces.length,
        ),
      ),
    );
  }

  Widget _buildCharacterCard(Character character) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Навигация к деталям персонажа
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ExpressiveAvatar(
                  imageBytes: character.imageBytes,
                  size: 80,
                  shape: ExpressiveShape.values[Random().nextInt(ExpressiveShape.values.length)],
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                character.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),

              if (character.race != null) ...[
                const SizedBox(height: 4),
                Text(
                  character.race!.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
              
              if (character.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: character.tags.take(2).map((tag) => Chip(
                    label: Text(
                      tag,
                      style: theme.textTheme.labelSmall,
                    ),
                    backgroundColor: colorScheme.surfaceVariant,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  )).toList(),
                ),
              ],
              
              const Spacer(),
              
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Активен',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRaceCard(Race race) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Навигация к деталям расы
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ExpressiveAvatar(
                  imageBytes: race.logo,
                  size: 80,
                  shape: ExpressiveShape.values[Random().nextInt(ExpressiveShape.values.length)],
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                race.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              
              if (race.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  race.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              if (race.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: race.tags.take(2).map((tag) => Chip(
                    label: Text(
                      tag,
                      style: theme.textTheme.labelSmall,
                    ),
                    backgroundColor: colorScheme.surfaceVariant,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

enum HomeContentType {
  characters,
  races,
}