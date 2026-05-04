import 'package:characterbook/data/models/folder_model.dart';
import 'package:characterbook/data/repositories/folder_repository.dart';

class FolderService {
  final FolderRepository _repository;

  FolderService(this._repository);

  Future<bool> moveFolder(String folderId, String? newParentId) async {
    if (newParentId != null) {
      bool isChild = await _isChildFolder(folderId, newParentId);
      if (isChild) {
        throw Exception('Cannot move folder into its own child');
      }
    }

    final folder = await _repository.getById(folderId);
    if (folder != null) {
      final updatedFolder = folder.copyWith(parentId: newParentId);
      await _repository.save(updatedFolder);
      return true;
    }
    return false;
  }

  Future<bool> _isChildFolder(String sourceId, String targetId) async {
    if (sourceId == targetId) return true;

    final targetFolder = await _repository.getById(targetId);
    if (targetFolder?.parentId == null) return false;

    return _isChildFolder(sourceId, targetFolder!.parentId!);
  }

  Future<List<Folder>> getFolderPath(String folderId) async {
    final path = <Folder>[];
    String? currentId = folderId;

    while (currentId != null) {
      final folder = await _repository.getById(currentId);
      if (folder == null) break;
      path.insert(0, folder);
      currentId = folder.parentId;
    }

    return path;
  }
}
