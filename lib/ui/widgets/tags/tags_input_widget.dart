import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/material.dart';

class TagsInputWidget extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onTagsChanged;

  const TagsInputWidget({
    super.key,
    required this.tags,
    required this.onTagsChanged,
  });

  @override
  State<TagsInputWidget> createState() => _TagsInputWidgetState();
}

class _TagsInputWidgetState extends State<TagsInputWidget> {
  final TextEditingController _tagController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<String> _currentTags;

  @override
  void initState() {
    super.initState();
    _currentTags = List.from(widget.tags);
  }

  @override
  void didUpdateWidget(TagsInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tags != widget.tags) {
      _currentTags = List.from(widget.tags);
    }
  }

  @override
  void dispose() {
    _tagController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !_currentTags.contains(trimmedTag)) {
      setState(() {
        _currentTags.add(trimmedTag);
      });
      widget.onTagsChanged(List.from(_currentTags));
      _tagController.clear();
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _currentTags.remove(tag);
    });
    widget.onTagsChanged(List.from(_currentTags));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InputDecorator(
          decoration: InputDecoration(
            labelText: S.of(context).tags,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ..._currentTags.map((tag) => InputChip(
                label: Text(tag),
                onDeleted: () => _removeTag(tag),
                deleteIcon: const Icon(Icons.close, size: 16),
                side: BorderSide.none,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: theme.colorScheme.outline,
                  ),
                ),
              )),
              SizedBox(
                width: _currentTags.isNotEmpty ? null : double.infinity,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: _currentTags.isNotEmpty ? 120 : double.infinity,
                  ),
                  child: TextField(
                    controller: _tagController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: S.of(context).add_tag,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    style: theme.textTheme.bodyMedium,
                    onSubmitted: _addTag,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}