import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/material.dart';

class TagFilter extends StatelessWidget {
  final List<String> tags;
  final String? selectedTag;
  final ValueChanged<String?> onTagSelected;
  final BuildContext context;
  final bool showAllOption;
  final bool isForCharacters;

  const TagFilter({
    super.key,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
    required this.context,
    this.showAllOption = true,
    this.isForCharacters = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final standardTags = isForCharacters 
        ? [
            s.male, s.female, s.another,
            s.children, s.young, s.adults, s.elderly,
            s.short_name,
            s.a_to_z, s.z_to_a, s.age_asc, s.age_desc
          ]
        : [];

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          if (showAllOption)
            FilterChip(
              label: Text(s.all),
              selected: selectedTag == null,
              onSelected: (_) => onTagSelected(null),
              shape: StadiumBorder(side: BorderSide(color: theme.colorScheme.outline)),
              showCheckmark: false,
              selectedColor: theme.colorScheme.secondaryContainer,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color: selectedTag == null
                    ? theme.colorScheme.onSecondaryContainer
                    : theme.colorScheme.onSurface,
              ),
            ),
          ...tags.map((tag) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(tag),
              selected: selectedTag == tag,
              onSelected: (selected) => onTagSelected(selected ? tag : null),
              shape: StadiumBorder(side: BorderSide(color: theme.colorScheme.outline)),
              showCheckmark: false,
              selectedColor: standardTags.contains(tag)
                  ? theme.colorScheme.tertiaryContainer
                  : theme.colorScheme.secondaryContainer,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color: selectedTag == tag
                    ? standardTags.contains(tag)
                        ? theme.colorScheme.onTertiaryContainer
                        : theme.colorScheme.onSecondaryContainer
                    : theme.colorScheme.onSurface,
              ),
            ),
          )),
        ],
      ),
    );
  }
}