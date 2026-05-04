import 'package:characterbook/data/models/folder_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class FolderRepository {
  Stream<List<Folder>> watchAll();
  Future<List<Folder>> getAll();
  Future<Folder?> getById(String id);
  Future<List<Folder>> getByType(FolderType type, {String? parentId});
  Future<List<Folder>> getChildren(String parentId);
  Future<void> save(Folder folder);
  Future<void> delete(String id);
  Future<void> addToFolder(String folderId, String contentId);
  Future<void> removeFromFolder(String folderId, String contentId);
  Future<void> clear();
}
class FolderRepositoryHive implements FolderRepository {
  final Box<Folder> _box;

  FolderRepositoryHive(this._box);

  @override
  Stream<List<Folder>> watchAll() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList());
  }

  @override
  Future<List<Folder>> getAll() async {
    try {
      return _box.values.toList();
    } catch (e) {
      throw Exception('Failed to get folders: $e');
    }
  }

  @override
  Future<Folder?> getById(String id) async {
    try {
      return _box.get(id);
    } catch (e) {
      throw Exception('Failed to get folder by id: $e');
    }
  }

  @override
  Future<List<Folder>> getByType(FolderType type, {String? parentId}) async {
    try {
      return _box.values.where((f) {
        if (f.type != type) return false;
        if (parentId != null && f.parentId != parentId) return false;
        return true;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get folders by type: $e');
    }
  }

  @override
  Future<List<Folder>> getChildren(String parentId) async {
    try {
      return _box.values.where((f) => f.parentId == parentId).toList();
    } catch (e) {
      throw Exception('Failed to get children folders: $e');
    }
  }

  @override
  Future<void> save(Folder folder) async {
    try {
      final updatedFolder = folder.copyWith(updatedAt: DateTime.now());
      await _box.put(updatedFolder.id, updatedFolder);
    } catch (e) {
      throw Exception('Failed to save folder: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final children = await getChildren(id);
      for (final child in children) {
        await delete(child.id);
      }
      await _box.delete(id);
    } catch (e) {
      throw Exception('Failed to delete folder: $e');
    }
  }

  @override
  Future<void> addToFolder(String folderId, String contentId) async {
    try {
      final folder = await getById(folderId);
      if (folder != null && !folder.contentIds.contains(contentId)) {
        final updatedFolder = folder.copyWith(
          contentIds: [...folder.contentIds, contentId],
          updatedAt: DateTime.now(),
        );
        await save(updatedFolder);
      }
    } catch (e) {
      throw Exception('Failed to add content to folder: $e');
    }
  }

  @override
  Future<void> removeFromFolder(String folderId, String contentId) async {
    try {
      final folder = await getById(folderId);
      if (folder != null && folder.contentIds.contains(contentId)) {
        final updatedFolder = folder.copyWith(
          contentIds: folder.contentIds.where((id) => id != contentId).toList(),
          updatedAt: DateTime.now(),
        );
        await save(updatedFolder);
      }
    } catch (e) {
      throw Exception('Failed to remove content from folder: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _box.clear();
    } catch (e) {
      throw Exception('Failed to clear folders: $e');
    }
  }
}
