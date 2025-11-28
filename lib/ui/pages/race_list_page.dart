import 'dart:async';

import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/services/file_picker_service.dart';
import 'package:characterbook/ui/pages/folder_list_page.dart';
import 'package:characterbook/ui/widgets/tools_context_menu.dart';
import 'package:characterbook/ui/widgets/appbar/common_main_app_bar.dart';
import 'package:characterbook/ui/widgets/buttons/common_list_floating_buttons.dart';
import 'package:characterbook/ui/widgets/cards/race_card.dart';
import 'package:characterbook/ui/widgets/list/list_state_indicator.dart';
import 'package:characterbook/ui/widgets/list/optimized_list_view.dart';
import 'package:characterbook/ui/widgets/performance/optimized_value_listenable.dart';
import 'package:characterbook/ui/widgets/tags/tag_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../generated/l10n.dart';
import '../../models/character_model.dart';
import '../../models/race_model.dart';
import 'race_management_page.dart';

class RaceListPage extends StatefulWidget {
  const RaceListPage({super.key});

  @override
  State<RaceListPage> createState() => _RaceListPageState();
}

class _RaceListPageState extends State<RaceListPage> {
  final List<Race> _filteredRaces = [];
  String? _selectedTag;
  Timer? _debounceTimer;
  final Box<Race> _racesBox = Hive.box<Race>('races');
  final Box<Character> _charactersBox = Hive.box<Character>('characters');

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  bool isSearching = false;
  bool isImporting = false;
  bool isFabVisible = true;
  String? errorMessage;

  List<String> _getAllTags(List<Race> races) {
    final allTags = <String>{};
    for (final race in races) {
      allTags.addAll(race.tags);
    }
    return allTags.toList()..sort();
  }

  bool _matchesTagFilter(Race race) {
    if (_selectedTag == null) return true;
    return race.tags.contains(_selectedTag);
  }

  void _filterRaces(String query, List<Race> allRaces) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      
      setState(() {
        _filteredRaces.clear();
        _filteredRaces.addAll(
          allRaces.where((race) {
            final matchesSearch = query.isEmpty ||
                race.name.toLowerCase().contains(query.toLowerCase()) ||
                race.description.toLowerCase().contains(query.toLowerCase());

            return matchesSearch && _matchesTagFilter(race);
          }),
        );
      });
    });
  }

  Future<bool> _isRaceUsed(Race race) async {
    final characters = _charactersBox.values;
    return characters.any((character) => character.race?.key == race.key);
  }

  Future<void> _deleteRace(Race race) async {
    if (await _isRaceUsed(race)) {
      if (mounted) _showRaceInUseDialog();
      return;
    }

    final confirmed = await _showDeleteConfirmationDialog(
      S.of(context).race_delete_title,
      S.of(context).race_delete_confirm,
    );

    if (confirmed) {
      await _racesBox.delete(race.key);
      if (mounted) _showSnackBar(S.of(context).race_deleted);
    }
  }

  Future<void> _importRaceFromFile() async {
    try {
      setState(() {
        isImporting = true;
        errorMessage = null;
      });
      FilePickerService filePickerService = FilePickerService();
      final race = await filePickerService.importRace();
      if (race == null) return;

      await _racesBox.add(race);

      if (mounted) {
        _showSnackBar(S.of(context).race_imported(race.name));
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

  Future<bool> _showDeleteConfirmationDialog(String title, String content) async {
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
    ) ?? false;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showRaceContextMenu(Race race) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu.race(
        race: race,
        onEdit: () => _editRace(race),
        onDelete: () => _deleteRace(race),
      ),
    );
  }

  Future<void> _editRace(Race race) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => RaceManagementPage(race: race)),
    );
    if (result == true && mounted) {
      _filterRaces(searchController.text, _racesBox.values.toList());
    }
  }

  Future<void> _reorderRaces(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    final races = _racesBox.values.toList();

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final race = races.removeAt(oldIndex);
    races.insert(newIndex, race);

    await _racesBox.clear();
    await _racesBox.addAll(races);

    if (mounted) {
      setState(() {
        _filterRaces(searchController.text, _racesBox.values.toList());
      });
    }
  }

  void _handleSearchToggle() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        _selectedTag = null;
        _filteredRaces.clear();
      }
    });
  }

  void _handleSearchChanged(String query) {
    _filterRaces(query, _racesBox.values.toList());
  }

  Future<void> _handleCreateRace() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const RaceManagementPage()),
    );
    if (result == true && mounted) {
      _filterRaces(searchController.text, _racesBox.values.toList());
    }
  }

  void _openFoldersScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FoldersScreen(folderType: FolderType.race),
      ),
    );
  }

  Widget _buildRaceCard(BuildContext context, Race race, int index) {
    return RaceCard(
      key: ValueKey(race.key),
      race: race,
      onTap: () => _editRace(race),
      onLongPress: () => _showRaceContextMenu(race),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final isScrollingDown = scrollController.position.userScrollDirection == 
          ScrollDirection.reverse;
      if (isScrollingDown && isFabVisible) {
        setState(() => isFabVisible = false);
      } else if (!isScrollingDown && !isFabVisible) {
        setState(() => isFabVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonMainAppBar(
        title: S.of(context).races,
        isSearching: isSearching,
        searchController: searchController,
        searchHint: S.of(context).search_race_hint,
        onSearchToggle: _handleSearchToggle,
        onSearchChanged: _handleSearchChanged,
        onFoldersPressed: _openFoldersScreen,
      ),
      body: Column(
        children: [
          ListStateIndicator(
            isLoading: isImporting,
            errorMessage: errorMessage,
            onErrorClose: () => setState(() => errorMessage = null),
          ),
          Expanded(
            child: OptimizedValueListenable<Race>(
              box: _racesBox,
              listen: true,
              builder: (context, allRaces) {
                final tags = _getAllTags(allRaces);
                final racesToShow = isSearching || _selectedTag != null
                    ? _filteredRaces
                    : allRaces;

                return Column(
                  children: [
                    if (tags.isNotEmpty)
                      TagFilter(
                        tags: tags,
                        selectedTag: _selectedTag,
                        onTagSelected: (tag) {
                          setState(() => _selectedTag = tag);
                          _filterRaces(searchController.text, allRaces);
                        }, 
                        context: context,
                      ),
                    Expanded(
                      child: OptimizedListView<Race>(
                        items: racesToShow,
                        itemBuilder: _buildRaceCard,
                        onReorder: _reorderRaces,
                        scrollController: scrollController,
                        enableReorder: !isSearching && _selectedTag == null,
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
        ? CommonListFloatingButtons(
            onImport: _importRaceFromFile,
            onAdd: _handleCreateRace,
            heroTag: "race_list",
          ) 
        : null,
    );
  }
}