import 'package:characterbook/ui/dialogs/folder_dialog.dart';
import 'package:characterbook/ui/pages/characters/character_management_page.dart';
import 'package:characterbook/ui/pages/notes/note_management_page.dart';
import 'package:characterbook/ui/pages/races/race_management_page.dart';
import 'package:characterbook/ui/widgets/empty_folders_state.dart';
import 'package:characterbook/ui/widgets/items/character_card.dart';
import 'package:characterbook/ui/widgets/items/folder_card.dart';
import 'package:characterbook/ui/widgets/items/note_card.dart';
import 'package:characterbook/ui/widgets/items/race_card.dart';
import 'package:flutter/material.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/ui/widgets/custom_app_bar.dart';
import 'package:characterbook/ui/widgets/custom_floating_buttons.dart';
import 'package:characterbook/ui/widgets/context_menu.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../generated/l10n.dart';

class FoldersScreen extends StatefulWidget {
  final FolderType folderType;

  const FoldersScreen({super.key, required this.folderType});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  late Box<Folder> _folderBox;
  late Box<Character> _characterBox;
  late Box<Race> _raceBox;
  late Box<Note> _noteBox;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _folderBox = Hive.box<Folder>('folders');
    _characterBox = Hive.box<Character>('characters');
    _raceBox = Hive.box<Race>('races');
    _noteBox = Hive.box<Note>('notes');
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: _getTitle(s),
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: s.search_hint,
        onSearchToggle: _toggleSearch,
        onSearchChanged: _onSearchChanged,
      ),
      body: ValueListenableBuilder(
        valueListenable: _folderBox.listenable(),
        builder: (context, box, _) {
          final folders = _getFilteredFolders();
          
          if (folders.isEmpty) {
            return EmptyFoldersState(
              folderType: widget.folderType,
              onCreate: _createNewFolder,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: folders.length,
            itemBuilder: (context, index) {
              final folder = folders[index];
              return FolderItem(
                folder: folder,
                onEdit: () => _editFolder(folder, s),
                onDelete: () => _deleteFolder(folder, s),
                children: _buildFolderContents(folder),
              );
            },
          );
        },
      ),
      floatingActionButton: CustomFloatingButtons(
        onAdd: _createNewFolder,
        addTooltip: s.create,
      ),
    );
  }

  String _getTitle(S s) {
    return switch (widget.folderType) {
      FolderType.character => s.characters,
      FolderType.race => s.races,
      FolderType.note => s.posts,
      FolderType.template => s.templates,
    };
  }

  List<Folder> _getFilteredFolders() {
    return _folderBox.values
        .where((folder) => 
          folder.type == widget.folderType &&
          (folder.parentId == null || folder.parentId!.isEmpty) &&
          (_searchQuery.isEmpty || 
           folder.name.toLowerCase().contains(_searchQuery.toLowerCase())))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  List<Widget> _buildFolderContents(Folder folder) {
    switch (folder.type) {
      case FolderType.character:
        return _buildCharacterContents(folder);
      case FolderType.race:
        return _buildRaceContents(folder);
      case FolderType.note:
        return _buildNoteContents(folder);
      case FolderType.template:
        return [];
    }
  }

  List<Widget> _buildCharacterContents(Folder folder) {
    final characters = _characterBox.values
        .where((character) => folder.contentIds.contains(character.key.toString()))
        .toList();

    if (characters.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            S.of(context).characters,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ];
    }

    return characters.map((character) => CharacterCard(
      character: character,
      isSelected: false,
      onTap: () => _openCharacter(character),
      onLongPress: () => _showCharacterContextMenu(character),
      onMenuPressed: () => _showCharacterContextMenu(character),
    )).toList();
  }

  List<Widget> _buildRaceContents(Folder folder) {
    final races = _raceBox.values
        .where((race) => folder.contentIds.contains(race.key.toString()))
        .toList();

    if (races.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            S.of(context).races,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ];
    }

    return races.map((race) => RaceCard(
      race: race,
      onTap: () => _openRace(race),
      onLongPress: () => _showRaceContextMenu(race),
    )).toList();
  }

  List<Widget> _buildNoteContents(Folder folder) {
    final notes = _noteBox.values
        .where((note) => folder.contentIds.contains(note.id))
        .toList();

    if (notes.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            S.of(context).posts,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ];
    }

    return notes.map((note) => NoteCard(
      note: note,
      onTap: () => _openNote(note),
      onEdit: () => _editNote(note),
      onDelete: () => _deleteNote(note),
    )).toList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _createNewFolder() {
    _showFolderDialog(null, null, S.of(context));
  }

  void _showFolderDialog(Folder? folder, Folder? parentFolder, S s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28))
      ),
      builder: (context) => FolderDialog(
        folder: folder,
        parentFolder: parentFolder,
        folderType: widget.folderType,
        onSave: _saveFolder,
      ),
    );
  }

  Future<void> _saveFolder(Folder? folder, String name, Folder? parentFolder, int colorValue) async {
    if (folder == null) {
      final newFolder = Folder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        type: widget.folderType,
        parentId: parentFolder?.id,
        colorValue: colorValue,
      );
      await _folderBox.put(newFolder.id, newFolder);
    } else {
      folder.name = name;
      folder.colorValue = colorValue;
      folder.updatedAt = DateTime.now();
      await folder.save();
    }
  }

  void _deleteFolder(Folder folder, S s) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          s.delete,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Text(
          s.delete,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              s.cancel,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () async {
              await folder.delete();
              if (mounted) Navigator.pop(context);
            },
            child: Text(
              s.delete,
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _openCharacter(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CharacterEditPage(character: character),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  void _showCharacterContextMenu(Character character) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28))
      ),
      builder: (context) => ContextMenu(
        item: character,
        onEdit: () => _openCharacter(character),
        onDelete: () => _deleteCharacter(character),
        showExportPdf: true,
        showCopy: true,
        showShare: true,
      ),
    );
  }

  Future<void> _deleteCharacter(Character character) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).delete),
        content: Text(S.of(context).character_delete_confirm),
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
    );

    if (confirmed == true) {
      await character.delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).character_deleted)),
        );
      }
    }
  }

  void _openRace(Race race) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RaceManagementPage(race: race),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  void _showRaceContextMenu(Race race) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28))
      ),
      builder: (context) => ContextMenu(
        item: race,
        onEdit: () => _openRace(race),
        onDelete: () => _deleteRace(race),
        showExportPdf: false,
        showCopy: false,
        showShare: false,
      ),
    );
  }

  Future<void> _deleteRace(Race race) async {
    final isUsed = await isRaceUsed(race);
    if (isUsed) {
      if (mounted) {
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
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).delete),
        content: Text(S.of(context).race_delete_confirm),
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
    );

    if (confirmed == true) {
      await race.delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).race_deleted)),
        );
      }
    }
  }

  Future<bool> isRaceUsed(Race race) async {
    final characters = _characterBox.values;
    return characters.any((character) => character.race?.key == race.key);
  }

  void _openNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditPage(note: note),
      ),
    );
  }

  void _editNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>NoteEditPage(note: note),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _deleteNote(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).delete),
        content: Text('${S.of(context).posts} "${note.title}" ${S.of(context).template_delete_confirm}'),
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
    );

    if (confirmed == true) {
      await note.delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).posts} "${note.title}" ${S.of(context).template_deleted}'),
            action: SnackBarAction(
              label: S.of(context).cancel,
              onPressed: () => _noteBox.add(note),
            ),
          ),
        );
      }
    }
  }

  void _editFolder(Folder folder, S s) {
    _showFolderDialog(folder, null, s);
  }
}