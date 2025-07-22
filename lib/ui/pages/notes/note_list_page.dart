import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/ui/pages/folders/folder_list_page.dart';
import 'package:characterbook/ui/widgets/mixins/list_page_mixin.dart';
import 'package:characterbook/ui/widgets/filter_chip_widget.dart';
import 'package:characterbook/ui/widgets/items/note_card.dart';
import 'package:characterbook/ui/widgets/mixins/tag_mixin.dart';
import 'package:characterbook/ui/widgets/notes_empty_state.dart';
import 'package:characterbook/ui/widgets/tags/tag_filter.dart';
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

class _NotesListPageState extends State<NotesListPage> with ListPageMixin, TagMixin<Note> {
  List<Note> filteredNotes = [];
  String? selectedTag;
  String? selectedCharacter;

  @override
  List<String> getAllTags(List<Note> notes) {
    return generateAllTags(notes, context, (n) => n.tags);
  }

  bool _isShortName(Note n) => n.title.length <= 4;

  void filterNotes(String query, List<Note> allNotes) {
    final characterBox = Hive.box<Character>('characters');
    final queryLower = query.toLowerCase();

    setState(() {
      filteredNotes = allNotes.where((note) {
        final matchesSearch = query.isEmpty ||
            note.title.toLowerCase().contains(queryLower) ||
            note.content.toLowerCase().contains(queryLower);

        final matchesTag = matchesTagFilter(
          selectedTag, context, note, (n) => n.tags, _isShortName);

        final matchesCharacter = selectedCharacter == null ||
            note.characterIds.any((id) {
              final character = characterBox.get(id);
              return character?.name == selectedCharacter;
            });

        return matchesSearch && matchesTag && matchesCharacter;
      }).toList();
    });
  }

  List<String> getAllCharacterNames(List<Note> notes) {
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

  Future<void> deleteNote(Note note) async {
    final confirmed = await showDeleteConfirmationDialog(
      S.of(context).template_delete_title,
      '${S.of(context).posts} "${note.title}" ${S.of(context).template_delete_confirm}',
    );

    if (confirmed) {
      final box = Hive.box<Note>('notes');
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

  Future<void> editNote(Note note) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => NoteEditPage(note: note)),
    );
    if (result == true && mounted) {
      filterNotes(searchController.text, Hive.box<Note>('notes').values.toList().cast<Note>());
    }
  }

  Future<void> reorderNotes(int oldIndex, int newIndex) async {
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
        filterNotes(searchController.text, notes);
      });
    }
  }

  Widget buildNotesList(List<Note> notes) {
    if (notes.isEmpty) {
      return NotesEmptyState(isSearching: isSearching && searchController.text.isNotEmpty);
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
        onEdit: () => editNote(notes[index]),
        onDelete: () => deleteNote(notes[index]),
      ),
      onReorder: (oldIndex, newIndex) => reorderNotes(oldIndex, newIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${S.of(context).my} ${S.of(context).posts.toLowerCase()}',
        isSearching: isSearching,
        searchController: searchController,
        searchHint: S.of(context).search_hint,
        onSearchToggle: () {
          setState(() {
            isSearching = !isSearching;
            if (!isSearching) {
              searchController.clear();
              selectedTag = null;
              selectedCharacter = null;
              filteredNotes = [];
            }
          });
        },
        onSearchChanged: (query) {
          final allNotes = Hive.box<Note>('notes').values.toList().cast<Note>();
          filterNotes(query, allNotes);
        },
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.folder_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FoldersScreen(folderType: FolderType.note),
              ),
            ),
            tooltip: S.of(context).folders,
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Note>>(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, box, _) {
          final allNotes = box.values.toList().cast<Note>();
          allNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          final tags = getAllTags(allNotes);
          final characterNames = getAllCharacterNames(allNotes);

          return Column(
            children: [
              if (tags.isNotEmpty || characterNames.isNotEmpty)
                TagFilter(
                  tags: tags,
                  selectedTag: selectedTag,
                  onTagSelected: (tag) {
                    setState(() => selectedTag = tag);
                    filterNotes(searchController.text, 
                        Hive.box<Note>('notes').values.toList().cast<Note>());
                  },
                  context: context,
                  showAllOption: true,
                  isForCharacters: false
                ),
              Expanded(
                child: buildNotesList(
                  isSearching || selectedTag != null || selectedCharacter != null
                      ? filteredNotes
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