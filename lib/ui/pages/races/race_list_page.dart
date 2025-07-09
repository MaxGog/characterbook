import 'dart:async';

import 'package:characterbook/ui/widgets/context_menu.dart';
import 'package:characterbook/ui/widgets/custom_app_bar.dart';
import 'package:characterbook/ui/widgets/custom_floating_buttons.dart';
import 'package:characterbook/ui/widgets/list_views/race_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../generated/l10n.dart';
import '../../../models/character_model.dart';
import '../../../models/race_model.dart';
import '../../../services/file_picker_service.dart';
import 'race_management_page.dart';

class RaceListPage extends StatefulWidget {
  const RaceListPage({super.key});

  @override
  State<RaceListPage> createState() => _RaceListPageState();
}

class _RaceListPageState extends State<RaceListPage> {
  final TextEditingController _searchController = TextEditingController();
  final FilePickerService _filePickerService = FilePickerService();
  List<Race> _filteredRaces = [];
  bool _isSearching = false;
  String? _selectedTag;
  bool _isImporting = false;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  List<String> _generateTags(List<Race> races) {
    final tags = <String>{};
    return tags.toList()..sort();
  }

  void _filterRaces(String query, List<Race> allRaces) {
    setState(() {
      _filteredRaces = allRaces.where((race) {
        final matchesSearch = query.isEmpty ||
            race.name.toLowerCase().contains(query.toLowerCase()) ||
            race.description.toLowerCase().contains(query.toLowerCase());

        final matchesTag = _selectedTag == null;

        return matchesSearch && matchesTag;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.forward) {
        if (!_showFab) setState(() => _showFab = true);
      } else if (direction == ScrollDirection.reverse) {
        if (_showFab) setState(() => _showFab = false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> _isRaceUsed(Race race) async {
    final charactersBox = Hive.box<Character>('characters');
    final characters = charactersBox.values;
    
    final usingCharacter = characters.firstWhere(
      (character) => character.race?.key == race.key,
      // ignore: cast_from_null_always_fails
      orElse: () => null as Character,
    );
    
    // ignore: unnecessary_null_comparison
    return usingCharacter != null;
  }

  Future<void> _deleteRace(Race race) async {
    if (await _isRaceUsed(race)) {
      if (mounted) _showRaceInUseDialog();
      return;
    }

    final confirmed = await _showDeleteConfirmationDialog();
    if (confirmed ?? false) {
      await Hive.box<Race>('races').delete(race.key);
      if (mounted) _showSnackBar(S.of(context).race_deleted);
    }
  }

  Future<void> _importRaceFromFile() async {
    try {
      setState(() {
        _isImporting = true;
        _errorMessage = null;
      });

      final race = await _filePickerService.importRace();
      if (race == null) return;

      final box = Hive.box<Race>('races');
      await box.add(race);

      if (mounted) {
        _showSnackBar(S.of(context).race_imported(race.name));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  Future<bool?> _showDeleteConfirmationDialog() async {
    if (!mounted) return false;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).race_delete_title),
        content: Text(S.of(context).race_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              S.of(context).cancel,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
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
    );
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
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
      _filterRaces(_searchController.text, Hive.box<Race>('races').values.toList());
    }
  }

  Future<void> _reorderRaces(int oldIndex, int newIndex) async {
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
        _filterRaces(_searchController.text, box.values.toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: S.of(context).races,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: S.of(context).search_race_hint,
        onSearchToggle: () {
          setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) {
              _searchController.clear();
              _selectedTag = null;
              _filteredRaces = [];
            }
          });
        },
        onSearchChanged: (query) => _filterRaces(query, Hive.box<Race>('races').values.toList()),
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
                    icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onErrorContainer),
                    onPressed: () => setState(() => _errorMessage = null),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ValueListenableBuilder<Box<Race>>(
              valueListenable: Hive.box<Race>('races').listenable(),
              builder: (context, box, _) {
                final allRaces = box.values.toList();
                final tags = _generateTags(allRaces);
                final racesToShow = _isSearching || _selectedTag != null
                    ? _filteredRaces
                    : allRaces;

                return RaceListView(
                  scrollController: _scrollController,
                  allRaces: allRaces,
                  racesToShow: racesToShow,
                  tags: tags,
                  searchController: _searchController,
                  isSearching: _isSearching,
                  selectedTag: _selectedTag,
                  onReorder: _reorderRaces,
                  onRaceTap: _editRace,
                  onRaceLongPress: _showRaceContextMenu,
                  onImportRace: _importRaceFromFile,
                  onCreateRace: () async {
                    await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(builder: (context) => const RaceManagementPage()),
                    );
                  }
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _showFab 
        ? CustomFloatingButtons(
            onImport: _importRaceFromFile,
            onAdd: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (context) => const RaceManagementPage()),
              );
              if (result == true && mounted) {
                _filterRaces(_searchController.text,
                    Hive.box<Race>('races').values.toList());
              }
            },
          ) : null,
    );
  }
}