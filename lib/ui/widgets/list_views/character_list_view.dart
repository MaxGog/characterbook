import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/ui/widgets/items/character_card.dart';
import 'package:characterbook/ui/widgets/tag_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class CharacterListView extends StatefulWidget {
  final List<Character> allCharacters;
  final List<Character> charactersToShow;
  final List<String> tags;
  final TextEditingController searchController;
  final ScrollController scrollController;
  final bool isSearching;
  final String? selectedTag;
  final void Function(ScrollDirection)? onScroll;
  final Function(int, int) onReorder;
  final Function(Character) onCharacterTap;
  final Function(Character) onCharacterLongPress;
  final Function(String?) onTagSelected;
  final VoidCallback? onImportCharacter;
  final VoidCallback? onCreateCharacter;

  const CharacterListView({
    super.key,
    required this.allCharacters,
    required this.charactersToShow,
    required this.tags,
    required this.searchController,
    required this.isSearching,
    required this.selectedTag,
    required this.onReorder,
    required this.onCharacterTap,
    required this.onCharacterLongPress,
    required this.onTagSelected,
    required this.scrollController,
    required this.onScroll,
    this.onImportCharacter,
    this.onCreateCharacter
  });

  @override
  State<CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  bool _isDragging = false;

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        if (widget.tags.isNotEmpty)
          TagFilter(
            tags: widget.tags,
            selectedTag: widget.selectedTag,
            onTagSelected: widget.onTagSelected,
            allCharacters: widget.allCharacters,
          ),
        Expanded(
          child: _buildContent(theme),
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (widget.charactersToShow.isEmpty) {
      return _buildEmptyState(theme);
    }
    return _buildReorderableList();
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline, 
            size: 48, 
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          Text(
            widget.isSearching && widget.searchController.text.isNotEmpty
                ? S.of(context).empty_list 
                : S.of(context).empty_list,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (widget.onImportCharacter != null) _buildImportButton(theme),
          if (widget.onCreateCharacter != null) _buildCreateButton(theme),
        ],
      ),
    );
  }

  Widget _buildImportButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        onPressed: widget.onImportCharacter,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: Text(S.of(context).import_character),
      ),
    );
  }

  Widget _buildCreateButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top:16),
      child: ElevatedButton(
        onPressed: widget.onCreateCharacter, 
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: Text(S.of(context).create_character)
      )
    );
  }

  Widget _buildReorderableList() {
    return NotificationListener<UserScrollNotification>(
      onNotification: _handleScrollNotification,
      child: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        scrollController: widget.scrollController,
        itemCount: widget.charactersToShow.length,
        itemBuilder: (context, index) {
          final character = widget.charactersToShow[index];
          return _buildCharacterCard(character, index);
        },
        onReorderStart: _onReorderStart,
        onReorderEnd: _onReorderEnd,
        onReorder: widget.onReorder,
      ),
    );
  }

  bool _handleScrollNotification(UserScrollNotification notification) {
    widget.onScroll?.call(notification.direction);
    return false;
  }

  void _onReorderStart(int _) {
    HapticFeedback.lightImpact();
    setState(() => _isDragging = true);
  }

  void _onReorderEnd(_) => setState(() => _isDragging = false);

  Widget _buildCharacterCard(Character character, int index) {
    return LongPressDraggable<Character>(
      key: ValueKey(character.key),
      data: character,
      feedback: _buildCharacterCardFeedback(character),
      childWhenDragging: _buildCharacterCardWhenDragging(character),
      onDragStarted: _onDragStarted,
      onDragEnd: _onDragEnd,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onCharacterTap(character),
        onLongPress: () => widget.onCharacterLongPress(character),
        child: CharacterCard(
          key: ValueKey(character.key),
          character: character,
          isSelected: false,
          onTap: () => widget.onCharacterTap(character),
          onLongPress: () => widget.onCharacterLongPress(character),
          onMenuPressed: () => widget.onCharacterLongPress(character),
          enableDrag: true,
        ),
      ),
    );
  }

  Widget _buildCharacterCardFeedback(Character character) {
    return Material(
      child: CharacterCard(
        character: character,
        isSelected: false,
        onTap: () {},
        onLongPress: () {},
        onMenuPressed: () {},
        enableDrag: true,
      ),
    );
  }

  Widget _buildCharacterCardWhenDragging(Character character) {
    return Opacity(
      opacity: 0.5,
      child: CharacterCard(
        character: character,
        isSelected: false,
        onTap: () {},
        onLongPress: () {},
        onMenuPressed: () {},
        enableDrag: true,
      ),
    );
  }

  void _onDragStarted() {
    HapticFeedback.lightImpact();
    setState(() => _isDragging = true);
  }

  void _onDragEnd(_) => setState(() => _isDragging = false);
}