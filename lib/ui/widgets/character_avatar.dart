import 'package:characterbook/models/character_model.dart';
import 'package:flutter/material.dart';

class CharacterAvatar extends StatelessWidget {
  final Character character;
  final double size;

  const CharacterAvatar({
    super.key,
    required this.character,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return character.imageBytes != null
        ? CircleAvatar(
            backgroundImage: MemoryImage(character.imageBytes!),
            radius: size,
          )
        : CircleAvatar(
            radius: size,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.person,
              size: size * 0.7,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          );
  }
}
