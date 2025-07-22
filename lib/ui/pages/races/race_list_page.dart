import 'dart:async';

import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/ui/pages/folders/folder_list_page.dart';
import 'package:characterbook/ui/widgets/mixins/list_page_mixin.dart';
import 'package:characterbook/ui/widgets/context_menu.dart';
import 'package:characterbook/ui/widgets/custom_app_bar.dart';
import 'package:characterbook/ui/widgets/custom_floating_buttons.dart';
import 'package:characterbook/ui/widgets/filter_chip_widget.dart';
import 'package:characterbook/ui/widgets/list_views/race_list_view.dart';
import 'package:characterbook/ui/widgets/mixins/tag_mixin.dart';
import 'package:characterbook/ui/widgets/tags/tag_filter.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../generated/l10n.dart';
import '../../../models/character_model.dart';
import '../../../models/race_model.dart';
import 'race_management_page.dart';

class RaceListPage extends StatefulWidget {
  const RaceListPage({super.key});

  @override
  State<RaceListPage> createState() => _RaceListPageState();
}

class _RaceListPageState extends State<RaceListPage> with ListPageMixin, TagMixin<Race> {
  List<Race> filteredRaces = [];
  String? selectedTag;

  @override
  List<String> getAllTags(List<Race> races) {
    return generateAllTags(races, context, (r) => r.tags);
  }

  bool _isShortName(Race r) => r.name.length <= 4;

  void filterRaces(String query, List<Race> allRaces) {
    setState(() {
      filteredRaces = allRaces.where((race) {
        final matchesSearch = query.isEmpty ||
            race.name.toLowerCase().contains(query.toLowerCase()) ||
            race.description.toLowerCase().contains(query.toLowerCase());

        return matchesSearch && matchesTagFilter(
          selectedTag, context, race, (r) => r.tags, _isShortName);
      }).toList();
    });
  }

  Future<bool> isRaceUsed(Race race) async {
    final charactersBox = Hive.box<Character>('characters');
    final characters = charactersBox.values;
    
    return characters.any((character) => character.race?.key == race.key);
  }

  Future<void> deleteRace(Race race) async {
    if (await isRaceUsed(race)) {
      if (mounted) showRaceInUseDialog();
      return;
    }

    final confirmed = await showDeleteConfirmationDialog(
      S.of(context).race_delete_title,
      S.of(context).race_delete_confirm,
    );

    if (confirmed) {
      await Hive.box<Race>('races').delete(race.key);
      if (mounted) showSnackBar(S.of(context).race_deleted);
    }
  }

  Future<void> importRaceFromFile() async {
    try {
      setState(() {
        isImporting = true;
        errorMessage = null;
      });

      final race = await filePickerService.importRace();
      if (race == null) return;

      final box = Hive.box<Race>('races');
      await box.add(race);

      if (mounted) {
        showSnackBar(S.of(context).race_imported(race.name));
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

  void showRaceInUseDialog() {
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

  void showRaceContextMenu(Race race) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenu.race(
        race: race,
        onEdit: () => editRace(race),
        onDelete: () => deleteRace(race),
      ),
    );
  }

  Future<void> editRace(Race race) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => RaceManagementPage(race: race)),
    );
    if (result == true && mounted) {
      filterRaces(searchController.text, Hive.box<Race>('races').values.toList());
    }
  }

  Future<void> reorderRaces(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    final box = Hive.box<Race>('races');
    final races = box.values.toList();

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final race = races.removeAt(oldIndex);
    races.insert(newIndex, race);

    await box.clear();
    await box.addAll(races);

    if (mounted) {
      setState(() {
        filterRaces(searchController.text, box.values.toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).races,
        isSearching: isSearching,
        searchController: searchController,
        searchHint: S.of(context).search_race_hint,
        onSearchToggle: () {
          setState(() {
            isSearching = !isSearching;
            if (!isSearching) {
              searchController.clear();
              selectedTag = null;
              filteredRaces = [];
            }
          });
        },
        onSearchChanged: (query) => filterRaces(query, Hive.box<Race>('races').values.toList()),
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.folder_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FoldersScreen(folderType: FolderType.race),
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
            child: ValueListenableBuilder<Box<Race>>(
              valueListenable: Hive.box<Race>('races').listenable(),
              builder: (context, box, _) {
                final allRaces = box.values.toList();
                final tags = getAllTags(allRaces);
                final racesToShow = isSearching || selectedTag != null
                    ? filteredRaces
                    : allRaces;

                return Column(
                  children: [
                    if (tags.isNotEmpty)
                      TagFilter(
                          tags: tags,
                          selectedTag: selectedTag,
                          onTagSelected: (tag) {
                            setState(() => selectedTag = tag);
                            filterRaces(searchController.text, allRaces);
                          },
                          context: context,
                          isForCharacters: false
                        ),
                    Expanded(
                      child: RaceListView(
                        scrollController: scrollController,
                        allRaces: allRaces,
                        racesToShow: racesToShow,
                        tags: tags,
                        searchController: searchController,
                        isSearching: isSearching,
                        selectedTag: selectedTag,
                        onReorder: reorderRaces,
                        onRaceTap: editRace,
                        onRaceLongPress: showRaceContextMenu,
                        onImportRace: importRaceFromFile,
                        onCreateRace: () async {
                          await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RaceManagementPage()),
                          );
                        }
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
            onImport: importRaceFromFile,
            onAdd: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (context) => const RaceManagementPage()),
              );
              if (result == true && mounted) {
                filterRaces(searchController.text,
                    Hive.box<Race>('races').values.toList());
              }
            },
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