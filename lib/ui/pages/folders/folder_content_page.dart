import 'package:characterbook/models/template_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/ui/widgets/items/character_card.dart';
import 'package:characterbook/ui/widgets/items/note_card.dart';
import 'package:characterbook/ui/widgets/items/race_card.dart';

class FolderContentsScreen extends StatefulWidget {
  final Folder folder;

  const FolderContentsScreen({super.key, required this.folder});

  @override
  State<FolderContentsScreen> createState() => _FolderContentsScreenState();
}

class _FolderContentsScreenState extends State<FolderContentsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showDebugInfo,
          ),
        ],
      ),
      body: _buildContentList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDebugInfo,
        backgroundColor: colorScheme.primaryContainer,
        child: const Icon(Icons.bug_report),
      ),
    );
  }

  void _showDebugInfo() {
    final characterBox = Hive.box<Character>('characters');
    final raceBox = Hive.box<Race>('races');
    final noteBox = Hive.box<Note>('notes');
    final templateBox = Hive.box<QuestionnaireTemplate>('templates');
    
    final debugInfo = '''
Folder ID: ${widget.folder.id}
Folder Type: ${widget.folder.type}
Content IDs: ${widget.folder.contentIds}

Character Box Count: ${characterBox.length}
Race Box Count: ${raceBox.length}
Note Box Count: ${noteBox.length}
Template Box Count: ${templateBox.length}

Matched Characters: ${
  widget.folder.contentIds.map((id) => characterBox.get(id)).whereType<Character>().length
}
Matched Races: ${
  widget.folder.contentIds.map((id) => raceBox.get(id)).whereType<Race>().length
}
Matched Notes: ${
  widget.folder.contentIds.map((id) => noteBox.get(id)).whereType<Note>().length
}
Matched Templates: ${
  widget.folder.contentIds.map((id) => templateBox.get(id)).whereType<QuestionnaireTemplate>().length
}
''';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Information'),
        content: SingleChildScrollView(
          child: Text(debugInfo),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
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
    final characters = widget.folder.contentIds
        .map((id) => characterBox.get(id))
        .whereType<Character>()
        .toList();

    if (characters.isEmpty) {
      return _buildEmptyState('Персонажи не найдены');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CharacterCard(
            character: character,
            isSelected: false,
            onTap: () => _openCharacter(character),
            onLongPress: () {},
            onMenuPressed: () {},
          ),
        );
      },
    );
  }

  Widget _buildRaceList() {
    final raceBox = Hive.box<Race>('races');
    final races = widget.folder.contentIds
        .map((id) => raceBox.get(id))
        .whereType<Race>()
        .toList();

    if (races.isEmpty) {
      return _buildEmptyState('Расы не найдены');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: races.length,
      itemBuilder: (context, index) {
        final race = races[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RaceCard(
            race: race,
            onTap: () => _openRace(race),
            onLongPress: () {},
          ),
        );
      },
    );
  }

  Widget _buildNoteList() {
    final noteBox = Hive.box<Note>('notes');
    final notes = widget.folder.contentIds
        .map((id) => noteBox.get(id))
        .whereType<Note>()
        .toList();

    if (notes.isEmpty) {
      return _buildEmptyState('Заметки не найдены');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NoteCard(
            note: note,
            onTap: () => _openNote(note),
            onEdit: () {},
            onDelete: () {},
          ),
        );
      },
    );
  }

  Widget _buildTemplateList() {
    final templateBox = Hive.box<QuestionnaireTemplate>('templates');
    final templates = widget.folder.contentIds
        .map((id) => templateBox.get(id))
        .whereType<QuestionnaireTemplate>()
        .toList();

    if (templates.isEmpty) {
      return _buildEmptyState('Шаблоны не найдены');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(template.name),
            subtitle: Text(
              '${template.standardFields.length} стандартных, '
              '${template.customFields.length} пользовательских полей',
            ),
            onTap: () => _openTemplate(template),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 48,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _openCharacter(Character character) {
    // Реализуйте открытие персонажа
    debugPrint('Opening character: ${character.name}');
  }

  void _openRace(Race race) {
    // Реализуйте открытие расы
    debugPrint('Opening race: ${race.name}');
  }

  void _openNote(Note note) {
    // Реализуйте открытие заметки
    debugPrint('Opening note: ${note.title}');
  }

  void _openTemplate(QuestionnaireTemplate template) {
    // Реализуйте открытие шаблона
    debugPrint('Opening template: ${template.name}');
  }
}