import 'dart:async';
import 'package:characterbook/ui/widgets/list_views/character_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  String? _selectedTag;
  String? _errorMessage;

  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _searchController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.atEdge) {
      final isTop = _scrollController.position.pixels == 0;
      if (isTop) {
        setState(() => _isFabVisible = true);
      }
      return;
    }

    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse && _isFabVisible) {
      setState(() => _isFabVisible = false);
    } else if (direction == ScrollDirection.forward && !_isFabVisible) {
      setState(() => _isFabVisible = true);
    }
  }

  List<String> _generateTags(List<Character> characters) {
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
    final queryLower = query.toLowerCase();
    
    setState(() {
      _filteredCharacters = allCharacters.where((character) {
        final matchesSearch = query.isEmpty ||
            character.name.toLowerCase().contains(queryLower) ||
            character.age.toString().contains(query);

        if (_selectedTag == null) return matchesSearch;

        return matchesSearch && switch (_selectedTag) {
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
    });
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
      )
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
      final characters = Hive.box<Character>('characters').values.cast<Character>();
      _filterCharacters(_searchController.text, characters.toList());
    }
  }

  Future<void> _reorderCharacters(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    final box = Hive.box<Character>('characters');
    final characters = box.values.toList().cast<Character>();

    if (oldIndex < 0 || oldIndex >= characters.length || 
        newIndex < 0 || newIndex >= characters.length) {
      debugPrint('⚠️ Некорректные индексы: old=$oldIndex, new=$newIndex');
      return;
    }

    final updatedList = List<Character>.from(characters);
    final item = updatedList.removeAt(oldIndex);
    updatedList.insert(newIndex, item);

    await box.clear();
    await box.addAll(updatedList);

    if (mounted) {
      setState(() {
        _filterCharacters(_searchController.text, updatedList);
      });
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
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(S.of(context).delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await Hive.box<Character>('characters').delete(character.key);
      if (mounted) _showSnackBar(S.of(context).character_deleted);
    }
  }

  void _showCharacterContextMenu(Character character) {
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

  void _navigateToDetail(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterDetailPage(character: character),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          final allCharacters = Hive.box<Character>('characters').values.cast<Character>();
          _filterCharacters(query, allCharacters.toList());
        },
        onTemplatesPressed: _createFromTemplate,
        /*additionalActions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
            tooltip: _isGridView 
                ? S.of(context).list_view 
                : S.of(context).grid_view,
          ),
        ],*/
      ),
      body: Column(
        children: [
          if (_isImporting) const LinearProgressIndicator(),
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.errorContainer,
              child: Row(
                children: [
                  Icon(Icons.error, color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, 
                      color: Theme.of(context).colorScheme.onErrorContainer),
                    onPressed: () => setState(() => _errorMessage = null),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ValueListenableBuilder<Box<Character>>(
              valueListenable: Hive.box<Character>('characters').listenable(),
              builder: (context, box, _) {
                final allCharacters = box.values.toList();
                final tags = _generateTags(allCharacters);
                final charactersToShow = _isSearching || _selectedTag != null
                    ? _filteredCharacters
                    : allCharacters;

                return CharacterListView(
                  allCharacters: allCharacters,
                  onImportCharacter: _importCharacter,
                  onCreateCharacter: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CharacterEditPage()),
                  ),
                  charactersToShow: charactersToShow,
                  tags: tags,
                  searchController: _searchController,
                  isSearching: _isSearching,
                  selectedTag: _selectedTag,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) newIndex -= 1;
                    _reorderCharacters(oldIndex, newIndex);
                  },
                  scrollController: _scrollController,
                  onCharacterTap: (character) => _navigateToDetail(character),
                  onCharacterLongPress: (character) => _showCharacterContextMenu(character),
                  onTagSelected: (tag) {
                    setState(() => _selectedTag = tag);
                    _filterCharacters(_searchController.text, allCharacters);
                  },
                  onScroll: (direction) {
                    if (direction == ScrollDirection.reverse && _isFabVisible) {
                      setState(() => _isFabVisible = false);
                    } else if (direction == ScrollDirection.forward && !_isFabVisible) {
                      setState(() => _isFabVisible = true);
                    }
                  },
                );
              }
            ),
          ),
        ],
      ),
      floatingActionButton: _isFabVisible 
      ? CustomFloatingButtons(
          onImport: _importCharacter,
          onAdd: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CharacterEditPage()),
          ),
          onTemplate: _createFromTemplate,
        ) : null,
    );
  }
}