import 'package:flutter/material.dart';
import 'package:characterbook/models/custom_field_model.dart';
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

  @override
  void initState() {
    super.initState();
    _fields = widget.initialFields.map((f) => f.copyWith()).toList();
  }

  void _addField() {
    setState(() {
      _fields.add(CustomField('', ''));
    });
    widget.onFieldsChanged(_fields);
  }

  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
    });
    widget.onFieldsChanged(_fields);
  }

  void _updateField(int index, String key, String value) {
    setState(() {
      _fields[index] = CustomField(key, value);
    });
    widget.onFieldsChanged(_fields);
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
        ..._fields.asMap().entries.map((entry) {
          final index = entry.key;
          final field = entry.value;
          return _buildVerticalFieldItem(index, field, s, theme);
        }).toList(),
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

  Widget _buildVerticalFieldItem(int index, CustomField field, S s, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
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
                  onChanged: (value) => _updateField(index, value, field.value),
                  controller: TextEditingController(text: field.key),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(
                  Icons.delete_rounded,
                  color: theme.colorScheme.error,
                ),
                onPressed: () => _removeField(index),
                tooltip: s.delete,
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
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
            ),
            onChanged: (value) => _updateField(index, field.key, value),
            controller: TextEditingController(text: field.value),
            maxLines: 3,
            minLines: 1,
          ),
        ],
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
              final field = entry.value;
              return _buildHorizontalFieldItem(index, field, s, theme);
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

  Widget _buildHorizontalFieldItem(int index, CustomField field, S s, ThemeData theme) {
    return Container(
      width: 280,
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
        children: [
          TextField(
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
            onChanged: (value) => _updateField(index, value, field.value),
            controller: TextEditingController(text: field.key),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TextField(
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
              ),
              onChanged: (value) => _updateField(index, field.key, value),
              controller: TextEditingController(text: field.value),
              maxLines: null,
              expands: true,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => _removeField(index),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_rounded,
                  size: 18,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  s.delete,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}