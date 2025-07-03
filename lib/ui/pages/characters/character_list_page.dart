import 'dart:async';
import 'package:characterbook/ui/widgets/character_grid_tile.dart';
import 'package:characterbook/ui/widgets/character_list_card.dart';
import 'package:characterbook/ui/widgets/tag_filter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../generated/l10n.dart';
import '../../../models/character_model.dart';
import '../../../models/template_model.dart';
import '../../../services/file_picker_service.dart';
import '../../widgets/context_menu.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_floating_buttons.dart';
import '../templates/templates_page.dart';
import 'character_detail_page.dart';
import 'character_management_page.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  final TextEditingController _searchController = TextEditingController();
  final FilePickerService _filePickerService = FilePickerService();
  
  List<Character> _filteredCharacters = [];
  bool _isSearching = false;
  bool _isImporting = false;
  bool _isGridView = false;
  String? _selectedTag;
  String? _errorMessage;
  Character? _selectedCharacter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _generateTags(BuildContext context, List<Character> characters) {
    final s = S.of(context);
    return [
      s.male, s.female, s.another,
      s.children, s.young, s.adults, s.elderly,
      s.short_name,
      s.a_to_z, s.z_to_a, s.age_asc, s.age_desc
    ];
  }

  void _filterCharacters(String query, List<Character> allCharacters) {
    final s = S.of(context);
    
    setState(() {
      _filteredCharacters = allCharacters.where((character) {
        final matchesSearch = query.isEmpty ||
            character.name.toLowerCase().contains(query.toLowerCase()) ||
            character.age.toString().contains(query);

        bool matchesTag = true;
        if (_selectedTag != null) {
          matchesTag = switch (_selectedTag) {
            _ when _selectedTag == s.male => character.gender == 'male',
            _ when _selectedTag == s.female => character.gender == 'female',
            _ when _selectedTag == s.another => character.gender == 'another',
            _ when _selectedTag == s.short_name => character.name.length <= 4,
            _ when _selectedTag == s.children => character.age < 18,
            _ when _selectedTag == s.young => character.age < 30,
            _ when _selectedTag == s.adults => character.age < 50,
            _ when _selectedTag == s.elderly => character.age >= 50,
            _ => true,
          };
        }

        return matchesSearch && matchesTag;
      }).toList();

      if (_selectedTag == s.a_to_z) {
        _filteredCharacters.sort((a, b) => a.name.compareTo(b.name));
      } else if (_selectedTag == s.z_to_a) {
        _filteredCharacters.sort((a, b) => b.name.compareTo(a.name));
      } else if (_selectedTag == s.age_asc) {
        _filteredCharacters.sort((a, b) => a.age.compareTo(b.age));
      } else if (_selectedTag == s.age_desc) {
        _filteredCharacters.sort((a, b) => b.age.compareTo(a.age));
      }

      if (_selectedCharacter != null && 
          !_filteredCharacters.contains(_selectedCharacter)) {
        _selectedCharacter = null;
      }
    });
  }

  String _getLocalizedGender(BuildContext context, String genderKey) {
    final s = S.of(context);
    return switch (genderKey) {
      'male' => s.male,
      'female' => s.female,
      'another' => s.another,
      _ => genderKey,
    };
  }

  Future<void> _importCharacter() async {
    try {
      setState(() {
        _isImporting = true;
        _errorMessage = null;
      });

      final character = await _filePickerService.importCharacter();
      if (character == null) return;

      final box = Hive.box<Character>('characters');
      await box.add(character);

      if (mounted) {
        _showSnackBar(S.of(context).character_imported(character.name));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _editCharacter(Character character) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterEditPage(character: character),
      ),
    );
    
    if (result == true && mounted) {
      final characters = Hive.box<Character>('characters')
        .values.toList().cast<Character>();
      _filterCharacters(_searchController.text, characters);
    }
  }

  Future<void> _reorderCharacters(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    final box = Hive.box<Character>('characters');
    final characters = box.values.toList().cast<Character>();

    if (oldIndex < newIndex) newIndex -= 1;

    final character = characters.removeAt(oldIndex);
    characters.insert(newIndex, character);

    await box.clear();
    await box.addAll(characters);

    if (mounted) {
      _filterCharacters(_searchController.text, characters);
    }
  }

  Future<void> _createFromTemplate() async {
    final template = await Navigator.push<QuestionnaireTemplate>(
      context,
      MaterialPageRoute(builder: (context) => const TemplatesPage()),
    );

    if (template != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterEditPage(
            character: template.applyToCharacter(Character.empty()),
          ),
        ),
      );
    }
  }

  Future<void> _deleteCharacter(Character character) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).character_delete_title),
        content: Text(S.of(context).character_delete_confirm),
        actions: [
          TextButton(
            child: Text(S.of(context).cancel),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(S.of(context).delete),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await Hive.box<Character>('characters').delete(character.key);
      if (mounted) _showSnackBar(S.of(context).character_deleted);
    }
  }

  void _showCharacterContextMenu(Character character, BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu.character(
        character: character,
        onEdit: () => _editCharacter(character),
        onDelete: () => _deleteCharacter(character),
      ),
    );
  }

  Widget _buildCharacterCard(Character character, ThemeData theme) {
    final isSelected = _selectedCharacter?.key == character.key;

    return CharacterListCard(
      character: character,
      isSelected: isSelected,
      onTap: () => _handleCharacterTap(character),
      onLongPress: () => _showCharacterContextMenu(character, context),
      onMenuPressed: () => _showCharacterContextMenu(character, context),
    );
  }

  Widget _buildCharacterTile(Character character, ThemeData theme) {
    return CharacterGridTile(
      character: character,
      onTap: () => _handleCharacterTap(character),
      onLongPress: () => _showCharacterContextMenu(character, context),
    );
  }

  void _handleCharacterTap(Character character) {
    if (MediaQuery.of(context).size.width > 1000) {
      setState(() => _selectedCharacter = character);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterDetailPage(character: character),
        ),
      );
    }
  }

  Widget _buildTagFilter(List<String> tags, ThemeData theme, List<Character> allCharacters) {
    return TagFilter(
      tags: tags,
      selectedTag: _selectedTag,
      onTagSelected: (tag) {
        setState(() => _selectedTag = tag);
        _filterCharacters(_searchController.text, allCharacters);
      },
      allCharacters: allCharacters,
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 48,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          Text(
            _isSearching && _searchController.text.isNotEmpty
                ? S.of(context).nothing_found
                : S.of(context).no_characters,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (!_isSearching)
            TextButton(
              onPressed: _importCharacter,
              child: Text(S.of(context).import_character),
            ),
        ],
      ),
    );
  }

  Widget _buildCharactersList(List<Character> characters, ThemeData theme) {
    if (characters.isEmpty) return _buildEmptyState(theme);

    return ReorderableListView.builder(
      key: const ValueKey('characters_reorderable_list'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return KeyedSubtree(
          key: ValueKey('character_item_${character.key}'),
          child: _buildCharacterCard(character, theme),
        );
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) newIndex -= 1;
        final character = characters.removeAt(oldIndex);
        characters.insert(newIndex, character);
        _reorderCharacters(oldIndex, newIndex);
      },
      buildDefaultDragHandles: false,
      proxyDecorator: (child, _, animation) => Material(
        elevation: 6,
        color: Colors.transparent,
        child: child,
      ),
    );
  }

  Widget _buildCharactersGrid(List<Character> characters, ThemeData theme) {
    if (characters.isEmpty) return _buildEmptyState(theme);

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) => _buildCharacterTile(characters[index], theme),
    );
  }

  Widget _buildWideLayout(List<Character> characters, List<String> tags, ThemeData theme, List<Character> allCharacters) {
    return Row(
      children: [
        Container(
          width: 400,
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: theme.dividerColor))),
          child: Column(
            children: [
              if (tags.isNotEmpty) _buildTagFilter(tags, theme, allCharacters),
              Expanded(
                child: _isGridView 
                    ? _buildCharactersGrid(characters, theme) 
                    : _buildCharactersList(characters, theme),
              ),
            ],
          ),
        ),
        Expanded(
          child: _selectedCharacter != null
              ? CharacterDetailPage(character: _selectedCharacter!)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).select_character,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(List<Character> characters, List<String> tags, ThemeData theme, List<Character> allCharacters) {
    return Column(
      children: [
        if (tags.isNotEmpty) _buildTagFilter(tags, theme, allCharacters),
        Expanded(
          child: _isGridView 
              ? _buildCharactersGrid(characters, theme) 
              : _buildCharactersList(characters, theme)
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWideScreen = MediaQuery.of(context).size.width > 1000;

    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).my_characters,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: S.of(context).search_characters,
        onSearchToggle: () => setState(() {
          _isSearching = !_isSearching;
          if (!_isSearching) {
            _searchController.clear();
            _selectedTag = null;
            _filteredCharacters = [];
          }
        }),
        onSearchChanged: (query) {
          final allCharacters = Hive.box<Character>('characters')
            .values.toList().cast<Character>();
          _filterCharacters(query, allCharacters);
        },
        onTemplatesPressed: _createFromTemplate,
        additionalActions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
            tooltip: _isGridView 
                ? S.of(context).list_view 
                : S.of(context).grid_view,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isImporting) const LinearProgressIndicator(),
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.colorScheme.errorContainer,
              child: Row(
                children: [
                  Icon(Icons.error, color: theme.colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, 
                      color: theme.colorScheme.onErrorContainer),
                    onPressed: () => setState(() => _errorMessage = null),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ValueListenableBuilder<Box<Character>>(
              valueListenable: Hive.box<Character>('characters').listenable(),
              builder: (context, box, _) {
                final allCharacters = box.values.toList().cast<Character>();
                final tags = _generateTags(context, allCharacters);
                final characters = _isSearching || _selectedTag != null
                    ? _filteredCharacters
                    : allCharacters;

                return isWideScreen
                    ? _buildWideLayout(characters, tags, theme, allCharacters)
                    : _buildMobileLayout(characters, tags, theme, allCharacters);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingButtons(
        onImport: _importCharacter,
        onAdd: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CharacterEditPage()),
        ),
        onTemplate: _createFromTemplate,
      ),
    );
  }
}