import 'package:characterbook/enums/character_sort_enum.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:characterbook/repositories/character_repository.dart';
import 'package:characterbook/services/character_service.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:characterbook/ui/modals/character_modal_card.dart';
import 'package:characterbook/ui/controllers/character_list_controller.dart';
import 'package:characterbook/ui/screens/character_management_screen.dart';
import 'package:characterbook/ui/screens/folder_screen.dart';
import 'package:characterbook/ui/screens/templates_list_screen.dart';
import 'package:characterbook/ui/widgets/appbar/common_main_app_bar.dart';
import 'package:characterbook/ui/widgets/buttons/common_list_floating_buttons.dart';
import 'package:characterbook/ui/widgets/list/list_state_indicator.dart';
import 'package:characterbook/ui/widgets/list/optimized_list_view.dart';
import 'package:characterbook/ui/widgets/items/character_card_item.dart';
import 'package:characterbook/ui/widgets/tags/tag_filter.dart';
import 'package:characterbook/ui/widgets/tools_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isImporting = false;
  String? _errorMessage;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<String> _getTags(
      BuildContext context, CharacterListController controller) {
    final s = S.of(context);
    return [
      s.a_to_z,
      s.z_to_a,
      s.age_asc,
      s.age_desc,
      ...controller.allTags,
    ];
  }

  void _onTagSelected(String? tag, BuildContext context, CharacterListController controller) {
    if (tag == null) {
      controller.setSelectedTag(null);
      return;
    }

    final s = S.of(context);
    if (tag == s.a_to_z) {
      controller.setSort(CharacterSort.nameAsc);
    } else if (tag == s.z_to_a) {
      controller.setSort(CharacterSort.nameDesc);
    } else if (tag == s.age_asc) {
      controller.setSort(CharacterSort.ageAsc);
    } else if (tag == s.age_desc) {
      controller.setSort(CharacterSort.ageDesc);
    } else {
      if (controller.selectedTag == tag) {
        controller.setSelectedTag(null);
      } else {
        controller.setSelectedTag(tag);
      }
    }
  }

  Future<void> _importCharacter(
      BuildContext context, CharacterService service) async {
    setState(() {
      _isImporting = true;
      _errorMessage = null;
    });
    try {
      final filePicker = FilePickerService();
      final character = await filePicker.importCharacter();
      if (character == null) return;

      await service.saveCharacter(character);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(S.of(context).character_imported(character.name))),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _deleteCharacter(
      Character character, CharacterListController controller) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).character_delete_title),
        content: Text(S.of(context).character_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(S.of(context).delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.deleteCharacter(character);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).character_deleted)),
        );
      }
    }
  }

  void _showCharacterContextMenu(Character character, BuildContext context,
      CharacterListController controller, CharacterService service) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ContextMenu.character(
        character: character,
        onEdit: () => _navigateToEdit(context, character),
        onDelete: () => _deleteCharacter(character, controller),
        onDuplicate: () => service.duplicateCharacter(character),
      ),
    );
  }

  void _navigateToDetail(Character character) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CharacterModalCard(character: character),
    );
  }

  void _navigateToEdit(BuildContext context, [Character? character]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterManagementScreen(character: character),
      ),
    );
  }

  Future<void> _createFromTemplate(BuildContext context) async {
    final template = await Navigator.push<QuestionnaireTemplate>(
      context,
      MaterialPageRoute(builder: (_) => const TemplatesListScreen()),
    );
    if (template != null && mounted) {
      _navigateToEdit(context, template.applyToCharacter(Character.empty()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharacterListController(
        context.read<CharacterRepository>(),
      ),
      child: Consumer<CharacterListController>(
        builder: (context, controller, child) {
          final service = context.read<CharacterService>();
          final s = S.of(context);
          return Scaffold(
          appBar: CommonMainAppBar(
            title: s.my_characters,
            isSearching: _isSearching,
            searchController: _searchController,
            searchHint: s.search_characters,
            onSearchToggle: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  controller.setSearchQuery('');
                }
              });
            },
            onSearchChanged: (query) => controller.setSearchQuery(query),
            onTemplatesPressed: () => _createFromTemplate(context),
            onFoldersPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FoldersScreen(folderType: FolderType.character),
              ),
            ),
          ),
          body: Column(
            children: [
              ListStateIndicator(
                isLoading: _isImporting || controller.isLoading,
                errorMessage: _errorMessage ?? controller.error,
                onErrorClose: () {
                  setState(() {
                    _errorMessage = null;
                  });
                },
              ),
              Expanded(
                child: Column(
                  children: [
                    if (controller.allTags.isNotEmpty ||
                        _getTags(context, controller).length > 4)
                      TagFilter(
                        tags: _getTags(context, controller),
                        selectedTag:
                            controller.selectedTag,
                        onTagSelected: (tag) =>_onTagSelected(tag, context, controller),
                        context: context,
                      ),
                    Expanded(
                      child: controller.filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            S.of(context).no_characters,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : OptimizedListView<Character>(
                        items: controller.filteredItems,
                        itemBuilder: (ctx, character, index) => CharacterCardItem(
                          key: ValueKey(character.key),
                          character: character,
                          isSelected: false,
                          onTap: () => _navigateToDetail(character),
                          onLongPress: () => _showCharacterContextMenu(
                              character, context, controller, service),
                            onEdit: () => _navigateToEdit(context, character),
                            onDelete: () => _deleteCharacter(character, controller),
                          
                        ),
                        onReorder: (oldIndex, newIndex) =>
                            controller.reorder(oldIndex, newIndex),
                        scrollController: _scrollController,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: CommonListFloatingButtons(
            onImport: () => _importCharacter(context, service),
            onAdd: () => _navigateToEdit(context),
            onTemplate: () => _createFromTemplate(context),
            heroTag: "character_list",
          ),
        );
      }
      )
    );
  }
}
