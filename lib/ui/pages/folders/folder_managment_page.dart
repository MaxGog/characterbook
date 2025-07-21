import 'package:characterbook/models/template_model.dart';
import 'package:characterbook/ui/widgets/items/character_card.dart';
import 'package:characterbook/ui/widgets/items/note_card.dart';
import 'package:characterbook/ui/widgets/items/race_card.dart';
import 'package:characterbook/ui/widgets/save_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';

class FolderEditScreen extends StatefulWidget {
  final Folder folder;

  const FolderEditScreen({super.key, required this.folder});

  @override
  State<FolderEditScreen> createState() => _FolderEditScreenState();
}

class _FolderEditScreenState extends State<FolderEditScreen> {
  late TextEditingController _nameController;
  final List<String> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.folder.name);
    _selectedItems.addAll(widget.folder.contentIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование папки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveFolder,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название папки',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Содержимое папки',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              _buildContentList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItemsToFolder,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContentList() {
    return switch (widget.folder.type) {
      FolderType.character => _buildCharacterList(),
      FolderType.race => _buildRaceList(),
      FolderType.note => _buildNoteList(),
      FolderType.template => _buildTemplateList(),
    };
  }

  Widget _buildCharacterList() {
    final characterBox = Hive.box<Character>('characters');
    final characters = _selectedItems
        .map((id) => characterBox.get(id))
        .whereType<Character>()
        .toList();

    if (characters.isEmpty) {
      return const Text('Папка пуста');
    }

    return Column(
      children: characters.map((character) => CharacterCard(
        character: character,
        isSelected: true,
        onTap: () => _removeFromFolder(character.key as String),
        onLongPress: () {},
        onMenuPressed: () {},
      )).toList(),
    );
  }

  Widget _buildRaceList() {
    final raceBox = Hive.box<Race>('races');
    final races = _selectedItems
        .map((id) => raceBox.get(id))
        .whereType<Race>()
        .toList();

    if (races.isEmpty) {
      return const Text('Папка пуста');
    }

    return Column(
      children: races.map((race) => RaceCard(
        race: race,
        onTap: () => _removeFromFolder(race.key as String),
        onLongPress: () {},
      )).toList(),
    );
  }

  Widget _buildNoteList() {
    final noteBox = Hive.box<Note>('notes');
    final notes = _selectedItems
        .map((id) => noteBox.get(id))
        .whereType<Note>()
        .toList();

    if (notes.isEmpty) {
      return const Text('Папка пуста');
    }

    return Column(
      children: notes.map((note) => NoteCard(
        note: note,
        onTap: () => _removeFromFolder(note.id),
        onEdit: () {},
        onDelete: () => _removeFromFolder(note.id),
      )).toList(),
    );
  }

  Widget _buildTemplateList() {
    final templateBox = Hive.box<QuestionnaireTemplate>('templates');
    final templates = _selectedItems
        .map((id) => templateBox.get(id))
        .whereType<QuestionnaireTemplate>()
        .toList();

    if (templates.isEmpty) {
      return const Text('Папка пуста');
    }

    return Column(
      children: templates.map((template) => ListTile(
        title: Text(template.name),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _removeFromFolder(template.key as String),
        ),
      )).toList(),
    );
  }


  Future<void> _addItemsToFolder() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildAddItemsSheet(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _selectedItems.addAll(result);
        _selectedItems.toSet().toList();
      });
    }
  }

  Widget _buildAddItemsSheet() {
    return switch (widget.folder.type) {
      FolderType.character => _buildAddCharactersSheet(),
      FolderType.race => _buildAddRacesSheet(),
      FolderType.note => _buildAddNotesSheet(),
      FolderType.template => _buildAddTemplatesSheet(),
    };
  }

  Widget _buildAddCharactersSheet() {
    final characterBox = Hive.box<Character>('characters');
    final allCharacters = characterBox.values.toList();
    final availableCharacters = allCharacters
        .where((c) => !_selectedItems.contains(c.key as String))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Text(
              'Добавить персонажей',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: availableCharacters.length,
                itemBuilder: (context, index) {
                  final character = availableCharacters[index];
                  return CheckboxListTile(
                    title: Text(character.name),
                    value: _selectedItems.contains(character.key as String),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedItems.add(character.key as String);
                        } else {
                          _selectedItems.remove(character.key as String);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            SaveButton(
              onPressed: () => Navigator.pop(context, _selectedItems),
              text: 'Добавить выбранное',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddRacesSheet() {
    final raceBox = Hive.box<Race>('races');
    final allRaces = raceBox.values.toList();
    final availableRaces = allRaces
        .where((r) => !_selectedItems.contains(r.key as String))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16))
        ),
        child: Column(
          children: [
            Text(
              'Добавить расы',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: availableRaces.length,
                itemBuilder: (context, index) {
                  final race = availableRaces[index];
                  return CheckboxListTile(
                    title: Text(race.name),
                    value: _selectedItems.contains(race.key as String),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedItems.add(race.key as String);
                        } else {
                          _selectedItems.remove(race.key as String);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            SaveButton(
              onPressed: () => Navigator.pop(context, _selectedItems),
              text: 'Добавить выбранное',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNotesSheet() {
    final noteBox = Hive.box<Note>('notes');
    final allNotes = noteBox.values.toList();
    final availableNotes = allNotes
        .where((n) => !_selectedItems.contains(n.key as String))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16))
        ),
        child: Column(
          children: [
            Text(
              'Добавить заметки',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: availableNotes.length,
                itemBuilder: (context, index) {
                  final note = availableNotes[index];
                  return CheckboxListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content.length > 50 
                        ? '${note.content.substring(0, 50)}...' 
                        : note.content),
                    value: _selectedItems.contains(note.key as String),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedItems.add(note.key as String);
                        } else {
                          _selectedItems.remove(note.key as String);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            SaveButton(
              onPressed: () => Navigator.pop(context, _selectedItems),
              text: 'Добавить выбранное',
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAddTemplatesSheet() {
    final templateBox = Hive.box<QuestionnaireTemplate>('templates');
    final allTemplates = templateBox.values.toList();
    final availableTemplates = allTemplates
        .where((t) => !_selectedItems.contains(t.key as String))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Text(
              'Добавить шаблоны',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: availableTemplates.length,
                itemBuilder: (context, index) {
                  final template = availableTemplates[index];
                  return CheckboxListTile(
                    title: Text(template.name),
                    subtitle: Text(
                      '${template.standardFields.length} стандартных, '
                      '${template.customFields.length} пользовательских полей',
                    ),
                    value: _selectedItems.contains(template.key as String),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedItems.add(template.key as String);
                        } else {
                          _selectedItems.remove(template.key as String);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            SaveButton(
              onPressed: () => Navigator.pop(context, _selectedItems),
              text: 'Добавить выбранное',
            ),
          ],
        ),
      ),
    );
  }

  void _removeFromFolder(String id) {
    setState(() {
      _selectedItems.remove(id);
    });
  }

  Future<void> _saveFolder() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название папки')),
      );
      return;
    }

    widget.folder.name = _nameController.text;
    widget.folder.contentIds = _selectedItems;
    widget.folder.updatedAt = DateTime.now();
    await widget.folder.save();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}