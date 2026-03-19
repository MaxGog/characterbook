import 'package:characterbook/enums/race_sort_enum.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/repositories/race_repository.dart';
import 'package:characterbook/services/race_service.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:characterbook/ui/controllers/race_list_controller.dart';
import 'package:characterbook/ui/screens/folder_screen.dart';
import 'package:characterbook/ui/screens/race_management_screen.dart';
import 'package:characterbook/ui/screens/settings/swipe_action_settings_screen.dart';
import 'package:characterbook/ui/widgets/tools_context_menu.dart';
import 'package:characterbook/ui/widgets/appbar/common_main_app_bar.dart';
import 'package:characterbook/ui/widgets/buttons/common_list_floating_buttons.dart';
import 'package:characterbook/ui/widgets/items/race_card_item.dart';
import 'package:characterbook/ui/modals/race_modal_card.dart';
import 'package:characterbook/ui/widgets/list/list_state_indicator.dart';
import 'package:characterbook/ui/widgets/list/optimized_list_view.dart';
import 'package:characterbook/ui/widgets/tags/tag_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class RaceListScreen extends StatefulWidget {
  const RaceListScreen({super.key});

  @override
  State<RaceListScreen> createState() => _RaceListScreenState();
}

class _RaceListScreenState extends State<RaceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isImporting = false;
  String? _errorMessage;
  bool _isFabVisible = true;
  final ScrollController _scrollController = ScrollController();

  final Box<Character> _charactersBox = Hive.box<Character>('characters');

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrollingDown = _scrollController.position.userScrollDirection ==
        ScrollDirection.reverse;
    if (isScrollingDown && _isFabVisible) {
      setState(() => _isFabVisible = false);
    } else if (!isScrollingDown && !_isFabVisible) {
      setState(() => _isFabVisible = true);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  List<String> _getTags(BuildContext context, RaceListController controller) {
    final s = S.of(context);
    return [
      s.a_to_z,
      s.z_to_a,
      ...controller.allTags,
    ];
  }

  void _onTagSelected(String? tag, BuildContext context, RaceListController controller) {
    if (tag == null) {
      controller.setSelectedTag(null);
      return;
    }

    final s = S.of(context);
    if (tag == s.a_to_z) {
      controller.setSort(RaceSort.nameAsc);
    } else if (tag == s.z_to_a) {
      controller.setSort(RaceSort.nameDesc);
    } else {
      if (controller.selectedTag == tag) {
        controller.setSelectedTag(null);
      } else {
        controller.setSelectedTag(tag);
      }
    }
  }

  Future<bool> _isRaceUsed(Race race) async {
    final characters = _charactersBox.values;
    return characters.any((character) => character.race?.key == race.key);
  }

  Future<void> _deleteRace(
      Race race, RaceListController controller, RaceService service) async {
    if (await _isRaceUsed(race)) {
      _showRaceInUseDialog();
      return;
    }
    final confirmed = await _showDeleteConfirmationDialog(
      S.of(context).race_delete_title,
      S.of(context).race_delete_confirm,
    );
    if (confirmed == true) {
      await controller.deleteRace(race.key);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).race_deleted)),
        );
      }
    }
  }

  void _showRaceInUseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).race_delete_error_title),
        content: Text(S.of(context).race_delete_error_content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).ok),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(
      String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
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
        ) ??
        false;
  }

  void _showRaceContextMenu(Race race, BuildContext context,
      RaceListController controller, RaceService service) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ContextMenu.race(
        race: race,
        onEdit: () => _editRace(context, race),
        onDelete: () => _deleteRace(race, controller, service),
      ),
    );
  }

  Future<void> _editRace(BuildContext context, Race race) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RaceModalCard(race: race),
    );
  }

  Future<void> _importRace(BuildContext context, RaceService service) async {
    setState(() {
      _isImporting = true;
      _errorMessage = null;
    });
    try {
      final filePicker = FilePickerService();
      final race = await filePicker.importRace();
      if (race == null) return;
      await service.saveRace(race);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).race_imported(race.name))),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  void _handleCreateRace(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RaceManagementScreen()),
    );
  }

  void _openFoldersScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FoldersScreen(folderType: FolderType.race),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
    create: (_) => RaceListController(
      context.read<RaceRepository>(),
    ),
    child: Consumer<RaceListController>(
      builder: (context, controller, child) {
        final service = context.read<RaceService>();
        final s = S.of(context);
        return Scaffold(
      appBar: CommonMainAppBar(
        title: s.races,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: s.search_race_hint,
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
        onFoldersPressed: _openFoldersScreen,
      ),
      body: Column(
        children: [
          ListStateIndicator(
            isLoading: _isImporting || controller.isLoading,
            errorMessage: _errorMessage ?? controller.error,
            onErrorClose: () {
              setState(() => _errorMessage = null);
            },
          ),
          Expanded(
            child: Column(
              children: [
                if (controller.allTags.isNotEmpty)
                  TagFilter(
                    tags: _getTags(context, controller),
                    selectedTag: controller.selectedTag,
                    onTagSelected: (tag) =>
                        _onTagSelected(tag, context, controller),
                    context: context,
                  ),
                Expanded(
                  child: OptimizedListView<Race>(
                    items: controller.filteredItems,
                    itemBuilder: (ctx, race, index) => RaceCardItem(
                      key: ValueKey(race.key),
                      race: race,
                      onTap: () => _editRace(context, race),
                      onLongPress: () => _showRaceContextMenu(
                          race, context, controller, service),
                      onShare: () => service.exportToPdf(context, race),
                      onSettings: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const SwipeActionSettingsScreen(),
                        ),
                      ),
                    ),
                    onReorder: (oldIndex, newIndex) =>
                        controller.reorder(oldIndex, newIndex),
                    scrollController: _scrollController,
                    enableReorder:
                        !_isSearching && controller.selectedTag == null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _isFabVisible
          ? CommonListFloatingButtons(
              onImport: () => _importRace(context, service),
              onAdd: () => _handleCreateRace(context),
              heroTag: "race_list",
            )
          : null,
    );
    }
    )
    );
  }
}