import 'package:characterbook/models/folder_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class FolderRepository {
  Stream<List<Folder>> watchAll();
  Future<List<Folder>> getAll();
  Future<Folder?> getById(String id);
  Future<List<Folder>> getByType(FolderType type, {String? parentId});
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
  Future<List<Folder>> getAll() async => _box.values.toList();

  @override
  Future<Folder?> getById(String id) async => _box.get(id);

  @override
  Future<List<Folder>> getByType(FolderType type, {String? parentId}) async {
    return _box.values.where((f) {
      if (f.type != type) return false;
      if (parentId != null && f.parentId != parentId) return false;
      return true;
    }).toList();
  }

  @override
  Future<void> save(Folder folder) async {
    folder.updatedAt = DateTime.now();
    await _box.put(folder.id, folder);
  }

  @override
  Future<void> delete(String id) async => _box.delete(id);

  @override
  Future<void> addToFolder(String folderId, String contentId) async {
    final folder = await getById(folderId);
    if (folder != null) {
      folder.contentIds.add(contentId);
      await save(folder);
    }
  }

  @override
  Future<void> removeFromFolder(String folderId, String contentId) async {
    final folder = await getById(folderId);
    if (folder != null) {
      folder.contentIds.remove(contentId);
      await save(folder);
    }
  }
  
  @override
  Future<void> clear() async => _box.clear();
}
