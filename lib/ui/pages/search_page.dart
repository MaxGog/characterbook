import 'dart:async';
import 'package:characterbook/ui/pages/folder_list_page.dart';
import 'package:characterbook/ui/widgets/debouncer.dart';
import 'package:characterbook/ui/widgets/cards/search_result_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:characterbook/models/characters/character_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/characters/template_model.dart';
import 'package:characterbook/models/folder_model.dart';

import '../../generated/l10n.dart';
import 'characters/character_management_page.dart';
import 'notes/note_management_page.dart';
import 'races/race_management_page.dart';
import 'templates/template_edit_page.dart';
import 'settings_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Character> _characters = [];
  List<Race> _races = [];
  List<Note> _notes = [];
  List<QuestionnaireTemplate> _templates = [];
  List<Folder> _folders = [];
  List<dynamic> _filteredResults = [];
  bool _isLoading = true;
  late final FocusNode _searchFocusNode;
  bool _isSearching = false;
  final Debouncer _searchDebouncer = Debouncer(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchController.addListener(_onSearchChanged);
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final characterBox = await Hive.openBox<Character>('characters');
      final raceBox = await Hive.openBox<Race>('races');
      final noteBox = await Hive.openBox<Note>('notes');
      final templateBox = await Hive.openBox<QuestionnaireTemplate>('templates');
      final folderBox = await Hive.openBox<Folder>('folders');

      if (mounted) {
        setState(() {
          _characters = characterBox.values.cast<Character>().toList();
          _races = raceBox.values.cast<Race>().toList();
          _notes = noteBox.values.cast<Note>().toList();
          _templates = templateBox.values.cast<QuestionnaireTemplate>().toList();
          _folders = folderBox.values.cast<Folder>().toList();
          _filteredResults = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredResults = [];
      });
      return;
    }

    setState(() => _isSearching = true);
    _searchDebouncer.run(() {
      if (!mounted) return;
      
      final query = _searchController.text.trim().toLowerCase();
      if (query.isEmpty) {
        setState(() {
          _isSearching = false;
          _filteredResults = [];
        });
        return;
      }

      final filteredResults = [
        ..._filterCharacters(query),
        ..._filterRaces(query),
        ..._filterNotes(query),
        ..._filterTemplates(query),
        ..._filterFolders(query),
      ];

      if (mounted) {
        setState(() {
          _filteredResults = filteredResults;
          _isSearching = false;
        });
      }
    });
  }

  List<Character> _filterCharacters(String query) {
    return _characters.where((character) {
      return character.name.toLowerCase().contains(query) ||
          (character.biography.toLowerCase().contains(query)) ||
          (character.personality.toLowerCase().contains(query)) ||
          (character.appearance.toLowerCase().contains(query)) ||
          (character.abilities.toLowerCase().contains(query)) ||
          (character.other.toLowerCase().contains(query)) ||
          (character.race?.name.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  List<Race> _filterRaces(String query) {
    return _races.where((race) {
      return race.name.toLowerCase().contains(query) ||
          (race.description.toLowerCase().contains(query)) ||
          (race.biology.toLowerCase().contains(query)) ||
          (race.backstory.toLowerCase().contains(query));
    }).toList();
  }

  List<Note> _filterNotes(String query) {
    return _notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query) ||
          note.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  List<QuestionnaireTemplate> _filterTemplates(String query) {
    return _templates.where((template) {
      return template.name.toLowerCase().contains(query) ||
          template.standardFields.any((field) => field.toLowerCase().contains(query)) ||
          template.customFields.any((field) =>
              field.key.toLowerCase().contains(query) ||
              field.value.toLowerCase().contains(query));
    }).toList();
  }

  List<Folder> _filterFolders(String query) {
    return _folders.where((folder) {
      return folder.name.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await _loadInitialData();
  }

    @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          focusNode: _searchFocusNode,
          controller: _searchController,
          hintText: s.search_hint,
          leading: const Icon(Icons.search_rounded),
          trailing: [
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                },
              ),
          ],
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
          backgroundColor: WidgetStatePropertyAll(
            colorScheme.surfaceContainerHigh,
          ),
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
          overlayColor: WidgetStatePropertyAll(colorScheme.surfaceContainer),
          onTap: () => _searchFocusNode.requestFocus(),
        ),
        centerTitle: false,
        titleSpacing: 24,
        toolbarHeight: 80,
        scrolledUnderElevation: 3,
        shadowColor: colorScheme.shadow,
        surfaceTintColor: Colors.transparent,
        backgroundColor: colorScheme.surfaceContainerLowest,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filledTonal(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ),
              icon: const Icon(Icons.settings_outlined),
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (_isSearching)
            const SliverToBoxAdapter(
              child: LinearProgressIndicator(),
            ),
          if (!_isSearching && _filteredResults.isEmpty && _searchController.text.isNotEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).nothing_found,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '"${_searchController.text}"',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (!_isSearching && _filteredResults.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 48,
                      color: colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).search_hint,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              sliver: SliverList.builder(
                itemCount: _filteredResults.length,
                itemBuilder: (context, index) {
                  final item = _filteredResults[index];
                  return SearchResultItem(
                    item: item,
                    onTap: () async {
                      final result = await _navigateToEditPage(item);
                      if (result == true) await _refreshData();
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<bool?> _navigateToEditPage(dynamic item) async {
    if (item is Character) {
      return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterEditPage(character: item),
        ),
      );
    } else if (item is Race) {
      return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RaceManagementPage(race: item),
        ),
      );
    } else if (item is Note) {
      return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoteEditPage(note: item),
        ),
      );
    } else if (item is QuestionnaireTemplate) {
      return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TemplateEditPage(template: item),
        ),
      );
    } else if (item is Folder) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoldersScreen(folderType: item.type),
        ),
      );
      return null;
    }
    return null;
  }
}