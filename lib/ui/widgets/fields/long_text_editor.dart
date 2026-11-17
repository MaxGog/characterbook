import 'package:flutter/material.dart';

class LongTextEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool autofocus;
  final bool expands;
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  const LongTextEditor({
    super.key,
    required this.controller,
    required this.hintText,
    this.autofocus = false,
    this.expands = false,
    this.contextMenuBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      autofocus: autofocus,
      minLines: null,
      maxLines: null,
      expands: expands,
      textAlignVertical: TextAlignVertical.top,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 16),
        contentPadding: EdgeInsets.zero,
      ),
      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
      contextMenuBuilder: contextMenuBuilder,
    );
  }
}
