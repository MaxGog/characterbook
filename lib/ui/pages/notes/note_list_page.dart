import 'dart:async';

import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/ui/pages/folders/folder_list_page.dart';
import 'package:characterbook/ui/widgets/items/note_card.dart';
import 'package:characterbook/ui/widgets/list/list_state_indicator.dart';
import 'package:characterbook/ui/widgets/list/optimized_list_view.dart';
import 'package:characterbook/ui/widgets/mixins/tag_mixin.dart';
import 'package:characterbook/ui/widgets/empty_notes_state.dart';
import 'package:characterbook/ui/widgets/performance/optimized_value_listenable.dart';
import 'package:characterbook/ui/widgets/tags/tag_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../generated/l10n.dart';
import '../../../models/character_model.dart';
import '../../../models/note_model.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_floating_buttons.dart';
import 'note_management_page.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> with TagMixin<Note> {
  final List<Note> _filteredNotes = [];
  String? _selectedTag;
  String? _selectedCharacter;
  Timer? _debounceTimer;
  final Box<Note> _notesBox = Hive.box<Note>('notes');
  final Box<Character> _charactersBox = Hive.box<Character>('characters');

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  bool isSearching = false;
  bool isImporting = false;
  bool isFabVisible = true;
  String? errorMessage;

  List<String> _getAllTags(List<Note> notes) {
    return generateAllTags(notes, context, (n) => n.tags);
  }

  bool _isShortName(Note n) => n.title.length <= 4;

  void _filterNotes(String query, List<Note> allNotes) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      final queryLower = query.toLowerCase();

      setState(() {
        _filteredNotes.clear();
        _filteredNotes.addAll(allNotes.where((note) {
          final matchesSearch = query.isEmpty ||
              note.title.toLowerCase().contains(queryLower) ||
              note.content.toLowerCase().contains(queryLower);

          final matchesTag = matchesTagFilter(
            _selectedTag, context, note, (n) => n.tags, _isShortName);

          final matchesCharacter = _selectedCharacter == null ||
              note.characterIds.any((id) {
                final character = _charactersBox.get(id);
                return character?.name == _selectedCharacter;
              });

          return matchesSearch && matchesTag && matchesCharacter;
        }));
      });
    });
  }

  List<String> _getAllCharacterNames(List<Note> notes) {
    final characterIds = notes.expand((note) => note.characterIds).toSet();
    return characterIds
        .map((id) => _charactersBox.get(id))
        .whereType<Character>()
        .map((c) => c.name)
        .toSet()
        .toList()
      ..sort();
  }

  Future<void> _deleteNote(Note note) async {
    final confirmed = await _showDeleteConfirmationDialog(
      S.of(context).template_delete_title,
      '${S.of(context).posts} "${note.title}" ${S.of(context).template_delete_confirm}',
    );

    if (confirmed) {
      await _notesBox.delete(note.key);
      if (!mounted) return;

      _showSnackBar(
        '${S.of(context).posts} "${note.title}" ${S.of(context).template_deleted}',
        action: SnackBarAction(
          label: S.of(context).cancel,
          onPressed: () => _notesBox.add(note),
        ),
      );
    }
  }

  Future<void> _editNote(Note note) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => NoteEditPage(note: note)),
    );
    if (result == true && mounted) {
      _filterNotes(searchController.text, _notesBox.values.cast<Note>().toList());
    }
  }

  Future<void> _reorderNotes(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    final notes = _notesBox.values.cast<Note>().toList();

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final note = notes.removeAt(oldIndex);
    notes.insert(newIndex, note);

    await _notesBox.clear();
    await _notesBox.addAll(notes);

    if (mounted) {
      setState(() {
        _filterNotes(searchController.text, notes);
      });
    }
  }

  void _handleNoteTap(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditPage(note: note)),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note, int index) {
    return NoteCard(
      key: ValueKey(note.key),
      note: note,
      onTap: () => _handleNoteTap(note),
      onEdit: () => _editNote(note),
      onDelete: () => _deleteNote(note),
    );
  }

  void _handleSearchToggle() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        _selectedTag = null;
        _selectedCharacter = null;
        _filteredNotes.clear();
      }
    });
  }

  void _handleSearchChanged(String query) {
    final allNotes = _notesBox.values.cast<Note>().toList();
    _filterNotes(query, allNotes);
  }

  void _handleTagSelected(String? tag) {
    setState(() => _selectedTag = tag);
    _filterNotes(searchController.text, _notesBox.values.cast<Note>().toList());
  }

  void _openFoldersScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FoldersScreen(folderType: FolderType.note),
      ),
    );
  }

  void _openNoteCreation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoteEditPage()),
    );
  }

  List<Note> _getSortedNotes(List<Note> notes) {
    final sortedNotes = List<Note>.from(notes);
    sortedNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sortedNotes;
  }

  List<Note> _getNotesToShow(List<Note> allNotes) {
    return isSearching || _selectedTag != null || _selectedCharacter != null
        ? _filteredNotes
        : allNotes;
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

  void _showSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
      ),
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
      appBar: CustomAppBar(
        title: '${S.of(context).my} ${S.of(context).posts.toLowerCase()}',
        isSearching: isSearching,
        searchController: searchController,
        searchHint: S.of(context).search_hint,
        onSearchToggle: _handleSearchToggle,
        onSearchChanged: _handleSearchChanged,
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.folder_outlined),
            onPressed: _openFoldersScreen,
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
            child: OptimizedValueListenable<Note>(
              box: _notesBox,
              listen: true,
              builder: (context, allNotes) {
                final sortedNotes = _getSortedNotes(allNotes);
                final tags = _getAllTags(sortedNotes);
                final characterNames = _getAllCharacterNames(sortedNotes);
                final notesToShow = _getNotesToShow(sortedNotes);

                return Column(
                  children: [
                    if (tags.isNotEmpty || characterNames.isNotEmpty)
                      TagFilter(
                        tags: tags,
                        selectedTag: _selectedTag,
                        onTagSelected: _handleTagSelected,
                        context: context,
                        showAllOption: true,
                        isForCharacters: false,
                      ),
                    Expanded(
                      child: notesToShow.isEmpty
                          ? NotesEmptyState(
                              isSearching: isSearching && searchController.text.isNotEmpty)
                          : OptimizedListView<Note>(
                              items: notesToShow,
                              itemBuilder: _buildNoteCard,
                              onReorder: _reorderNotes,
                              scrollController: scrollController,
                              enableReorder: !isSearching && _selectedTag == null && _selectedCharacter == null,
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
              showImportButton: false,
              onAdd: _openNoteCreation,
            )
          : null,
    );
  }
}