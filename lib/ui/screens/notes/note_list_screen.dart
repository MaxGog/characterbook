import 'package:characterbook/enums/note_sort_enum.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/repositories/note_repository.dart';
import 'package:characterbook/services/note_service.dart';
import 'package:characterbook/ui/controllers/note_list_controller.dart';
import 'package:characterbook/ui/screens/folder_screen.dart';

import 'package:characterbook/ui/screens/settings/swipe_action_settings_screen.dart';
import 'package:characterbook/ui/widgets/appbar/common_main_app_bar.dart';
import 'package:characterbook/ui/widgets/buttons/common_fab_menu.dart';
import 'package:characterbook/ui/widgets/items/note_card_item.dart';
import 'package:characterbook/ui/widgets/list/list_state_indicator.dart';
import 'package:characterbook/ui/widgets/list/optimized_list_view.dart';
import 'package:characterbook/ui/widgets/states/empty_notes_state.dart';
import 'package:characterbook/ui/widgets/tags/tag_filter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'note_management_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isFabVisible = true;
  String? _errorMessage; 

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final isScrollingDown = _scrollController.position.userScrollDirection ==
          ScrollDirection.reverse;
      if (isScrollingDown && _isFabVisible) {
        setState(() => _isFabVisible = false);
      } else if (!isScrollingDown && !_isFabVisible) {
        setState(() => _isFabVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<String> _getTags(BuildContext context, NoteListController controller) {
    final s = S.of(context);
    return [
      s.a_to_z,
      s.z_to_a,
      ...controller.allTags,
    ];
  }

  void _onTagSelected(String? tag, BuildContext context, NoteListController controller) {
    if (tag == null) {
      controller.setSelectedTag(null);
      return;
    }

    final s = S.of(context);
    if (tag == s.a_to_z) {
      controller.setSort(NoteSort.titleAsc);
    } else if (tag == s.z_to_a) {
      controller.setSort(NoteSort.titleDesc);
    } else {
      if (controller.selectedTag == tag) {
        controller.setSelectedTag(null);
      } else {
        controller.setSelectedTag(tag);
      }
    }
  }

  Future<void> _deleteNote(Note note, NoteListController controller) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).template_delete_title),
        content: Text(
            '${S.of(context).posts} "${note.title}" ${S.of(context).template_delete_confirm}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.deleteNote(note);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${S.of(context).posts} "${note.title}" ${S.of(context).template_deleted}'),
            action: SnackBarAction(
              label: S.of(context).cancel,
              onPressed: () async {
              },
            ),
          ),
        );
      }
    }
  }

  void _editNote(Note note) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => NoteManagementScreen(note: note)),
    );
  }

  void _handleNoteTap(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteManagementScreen(note: note)),
    );
  }

  void _openNoteCreation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoteManagementScreen()),
    );
  }

  void _openFoldersScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FoldersScreen(folderType: FolderType.note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
    create: (_) => NoteListController(
      context.read<NoteRepository>(),
    ),
    child: Consumer<NoteListController>(
      builder: (context, controller, child) {
        final service = context.read<NoteService>();
        final s = S.of(context);
        return Scaffold(
      appBar: CommonMainAppBar(
        title: '${s.my} ${s.posts.toLowerCase()}',
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: s.search_hint,
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
            isLoading: controller.isLoading,
            errorMessage: _errorMessage ?? controller.error,
            onErrorClose: () {
              setState(() => _errorMessage = null);
            },
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final tags = _getTags(context, controller);
                final notesToShow = controller.filteredItems;

                if (notesToShow.isEmpty &&
                    !_isSearching &&
                    controller.selectedTag == null) {
                  return NotesEmptyState(isSearching: false);
                }

                return Column(
                  children: [
                    if (tags.isNotEmpty)
                      TagFilter(
                        tags: tags,
                        selectedTag: controller.selectedTag,
                        onTagSelected: (tag) =>
                            _onTagSelected(tag, context, controller),
                        context: context,
                      ),
                    Expanded(
                      child: notesToShow.isEmpty
                          ? NotesEmptyState(
                              isSearching: _isSearching &&
                                  _searchController.text.isNotEmpty,
                            )
                          : OptimizedListView<Note>(
                              items: notesToShow,
                              itemBuilder: (ctx, note, index) => NoteCardItem(
                                key: ValueKey(note.key),
                                note: note,
                                onTap: () => _handleNoteTap(note),
                                onEdit: () => _editNote(note),
                                onDelete: () => _deleteNote(note, controller),
                                onShare: () => service.shareNote(context, note),
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
                              enableReorder: !_isSearching &&
                                  controller.selectedTag == null,
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _isFabVisible
          ? CommonListFloatingButtons(
              showImportButton: false,
              onAdd: _openNoteCreation,
              heroTag: "note_list",
            )
          : null,
    );
    }
    )
    );
  }
}