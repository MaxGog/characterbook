import 'package:flutter/material.dart';
import 'package:characterbook/data/models/custom_field_model.dart';
import 'package:characterbook/generated/l10n.dart';

class CustomFieldEditScreen extends StatefulWidget {
  final String initialKey;
  final String initialValue;

  const CustomFieldEditScreen({
    super.key,
    required this.initialKey,
    required this.initialValue,
  });

  @override
  State<CustomFieldEditScreen> createState() => _CustomFieldEditScreenState();
}

class _CustomFieldEditScreenState extends State<CustomFieldEditScreen> {
  late final TextEditingController _keyController;
  late final TextEditingController _valueController;
  late bool _isNewField;

  @override
  void initState() {
    super.initState();
    _isNewField = widget.initialKey.isEmpty;
    _keyController = TextEditingController(text: widget.initialKey);
    _valueController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _saveAndPop() {
    final result = CustomField(
      _keyController.text.trim(),
      _valueController.text.trim(),
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final autofocusKey = _isNewField;
    final autofocusValue = !_isNewField;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _saveAndPop();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: _saveAndPop,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
              title: TextField(
                controller: _keyController,
                autofocus: autofocusKey,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: s.field_name,
                ),
                cursorColor: theme.colorScheme.primary,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              scrolledUnderElevation: 1,
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: TextField(
                  controller: _valueController,
                  autofocus: autofocusValue,
                  minLines: null,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: s.field_value_hint,
                    hintStyle: const TextStyle(fontSize: 16),
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    fontSize: 16,
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
