import 'dart:async';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/ui/pages/folders/folder_list_page.dart';
import 'package:characterbook/ui/widgets/mixins/list_page_mixin.dart';
import 'package:characterbook/ui/widgets/list_views/character_list_view.dart';
import 'package:characterbook/ui/widgets/mixins/tag_mixin.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../generated/l10n.dart';
import '../../../models/character_model.dart';
import '../../../models/template_model.dart';
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

class _CharacterListPageState extends State<CharacterListPage> with ListPageMixin, TagMixin<Character> {
  List<Character> filteredCharacters = [];
  String? selectedTag;

  @override
  List<String> generateTags(List<Character> characters) {
    return generateAllTags(characters, context, (c) => c.tags);
  }

  bool _isShortName(Character c) => c.name.length <= 4;

  void filterCharacters(String query, List<Character> allCharacters) {
    final queryLower = query.toLowerCase();
    
    setState(() {
      filteredCharacters = allCharacters.where((character) {
        final matchesSearch = query.isEmpty ||
            character.name.toLowerCase().contains(queryLower) ||
            character.age.toString().contains(query) ||
            character.tags.any((tag) => tag.toLowerCase().contains(queryLower));

        return matchesSearch && matchesTagFilter(
          selectedTag, context, character, (c) => c.tags, _isShortName);
      }).toList();

      final s = S.of(context);
      if (selectedTag == s.a_to_z) {
        filteredCharacters.sort((a, b) => a.name.compareTo(b.name));
      } else if (selectedTag == s.z_to_a) {
        filteredCharacters.sort((a, b) => b.name.compareTo(a.name));
      } else if (selectedTag == s.age_asc) {
        filteredCharacters.sort((a, b) => a.age.compareTo(b.age));
      } else if (selectedTag == s.age_desc) {
        filteredCharacters.sort((a, b) => b.age.compareTo(a.age));
      }
    });
  }

  Future<void> importCharacter() async {
    try {
      setState(() {
        isImporting = true;
        errorMessage = null;
      });

      final character = await filePickerService.importCharacter();
      if (character == null) return;

      final box = Hive.box<Character>('characters');
      await box.add(character);

      if (mounted) {
        showSnackBar(S.of(context).character_imported(character.name));
      }
    } catch (e) {
      if (mounted) {
        setState(() => errorMessage = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => isImporting = false);
      }
    }
  }

  Future<void> editCharacter(Character character) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterEditPage(character: character),
      ),
    );
    
    if (result == true && mounted) {
      final characters = Hive.box<Character>('characters').values.cast<Character>();
      filterCharacters(searchController.text, characters.toList());
    }
  }

  Future<void> reorderCharacters(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    final box = Hive.box<Character>('characters');
    final characters = box.values.toList().cast<Character>();

    if (oldIndex < 0 || oldIndex >= characters.length || 
        newIndex < 0 || newIndex >= characters.length) {
      debugPrint('⚠️ Invalid indices: old=$oldIndex, new=$newIndex');
      return;
    }

    final updatedList = List<Character>.from(characters);
    final item = updatedList.removeAt(oldIndex);
    updatedList.insert(newIndex, item);

    await box.clear();
    await box.addAll(updatedList);

    if (mounted) {
      setState(() {
        filterCharacters(searchController.text, updatedList);
      });
    }
  }

  Future<void> createFromTemplate() async {
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

  Future<void> deleteCharacter(Character character) async {
    final confirmed = await showDeleteConfirmationDialog(
      S.of(context).character_delete_title,
      S.of(context).character_delete_confirm,
    );

    if (confirmed) {
      await Hive.box<Character>('characters').delete(character.key);
      if (mounted) showSnackBar(S.of(context).character_deleted);
    }
  }

  void showCharacterContextMenu(Character character) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu.character(
        character: character,
        onEdit: () => editCharacter(character),
        onDelete: () => deleteCharacter(character),
      ),
    );
  }

  void navigateToDetail(Character character) {
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
        isSearching: isSearching,
        searchController: searchController,
        searchHint: S.of(context).search_characters,
        onSearchToggle: () => setState(() {
          isSearching = !isSearching;
          if (!isSearching) {
            searchController.clear();
            selectedTag = null;
            filteredCharacters = [];
          }
        }),
        onSearchChanged: (query) {
          final allCharacters = Hive.box<Character>('characters').values.cast<Character>();
          filterCharacters(query, allCharacters.toList());
        },
        onTemplatesPressed: createFromTemplate,
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.folder_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FoldersScreen(folderType: FolderType.character),
              ),
            ),
            tooltip: S.of(context).folders,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isImporting) const LinearProgressIndicator(),
          if (errorMessage != null)
            _buildErrorWidget(errorMessage!),
          Expanded(
            child: ValueListenableBuilder<Box<Character>>(
              valueListenable: Hive.box<Character>('characters').listenable(),
              builder: (context, box, _) {
                final allCharacters = box.values.toList();
                final tags = generateTags(allCharacters);
                final charactersToShow = isSearching || selectedTag != null
                    ? filteredCharacters
                    : allCharacters;

                return CharacterListView(
                  allCharacters: allCharacters,
                  onImportCharacter: importCharacter,
                  onCreateCharacter: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CharacterEditPage()),
                  ),
                  charactersToShow: charactersToShow,
                  tags: tags,
                  searchController: searchController,
                  isSearching: isSearching,
                  selectedTag: selectedTag,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) newIndex -= 1;
                    reorderCharacters(oldIndex, newIndex);
                  },
                  scrollController: scrollController,
                  onCharacterTap: navigateToDetail,
                  onCharacterLongPress: showCharacterContextMenu,
                  onTagSelected: (tag) {
                    setState(() => selectedTag = tag);
                    filterCharacters(searchController.text, allCharacters);
                  },
                  onScroll: (ScrollDirection ) {  },
                );
              }
            ),
          ),
        ],
      ),
      floatingActionButton: isFabVisible 
        ? CustomFloatingButtons(
            onImport: importCharacter,
            onAdd: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CharacterEditPage()),
            ),
            onTemplate: createFromTemplate,
          ) 
        : null,
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(Icons.error, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, 
              color: Theme.of(context).colorScheme.onErrorContainer),
            onPressed: () => setState(() => errorMessage = null),
          ),
        ],
      ),
    );
  }
}