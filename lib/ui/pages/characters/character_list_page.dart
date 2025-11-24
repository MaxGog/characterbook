import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:characterbook/ui/cards/character_modal_card.dart';
import 'package:characterbook/ui/pages/folder_list_page.dart';
import 'package:characterbook/ui/widgets/list/base_list_page.dart';
import 'package:characterbook/ui/widgets/list/optimized_list_view.dart';
import 'package:characterbook/ui/widgets/list/list_state_indicator.dart';
import 'package:characterbook/ui/widgets/cards/character_card.dart';
import 'package:characterbook/ui/widgets/tools_context_menu.dart';
import 'package:characterbook/ui/widgets/appbar/custom_app_bar.dart';
import 'package:characterbook/ui/widgets/buttons/custom_floating_buttons.dart';
import 'package:characterbook/ui/widgets/tags/tag_filter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../generated/l10n.dart';
import '../../../models/characters/character_model.dart';
import '../../../models/characters/template_model.dart';
import '../templates/templates_page.dart';
import 'character_management_page.dart';

class CharacterListPage extends BaseListPage<Character> {
  const CharacterListPage({super.key})
      : super(
          boxName: 'characters',
          titleKey: 'my_characters',
        );

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends BaseListPageState<Character, CharacterListPage> {
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

  void showCharacterContextMenu(Character character) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu.character(
        character: character,
        onEdit: () => navigateToEdit(character),
        onDelete: () => deleteItem(character),
      ),
    );
  }

  void navigateToDetail(Character character) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CharacterModalCard(character: character),
    );
  }

  @override
  List<String> getTags(List<Character> characters) {
    final allTags = characters.expand((c) => c.tags).toSet().toList();
    final s = S.of(context);
    
    return [
      s.a_to_z,
      s.z_to_a,
      s.age_asc,
      s.age_desc,
      ...allTags,
    ];
  }

  @override
  bool matchesSearch(Character character, String query) {
    final queryLower = query.toLowerCase();
    return character.name.toLowerCase().contains(queryLower) ||
        character.age.toString().contains(query) ||
        character.tags.any((tag) => tag.toLowerCase().contains(queryLower));
  }

  @override
  bool matchesTagFilter(Character character, String? tag) {
    if (tag == null) return true;
    
    final s = S.of(context);
    if (tag == s.a_to_z || tag == s.z_to_a || 
        tag == s.age_asc || tag == s.age_desc) {
      return true;
    }
    
    return character.tags.contains(tag);
  }

  @override
  Widget buildItemCard(Character character, int index) {
    return CharacterCard(
      key: ValueKey(character.key),
      character: character,
      isSelected: false,
      onTap: () => navigateToDetail(character),
      onLongPress: () => showCharacterContextMenu(character),
      onMenuPressed: () => showCharacterContextMenu(character),
    );
  }

  @override
  Future<void> importItem() async {
    try {
      setState(() {
        isImporting = true;
        errorMessage = null;
      });
      FilePickerService filePickerService = FilePickerService();
      final character = await filePickerService.importCharacter();
      if (character == null) return;

      final box = Hive.box<Character>(widget.boxName);
      await box.add(character);

      if (mounted) showSnackBar(S.of(context).character_imported(character.name));
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => isImporting = false);
    }
  }

  @override
  Future<void> deleteItem(Character character) async {
    final confirmed = await showDeleteConfirmation(
      S.of(context).character_delete_title,
      S.of(context).character_delete_confirm,
    );

    if (confirmed) {
      await Hive.box<Character>(widget.boxName).delete(character.key);
      if (mounted) showSnackBar(S.of(context).character_deleted);
    }
  }

  @override
  Future<void> reorderItems(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    final box = Hive.box<Character>(widget.boxName);
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
      final allCharacters = Hive.box<Character>(widget.boxName).values.cast<Character>();
      filterCharacters(searchController.text, allCharacters.toList());
    }
  }

  @override
  void navigateToEdit(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterEditPage(character: character),
      ),
    ).then((result) {
      if (result == true && mounted) {
        final characters = Hive.box<Character>(widget.boxName).values.cast<Character>();
        filterCharacters(searchController.text, characters.toList());
      }
    });
  }

  @override
  void navigateToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CharacterEditPage()),
    );
  }

  void filterCharacters(String query, List<Character> allCharacters) {
    final queryLower = query.toLowerCase();
    
    setState(() {
      filteredItems = allCharacters.where((character) {
        final matchesSearch = query.isEmpty ||
            character.name.toLowerCase().contains(queryLower) ||
            character.age.toString().contains(query) ||
            character.tags.any((tag) => tag.toLowerCase().contains(queryLower));

        return matchesSearch && matchesTagFilter(character, selectedTag);
      }).toList();

      final s = S.of(context);
      if (selectedTag == s.a_to_z) {
        filteredItems.sort((a, b) => a.name.compareTo(b.name));
      } else if (selectedTag == s.z_to_a) {
        filteredItems.sort((a, b) => b.name.compareTo(a.name));
      } else if (selectedTag == s.age_asc) {
        filteredItems.sort((a, b) => a.age.compareTo(b.age));
      } else if (selectedTag == s.age_desc) {
        filteredItems.sort((a, b) => b.age.compareTo(a.age));
      }
    });
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
            filteredItems = [];
          }
        }),
        onSearchChanged: (query) {
          final allCharacters = Hive.box<Character>(widget.boxName).values.cast<Character>();
          filterCharacters(query, allCharacters.toList());
        },
        onTemplatesPressed: createFromTemplate,
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.folder_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoldersScreen(folderType: FolderType.character),
              ),
            ),
            tooltip: S.of(context).folders,
          ),
        ],
      ),
      body: Column(
        children: [
          ListStateIndicator(
            isLoading: isImporting,
            errorMessage: errorMessage,
            onErrorClose: () => setState(() => errorMessage = null),
          ),
          Expanded(
            child: ValueListenableBuilder<Box<Character>>(
              valueListenable: Hive.box<Character>(widget.boxName).listenable(),
              builder: (context, box, _) {
                final allCharacters = box.values.toList().cast<Character>();
                final tags = getTags(allCharacters);
                final charactersToShow = isSearching || selectedTag != null
                    ? filteredItems
                    : allCharacters;

                return Column(
                  children: [
                    if (tags.isNotEmpty)
                      TagFilter(
                        tags: tags,
                        selectedTag: selectedTag,
                        onTagSelected: (tag) {
                          setState(() => selectedTag = tag);
                          filterCharacters(searchController.text, allCharacters);
                        },
                        context: context,
                      ),
                    Expanded(
                      child: OptimizedListView<Character>(
                        items: charactersToShow,
                        itemBuilder: (context, character, index) => 
                            buildItemCard(character, index),
                        onReorder: reorderItems,
                        scrollController: scrollController,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isFabVisible 
          ? CustomFloatingButtons(
              onImport: importItem,
              onAdd: navigateToCreate,
              onTemplate: createFromTemplate,
            )
          : null,
    );
  }
}