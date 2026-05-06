import 'dart:async';
import 'package:flutter/material.dart';
import 'package:characterbook/generated/l10n.dart';

class FieldEditorResult {
  final String key;
  final String value;
  const FieldEditorResult(this.key, this.value);
}

class FieldEditorScreen extends StatefulWidget {
  final String title;
  final String initialKey;
  final String initialValue;
  final bool isTitleEditable;

  final ValueChanged<FieldEditorResult>? onAutoSave;

  const FieldEditorScreen({
    super.key,
    required this.title,
    required this.initialKey,
    required this.initialValue,
    this.isTitleEditable = false,
    this.onAutoSave,
  });

  @override
  State<FieldEditorScreen> createState() => _FieldEditorScreenState();
}

class _FieldEditorScreenState extends State<FieldEditorScreen> {
  late final TextEditingController _keyController;
  late final TextEditingController _valueController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.initialKey);
    _valueController = TextEditingController(text: widget.initialValue);
    _keyController.addListener(_onFieldChanged);
    _valueController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _keyController.removeListener(_onFieldChanged);
    _valueController.removeListener(_onFieldChanged);
    _keyController.dispose();
    _valueController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onFieldChanged() {
    if (widget.onAutoSave == null) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onAutoSave!(FieldEditorResult(
        _keyController.text.trim(),
        _valueController.text.trim(),
      ));
    });
  }

  void _popWithResult() {
    final result = FieldEditorResult(
      _keyController.text.trim(),
      _valueController.text.trim(),
    );
    widget.onAutoSave?.call(result);
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNewField = widget.initialKey.isEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _popWithResult();
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: _popWithResult,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
              title: widget.isTitleEditable
                  ? TextField(
                      controller: _keyController,
                      autofocus: isNewField,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: S.of(context).field_name,
                      ),
                      cursorColor: theme.colorScheme.primary,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    )
                  : Text(widget.title),
              pinned: true,
              floating: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverFillRemaining(
                hasScrollBody: true,
                child: TextField(
                  controller: _valueController,
                  autofocus: !widget.isTitleEditable || !isNewField,
                  minLines: null,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: S.of(context).start_writing,
                    hintStyle: const TextStyle(fontSize: 16),
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
