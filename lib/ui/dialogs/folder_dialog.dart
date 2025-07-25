import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:flutter/material.dart';

class FolderDialog extends StatefulWidget {
  final Folder? folder;
  final Folder? parentFolder;
  final FolderType folderType;
  final Function(Folder?, String, Folder?, int) onSave;

  const FolderDialog({
    super.key,
    this.folder,
    this.parentFolder,
    required this.folderType,
    required this.onSave,
  });

  @override
  State<FolderDialog> createState() => _FolderDialogState();
}

class _FolderDialogState extends State<FolderDialog> {
  late TextEditingController _controller;
  late int _selectedColor;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.folder?.name ?? '');
     _selectedColor = widget.folder?.colorValue ?? colorOptions[0]['color'] as int;
  }

   static const List<Map<String, dynamic>> colorOptions = [
    {'color': 0xFF6750A4, 'name': 'Purple'},
    {'color': 0xFF006C51, 'name': 'Teal'},
    {'color': 0xFFB3261E, 'name': 'Red'},
    {'color': 0xFF7D5260, 'name': 'Pink'},
    {'color': 0xFF1D192B, 'name': 'Dark'},
    {'color': 0xFF006E2C, 'name': 'Green'},
    {'color': 0xFF00639C, 'name': 'Blue'},
    {'color': 0xFF825500, 'name': 'Brown'},
    {'color': 0xFF7E2D00, 'name': 'Orange'},
    {'color': 0xFF5C5C5C, 'name': 'Grey'},
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.folder == null ? s.new_folder : s.edit_folder,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: s.folder_name,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              autofocus: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.folder_color,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: colorOptions.length,
                  itemBuilder: (context, index) {
                    final color = colorOptions[index]['color'] as int;
                    final colorName = colorOptions[index]['name'] as String;
                    
                    return Tooltip(
                      message: colorName,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: Color(color),
                            shape: BoxShape.circle,
                            boxShadow: _selectedColor == color
                                ? [
                                    BoxShadow(
                                      color: Color(color).withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : null,
                          ),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 200),
                            scale: _selectedColor == color ? 1.1 : 1.0,
                            child: Center(
                              child: _selectedColor == color
                                  ? Icon(
                                      Icons.check,
                                      color: ThemeData.estimateBrightnessForColor(Color(color)) == Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      size: 20,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                if (_selectedColor != 0)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: 1.0,
                    child: Text(
                      colorOptions.firstWhere(
                        (c) => c['color'] == _selectedColor,
                        orElse: () => colorOptions[0],
                      )['name'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.onSurface,
                      side: BorderSide(color: colorScheme.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(s.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        widget.onSave(
                          widget.folder,
                          _controller.text,
                          widget.parentFolder,
                          _selectedColor,
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Color(_selectedColor),
                      foregroundColor: ThemeData.estimateBrightnessForColor(Color(_selectedColor)) == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    child: Text(s.save),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}