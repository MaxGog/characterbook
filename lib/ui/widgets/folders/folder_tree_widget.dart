import 'package:flutter/material.dart';
import 'package:characterbook/data/models/folder_model.dart';

class FolderTreeWidget extends StatelessWidget {
  final List<Folder> folders;
  final Function(Folder) onFolderTap;

  const FolderTreeWidget({
    Key? key,
    required this.folders,
    required this.onFolderTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rootFolders = folders.where((f) => f.parentId == null).toList();

    return ListView.builder(
      itemCount: rootFolders.length,
      itemBuilder: (context, index) {
        return _buildFolderNode(rootFolders[index]);
      },
    );
  }

  Widget _buildFolderNode(Folder folder) {
    final children = folders.where((f) => f.parentId == folder.id).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.folder, color: folder.color),
          title: Text(folder.name),
          trailing: Text('${folder.contentIds.length}'),
          onTap: () => onFolderTap(folder),
        ),
        if (children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: FolderTreeWidget(
              folders: children,
              onFolderTap: onFolderTap,
            ),
          ),
      ],
    );
  }
}
