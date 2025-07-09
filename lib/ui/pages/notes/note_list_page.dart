import 'package:characterbook/ui/widgets/filter_chip_widget.dart';
import 'package:characterbook/ui/widgets/items/note_card.dart';
import 'package:characterbook/ui/widgets/notes_empty_state.dart';
import 'package:flutter/material.dart';
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

class _NotesListPageState extends State<NotesListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Note> _filteredNotes = [];
  bool _isSearching = false;
  String? _selectedTag;
  String? _selectedCharacter;

  List<String> _getAllTags(List<Note> notes) {
    return notes.expand((note) => note.tags).toSet().toList()..sort();
  }

  List<String> _getAllCharacterNames(List<Note> notes) {
    final characterBox = Hive.box<Character>('characters');
    final characterIds = notes.expand((note) => note.characterIds).toSet();
    return characterIds
        .map((id) => characterBox.get(id))
        .whereType<Character>()
        .map((c) => c.name)
        .toSet()
        .toList()
      ..sort();
  }

  void _filterNotes(String query, List<Note> allNotes) {
    final characterBox = Hive.box<Character>('characters');

    setState(() {
      _filteredNotes = allNotes.where((note) {
        final matchesSearch = query.isEmpty ||
            note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase());

        final matchesTag = _selectedTag == null || note.tags.contains(_selectedTag);

        final matchesCharacter = _selectedCharacter == null ||
            note.characterIds.any((id) {
              final character = characterBox.get(id);
              return character?.name == _selectedCharacter;
            });

        return matchesSearch && matchesTag && matchesCharacter;
      }).toList();
    });
  }

  Future<void> _deleteNote(Note note) async {
    final box = Hive.box<Note>('notes');
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).template_delete_title),
        content: Text('${S.of(context).posts} "${note.title}" ${S.of(context).template_delete_confirm}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    ) ?? false;

    if (shouldDelete) {
      await box.delete(note.key);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${S.of(context).posts} "${note.title}" ${S.of(context).template_deleted}'),
          action: SnackBarAction(
            label: S.of(context).cancel,
            onPressed: () => box.add(note),
          ),
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
      _filterNotes(_searchController.text, Hive.box<Note>('notes').values.toList().cast<Note>());
    }
  }

  Future<void> _reorderNotes(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    final box = Hive.box<Note>('notes');
    final notes = box.values.toList().cast<Note>();

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final note = notes.removeAt(oldIndex);
    notes.insert(newIndex, note);

    await box.clear();
    await box.addAll(notes);

    if (mounted) {
      setState(() {
        _filterNotes(_searchController.text, notes);
      });
    }
  }

  Widget _buildFiltersRow(List<String> tags, List<String> characterNames) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (characterNames.isNotEmpty)
            FilterChipWidget(
              label: '${S.of(context).all} ${S.of(context).characters.toLowerCase()}',
              selected: _selectedCharacter == null,
              onSelected: (isSelected) {
                setState(() {
                  _selectedCharacter = null;
                  _filterNotes(_searchController.text,
                      Hive.box<Note>('notes').values.toList().cast<Note>());
                });
              },
            ),
          ...characterNames.map((name) => FilterChipWidget(
            label: name,
            selected: _selectedCharacter == name,
            onSelected: (isSelected) {
              setState(() {
                _selectedCharacter = _selectedCharacter == name ? null : name;
                _filterNotes(_searchController.text,
                    Hive.box<Note>('notes').values.toList().cast<Note>());
              });
            },
          )),
          if (tags.isNotEmpty)
            FilterChipWidget(
              label: S.of(context).all_tags,
              selected: _selectedTag == null,
              onSelected: (isSelected) {
                setState(() {
                  _selectedTag = null;
                  _filterNotes(_searchController.text,
                      Hive.box<Note>('notes').values.toList().cast<Note>());
                });
              },
            ),
          ...tags.map((tag) => FilterChipWidget(
            label: tag,
            selected: _selectedTag == tag,
            onSelected: (isSelected) {
              setState(() {
                _selectedTag = _selectedTag == tag ? null : tag;
                _filterNotes(_searchController.text,
                    Hive.box<Note>('notes').values.toList().cast<Note>());
              });
            },
          )),
        ],
      ),
    );
  }

  Widget _buildNotesList(List<Note> notes) {
    if (notes.isEmpty) {
      return NotesEmptyState(isSearching: _isSearching && _searchController.text.isNotEmpty);
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notes.length,
      itemBuilder: (context, index) => NoteCard(
        key: ValueKey(notes[index].key),
        note: notes[index],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteEditPage(note: notes[index]))),
        onEdit: () => _editNote(notes[index]),
        onDelete: () => _deleteNote(notes[index]),
      ),
      onReorder: (oldIndex, newIndex) => _reorderNotes(oldIndex, newIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${S.of(context).my} ${S.of(context).posts.toLowerCase()}',
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: S.of(context).search_hint,
        onSearchToggle: () {
          setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) {
              _searchController.clear();
              _selectedTag = null;
              _selectedCharacter = null;
              _filteredNotes = [];
            }
          });
        },
        onSearchChanged: (query) {
          final allNotes = Hive.box<Note>('notes').values.toList().cast<Note>();
          _filterNotes(query, allNotes);
        },
      ),
      body: ValueListenableBuilder<Box<Note>>(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, box, _) {
          final allNotes = box.values.toList().cast<Note>();
          allNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          final tags = _getAllTags(allNotes);
          final characterNames = _getAllCharacterNames(allNotes);

          return Column(
            children: [
              if (tags.isNotEmpty || characterNames.isNotEmpty)
                _buildFiltersRow(tags, characterNames),
              Expanded(
                child: _buildNotesList(
                  _isSearching || _selectedTag != null || _selectedCharacter != null
                      ? _filteredNotes
                      : allNotes,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: CustomFloatingButtons(
        showImportButton: false,
        onAdd: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NoteEditPage()),
        ),
      ),
    );
  }
}