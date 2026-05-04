import 'package:characterbook/data/models/folder_model.dart';
import 'package:characterbook/data/repositories/folder_repository.dart';

class FolderService {
  final FolderRepository _repository;

  FolderService(this._repository);

  Future<Folder> createFolder({
    required String name,
    required FolderType type,
    String? parentId,
    int? colorValue,
  }) async {
    final folder = Folder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
      parentId: parentId,
      colorValue: colorValue,
    );
    await _repository.save(folder);
    return folder;
  }

  Future<List<Folder>> getFoldersByType(FolderType type, {String? parentId}) =>
      _repository.getByType(type, parentId: parentId);

  Future<Folder?> getFolderById(String id) => _repository.getById(id);

  Future<void> updateFolder(Folder folder) => _repository.save(folder);

  Future<void> deleteFolder(String id) async {
    final hasSubfolders =
        (await _repository.getByType(FolderType as FolderType, parentId: id))
            .isNotEmpty;
    if (hasSubfolders) {
      throw Exception('Нельзя удалить папку, содержащую вложенные папки');
    }
    await _repository.delete(id);
  }

  Future<void> addToFolder(String folderId, String contentId) =>
      _repository.addToFolder(folderId, contentId);

  Future<void> removeFromFolder(String folderId, String contentId) =>
      _repository.removeFromFolder(folderId, contentId);

  Future<void> moveBetweenFolders(
    String contentId,
    String fromFolderId,
    String toFolderId,
  ) async {
    await removeFromFolder(fromFolderId, contentId);
    await addToFolder(toFolderId, contentId);
  }

  Future<List<String>> getFolderContents(String folderId) async {
    final folder = await getFolderById(folderId);
    return folder?.contentIds ?? [];
  }

  Future<List<Folder>> searchFolders(String query, {FolderType? type}) async {
    final all = await _repository.getAll();
    return all.where((folder) {
      final matchesName =
          folder.name.toLowerCase().contains(query.toLowerCase());
      final matchesType = type == null || folder.type == type;
      return matchesName && matchesType;
    }).toList();
  }
}
