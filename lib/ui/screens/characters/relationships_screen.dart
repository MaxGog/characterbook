import 'package:flutter/material.dart';
import 'package:characterbook/data/models/character_model.dart';
import 'package:characterbook/data/models/relationship_model.dart';
import 'package:characterbook/data/repositories/character_repository.dart';
import 'package:characterbook/data/services/relationship_service.dart';
import 'package:characterbook/ui/widgets/edit_relationship_bottom_sheet.dart';
import 'package:provider/provider.dart';

class RelationshipsScreen extends StatelessWidget {
  const RelationshipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characterRepo = Provider.of<CharacterRepository>(context);
    final relationshipService = Provider.of<RelationshipService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Связи персонажей'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Character>>(
        stream: characterRepo.watchAll(),
        builder: (context, charSnapshot) {
          if (!charSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final characters = charSnapshot.data!;
          final characterMap = {for (var c in characters) c.id: c};

          return StreamBuilder<List<Relationship>>(
            stream: relationshipService.watchAll(),
            builder: (context, relSnapshot) {
              if (!relSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final relationships = relSnapshot.data!;

              if (relationships.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Theme.of(context).disabledColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Пока нет ни одной связи',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Нажмите на кнопку +, чтобы добавить',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                itemCount: relationships.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final rel = relationships[index];
                  final char1 = characterMap[rel.character1Id];
                  final char2 = characterMap[rel.character2Id];
                  final name1 = char1?.name ?? 'Неизвестный';
                  final name2 = char2?.name ?? 'Неизвестный';

                  return Dismissible(
                    key: Key(rel.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (_) async {
                      return await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Удалить связь?'),
                          content: Text(
                              'Вы уверены, что хотите удалить «${rel.name}»?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Отмена'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.red),
                              child: const Text('Удалить'),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (_) =>
                        relationshipService.deleteRelationship(rel),
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: SizedBox(
                          width: 56,
                          child: _buildCharacterPairAvatar(char1, char2),
                        ),
                        title: Text(
                          rel.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle:
                            Text('$name1 ${rel.directed ? '→' : '↔'} $name2'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _editRelationship(context, rel),
                          tooltip: 'Редактировать',
                        ),
                        onTap: () => _editRelationship(context, rel),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addRelationship(context),
        icon: const Icon(Icons.add),
        label: const Text('Добавить связь'),
      ),
    );
  }

  Widget _buildCharacterPairAvatar(Character? char1, Character? char2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAvatar(char1, radius: 12),
        const SizedBox(width: 4),
        _buildAvatar(char2, radius: 12),
      ],
    );
  }

  Widget _buildAvatar(Character? character, {double radius = 20}) {
    final hasAvatar = character?.imageBytes != null;
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: hasAvatar ? MemoryImage(character!.imageBytes!) : null,
      child: !hasAvatar && character != null
          ? Text(
              character.name.isNotEmpty ? character.name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: radius * 0.8,
                fontWeight: FontWeight.bold,
              ),
            )
          : (character == null
              ? Text(
                  '?',
                  style: TextStyle(fontSize: radius * 0.8),
                )
              : null),
    );
  }

  void _addRelationship(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditRelationshipBottomSheet(),
    );
  }

  void _editRelationship(BuildContext context, Relationship rel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditRelationshipBottomSheet(relationship: rel),
    );
  }
}
