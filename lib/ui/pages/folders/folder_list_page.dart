import 'package:characterbook/ui/pages/folders/folder_content_page.dart';
import 'package:flutter/material.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/ui/widgets/custom_app_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FoldersScreen extends StatefulWidget {
  final FolderType folderType;

  const FoldersScreen({super.key, required this.folderType});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  late Box<Folder> _folderBox;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _folderBox = Hive.box<Folder>('folders');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: _getTitle(),
        isSearching: _isSearching,
        searchController: _searchController,
        onSearchToggle: _toggleSearch,
        onSearchChanged: _onSearchChanged,
      ),
      body: ValueListenableBuilder(
        valueListenable: _folderBox.listenable(),
        builder: (context, box, _) {
          final folders = _getFilteredFolders();
          
          if (folders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getFolderIcon(widget.folderType),
                    size: 48,
                    color: colorScheme.onSurface,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет папок',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Нажмите + чтобы создать новую папку',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: folders.length,
            itemBuilder: (context, index) {
              final folder = folders[index];
              return _buildFolderItem(folder, colorScheme, textTheme);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewFolder,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getTitle() {
    return switch (widget.folderType) {
      FolderType.character => 'Персонажи',
      FolderType.race => 'Расы',
      FolderType.note => 'Заметки',
      FolderType.template => 'Шаблоны',
    };
  }

  List<Folder> _getFilteredFolders() {
    return _folderBox.values
        .where((folder) => 
          folder.type == widget.folderType &&
          (folder.parentId == null || folder.parentId!.isEmpty) &&
          (_searchQuery.isEmpty || 
           folder.name.toLowerCase().contains(_searchQuery.toLowerCase())))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Widget _buildFolderItem(Folder folder, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getFolderIcon(folder.type),
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          folder.name,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${folder.contentIds.length} ${_getContentLabel(folder.contentIds.length)}',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () => _showFolderMenu(folder),
        ),
        onExpansionChanged: (expanded) {},
        children: [
          ..._buildSubfolders(folder, colorScheme, textTheme),
          ..._buildFolderActions(folder, colorScheme),
        ],
      ),
    );
  }

  String _getContentLabel(int count) {
    if (count % 10 == 1 && count % 100 != 11) return 'элемент';
    if (count % 10 >= 2 && count % 10 <= 4 && (count % 100 < 10 || count % 100 >= 20)) {
      return 'элемента';
    }
    return 'элементов';
  }

  List<Widget> _buildSubfolders(Folder parentFolder, ColorScheme colorScheme, TextTheme textTheme) {
    final subfolders = _folderBox.values
        .where((folder) => folder.parentId == parentFolder.id)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return subfolders
        .map((folder) => ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getFolderIcon(folder.type),
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              title: Text(
                folder.name,
                style: textTheme.bodyLarge,
              ),
              subtitle: Text(
                '${folder.contentIds.length} ${_getContentLabel(folder.contentIds.length)}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: colorScheme.onSurfaceVariant,
                ),
                onPressed: () => _showFolderMenu(folder),
              ),
              onTap: () => _openFolder(folder),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ))
        .toList();
  }

  List<Widget> _buildFolderActions(Folder folder, ColorScheme colorScheme) {
    return [
      const Divider(height: 1),
      ListTile(
        leading: Icon(
          Icons.edit_outlined,
          color: colorScheme.onSurfaceVariant,
        ),
        title: Text(
          'Редактировать',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        onTap: () => _editFolder(folder),
      ),
      ListTile(
        leading: Icon(
          Icons.create_new_folder_outlined,
          color: colorScheme.onSurfaceVariant,
        ),
        title: Text(
          'Создать подпапку',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        onTap: () => _createSubfolder(folder),
      ),
      ListTile(
        leading: Icon(
          Icons.delete_outline,
          color: colorScheme.error,
        ),
        title: Text(
          'Удалить',
          style: TextStyle(color: colorScheme.error),
        ),
        onTap: () => _deleteFolder(folder),
      ),
    ];
  }

  IconData _getFolderIcon(FolderType type) {
    return switch (type) {
      FolderType.character => Icons.person_outline,
      FolderType.race => Icons.people_outline,
      FolderType.note => Icons.note_outlined,
      FolderType.template => Icons.library_books_outlined,
    };
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _createNewFolder() {
    _showFolderDialog(null);
  }

  void _createSubfolder(Folder parent) {
    _showFolderDialog(parent);
  }

  void _editFolder(Folder folder) {
    _showFolderDialog(folder);
  }

  void _showFolderDialog(Folder? folder, {Folder? parentFolder}) {
    final colorScheme = Theme.of(context).colorScheme;
    final controller = TextEditingController(text: folder?.name ?? '');
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
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
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              folder == null ? 'Новая папка' : 'Редактировать папку',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Название папки',
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
                      child: const Text('Отмена'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          _saveFolder(folder, controller.text, parentFolder);
                          Navigator.pop(context);
                        }
                      },
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Сохранить'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _saveFolder(Folder? folder, String name, Folder? parentFolder) async {
    if (folder == null) {
      final newFolder = Folder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        type: widget.folderType,
        parentId: parentFolder?.id,
      );
      await _folderBox.put(newFolder.id, newFolder);
    } else {
      folder.name = name;
      folder.updatedAt = DateTime.now();
      await folder.save();
    }
  }

  void _deleteFolder(Folder folder) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Удалить папку?',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Text(
          'Вы уверены, что хотите удалить папку "${folder.name}"?',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () async {
              await folder.delete();
              if (mounted) Navigator.pop(context);
            },
            child: Text(
              'Удалить',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _openFolder(Folder folder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FolderContentsScreen(folder: folder),
      ),
    );
  }

  void _showFolderMenu(Folder folder) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.open_in_new,
                color: colorScheme.onSurfaceVariant,
              ),
              title: Text(
                'Открыть',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(context);
                _openFolder(folder);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.edit_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
              title: Text(
                'Редактировать',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(context);
                _editFolder(folder);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.create_new_folder_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
              title: Text(
                'Создать подпапку',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(context);
                _createSubfolder(folder);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: colorScheme.error,
              ),
              title: Text(
                'Удалить',
                style: TextStyle(color: colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteFolder(folder);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}