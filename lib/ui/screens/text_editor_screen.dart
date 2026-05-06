import 'dart:async';
import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/material.dart';

class TextEditorScreen extends StatefulWidget {
  final String title;
  final String initialValue;
  final ValueChanged<String>? onChanged;
  final bool isRequired;

  const TextEditorScreen({
    super.key,
    required this.title,
    required this.initialValue,
    this.onChanged,
    this.isRequired = false,
  });

  @override
  State<TextEditorScreen> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  late final TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.onChanged == null) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged!(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(widget.title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            pinned: true,
            floating: true,
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Padding(
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
          ),
        ],
      ),
    );
  }
}
