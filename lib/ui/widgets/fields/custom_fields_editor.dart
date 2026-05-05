import 'package:flutter/material.dart';
import 'package:characterbook/data/models/custom_field_model.dart';
import 'package:characterbook/generated/l10n.dart';

class CustomFieldsEditor extends StatefulWidget {
  final List<CustomField> initialFields;
  final ValueChanged<List<CustomField>> onFieldsChanged;
  final bool verticalLayout;

  const CustomFieldsEditor({
    super.key,
    required this.initialFields,
    required this.onFieldsChanged,
    this.verticalLayout = false,
  });

  @override
  State<CustomFieldsEditor> createState() => _CustomFieldsEditorState();
}

class _CustomFieldsEditorState extends State<CustomFieldsEditor> {
  late List<CustomField> _fields;
  late List<TextEditingController> _keyControllers;
  late List<TextEditingController> _valueControllers;

  @override
  void initState() {
    super.initState();
    _fields = widget.initialFields.map((f) => f.copyWith()).toList();
    _initializeControllers();
  }

  void _initializeControllers() {
    _keyControllers = _fields.map((field) {
      final controller = TextEditingController(text: field.key);
      controller.addListener(() {
        final index = _keyControllers.indexOf(controller);
        if (index != -1) {
          _updateField(index, controller.text, _valueControllers[index].text);
        }
      });
      return controller;
    }).toList();

    _valueControllers = _fields.map((field) {
      final controller = TextEditingController(text: field.value);
      controller.addListener(() {
        final index = _valueControllers.indexOf(controller);
        if (index != -1) {
          _updateField(index, _keyControllers[index].text, controller.text);
        }
      });
      return controller;
    }).toList();
  }

  void _addField() {
    setState(() {
      final newField = CustomField('', '');
      _fields.add(newField);

      final keyController = TextEditingController();
      keyController.addListener(() {
        final index = _keyControllers.indexOf(keyController);
        if (index != -1) {
          _updateField(
              index, keyController.text, _valueControllers[index].text);
        }
      });
      _keyControllers.add(keyController);

      final valueController = TextEditingController();
      valueController.addListener(() {
        final index = _valueControllers.indexOf(valueController);
        if (index != -1) {
          _updateField(
              index, _keyControllers[index].text, valueController.text);
        }
      });
      _valueControllers.add(valueController);
    });
    widget.onFieldsChanged(_fields);
  }

  void _removeField(int index) {
    final removedField = _fields[index];
    final removedKeyController = _keyControllers[index];
    final removedValueController = _valueControllers[index];

    setState(() {
      _fields.removeAt(index);
      _keyControllers.removeAt(index);
      _valueControllers.removeAt(index);
    });
    widget.onFieldsChanged(_fields);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("S.of(context).field_removed"),
        action: SnackBarAction(
          label: "S.of(context).undo",
          onPressed: () {
            setState(() {
              _fields.insert(index, removedField);
              _keyControllers.insert(index, removedKeyController);
              _valueControllers.insert(index, removedValueController);
            });
            widget.onFieldsChanged(_fields);
          },
        ),
      ),
    );
  }

  void _updateField(int index, String key, String value) {
    setState(() {
      _fields[index] = CustomField(key, value);
    });
    widget.onFieldsChanged(_fields);
  }

  @override
  void dispose() {
    for (final controller in _keyControllers) {
      controller.dispose();
    }
    for (final controller in _valueControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    if (widget.verticalLayout) {
      return _buildVerticalLayout(s, theme);
    } else {
      return _buildHorizontalLayout(s, theme);
    }
  }

  Widget _buildVerticalLayout(S s, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                s.custom_fields_editor_title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonalIcon(
              onPressed: _addField,
              icon: const Icon(Icons.add_rounded),
              label: Text(s.add_field),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (_fields.isNotEmpty)
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _fields.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final field = _fields.removeAt(oldIndex);
                _fields.insert(newIndex, field);
                final keyCtrl = _keyControllers.removeAt(oldIndex);
                _keyControllers.insert(newIndex, keyCtrl);
                final valCtrl = _valueControllers.removeAt(oldIndex);
                _valueControllers.insert(newIndex, valCtrl);
              });
              widget.onFieldsChanged(_fields);
            },
            itemBuilder: (context, index) {
              return _buildVerticalFieldItem(index, s, theme);
            },
          ),
        if (_fields.isEmpty)
          Column(
            children: [
              Icon(Icons.notes_rounded,
                  size: 48, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(
                s.no_custom_fields,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildVerticalFieldItem(int index, S s, ThemeData theme) {
    return ReorderableDragStartListener(
      index: index,
      key: ValueKey(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _keyControllers[index],
                    decoration: InputDecoration(
                      labelText: s.field_name,
                      hintText: s.field_name_hint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(Icons.delete_rounded,
                      color: theme.colorScheme.error),
                  onPressed: () => _removeField(index),
                  tooltip: s.delete,
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.errorContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 60, maxHeight: 200),
              child: TextField(
                controller: _valueControllers[index],
                decoration: InputDecoration(
                  labelText: s.field_value,
                  hintText: s.field_value_hint,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalLayout(S s, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                s.custom_fields,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonalIcon(
              onPressed: _addField,
              icon: const Icon(Icons.add_rounded),
              label: Text(s.add_field),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _fields.asMap().entries.map((entry) {
              final index = entry.key;
              return _buildHorizontalFieldItem(index, s, theme);
            }).toList(),
          ),
        ),
        if (_fields.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.notes_rounded,
                  size: 48,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  s.no_custom_fields,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildHorizontalFieldItem(int index, S s, ThemeData theme) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _keyControllers[index],
            decoration: InputDecoration(
              labelText: s.field_name,
              hintText: s.field_name_hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 120,
              maxHeight: 200,
            ),
            child: TextField(
              controller: _valueControllers[index],
              decoration: InputDecoration(
                labelText: s.field_value,
                hintText: s.field_value_hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                alignLabelWithHint: true,
              ),
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => _removeField(index),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.error,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_rounded,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(s.delete),
              ],
            ),
          ),
        ],
      ),
    );
  }
}