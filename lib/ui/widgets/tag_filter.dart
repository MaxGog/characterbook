import 'package:characterbook/models/character_model.dart';
import 'package:flutter/material.dart';

class TagFilter extends StatelessWidget {
  final List<String> tags;
  final String? selectedTag;
  final ValueChanged<String?> onTagSelected;
  final List<Character> allCharacters;

  const TagFilter({
    super.key,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
    required this.allCharacters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(tag),
              selected: selectedTag == tag,
              onSelected: (selected) => onTagSelected(selected ? tag : null),
              shape: StadiumBorder(side: BorderSide(color: theme.colorScheme.outline)),
              showCheckmark: false,
              selectedColor: theme.colorScheme.secondaryContainer,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color: selectedTag == tag
                    ? theme.colorScheme.onSecondaryContainer
                    : theme.colorScheme.onSurface,
              ),
            ),
          );
        },
      ),
    );
  }
}