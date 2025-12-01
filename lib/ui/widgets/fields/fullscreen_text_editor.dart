import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../appbar/common_app_bar.dart';

class FullscreenTextEditor extends StatefulWidget {
  final String title;
  final String initialValue;
  final ValueChanged<String>? onChanged;
  final bool isRequired;

  const FullscreenTextEditor({
    super.key,
    required this.title,
    required this.initialValue,
    this.onChanged,
    this.isRequired = false,
  });

  @override
  State<FullscreenTextEditor> createState() => _FullscreenTextEditorState();
}

class _FullscreenTextEditorState extends State<FullscreenTextEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar.edit(
        title: widget.title,
        onSave: () {
          if (widget.onChanged != null) {
            widget.onChanged!(_controller.text);
          }
          Navigator.pop(context);
        },
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: _controller,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.of(context).start_writing,
            hintStyle: const TextStyle(fontSize: 16),
            contentPadding: EdgeInsets.zero,
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                height: 1.5,
              ),
        ),
      ),
    );
  }
}
