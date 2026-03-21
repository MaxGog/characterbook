import 'package:characterbook/models/character_model.dart';
import 'package:flutter/material.dart';
import 'package:characterbook/models/relationship_model.dart';
import 'package:characterbook/repositories/character_repository.dart';
import 'package:characterbook/services/relationship_service.dart';
import 'package:characterbook/ui/dialogs/edit_relationship_dialog.dart';
import 'package:provider/provider.dart';

class RelationshipsScreen extends StatelessWidget {
  const RelationshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characterRepo = Provider.of<CharacterRepository>(context);
    final relationshipService = Provider.of<RelationshipService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Relationships')),
      body: StreamBuilder<List<Character>>(
        stream: characterRepo.watchAll(),
        builder: (context, charSnapshot) {
          if (!charSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final characters = charSnapshot.data!;
          final Map<String, Character> characterMap = {
            for (var c in characters) c.id: c
          };

          return StreamBuilder<List<Relationship>>(
            stream: relationshipService.watchAll(),
            builder: (context, relSnapshot) {
              if (!relSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final relationships = relSnapshot.data!;

              if (relationships.isEmpty) {
                return const Center(
                  child: Text('No relationships yet. Add one!'),
                );
              }

              return ListView.builder(
                itemCount: relationships.length,
                itemBuilder: (context, index) {
                  final rel = relationships[index];
                  final char1 = characterMap[rel.character1Id];
                  final char2 = characterMap[rel.character2Id];
                  final name1 = char1?.name ?? 'Unknown';
                  final name2 = char2?.name ?? 'Unknown';

                  return ListTile(
                    title: Text(rel.name),
                    subtitle: Text('$name1 ↔ $name2'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          relationshipService.deleteRelationship(rel),
                    ),
                    onTap: () => _editRelationship(context, rel),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addRelationship(context),
      ),
    );
  }

  void _addRelationship(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const EditRelationshipDialog(),
    );
  }

  void _editRelationship(BuildContext context, Relationship rel) {
    showDialog(
      context: context,
      builder: (_) => EditRelationshipDialog(relationship: rel),
    );
  }
}
