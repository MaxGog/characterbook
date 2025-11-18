import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/characters/character_model.dart';
import 'package:characterbook/models/folder_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

mixin TagMixin<T> {
  List<String> generateStandardTags(BuildContext context) {
    final s = S.of(context);
    return [
      s.male, s.female, s.another,
      s.children, s.young, s.adults, s.elderly,
      s.short_name,
      s.a_to_z, s.z_to_a, s.age_asc, s.age_desc
    ];
  }

  bool isStandardTag(String tag, BuildContext context) {
    return generateStandardTags(context).contains(tag);
  }

  List<String> generateAllTags(List<T> items, BuildContext context, List<String> Function(T) getItemTags) {
    final standardTags = generateStandardTags(context);
    final customTags = items.expand((item) => getItemTags(item)).toSet();
    final folderTags = generateFolderTags(context);
    
    return [...folderTags, ...standardTags, ...customTags]..sort();
  }

  List<String> generateFolderTags(BuildContext context) {
    final folderBox = Hive.box<Folder>('folders');
    final folders = folderBox.values.toList();
    
    return folders.map((folder) => '${Icons.folder.codePoint}:${folder.name}').toList();
  }

  bool isFolderTag(String tag) {
    return tag.startsWith('${Icons.folder.codePoint}:');
  }

  String getFolderNameFromTag(String tag) {
    return tag.replaceFirst('${Icons.folder.codePoint}:', '');
  }

  String getFolderIdFromTag(String folderTag) {
    if (!isFolderTag(folderTag)) {
      return '';
    }
    return folderTag.split(':').last;
  }

  bool matchesTagFilter(String? selectedTag, BuildContext context, T item, 
      List<String> Function(T) getItemTags, bool Function(T) isShortName) {
    if (selectedTag == null) return true;
    
    if (isFolderTag(selectedTag)) {
      final folderName = getFolderNameFromTag(selectedTag);
      final folderBox = Hive.box<Folder>('folders');
      final folder = folderBox.values.firstWhere(
        (f) => f.name == folderName,
      );
      
      if (item is Character) {
        return folder.contentIds.contains(item.key.toString());
      } else if (item is Note) {
        return folder.contentIds.contains(item.id);
      } else if (item is Race) {
        return folder.contentIds.contains(item.key.toString());
      }
          return false;
    }
    
    final s = S.of(context);
    if (isStandardTag(selectedTag, context)) {
      return switch (selectedTag) {
        _ when selectedTag == s.male => (item as Character).gender == 'male',
        _ when selectedTag == s.female => (item as Character).gender == 'female',
        _ when selectedTag == s.another => (item as Character).gender == 'another',
        _ when selectedTag == s.short_name => isShortName(item),
        _ when selectedTag == s.children => (item as Character).age < 18,
        _ when selectedTag == s.young => (item as Character).age < 30,
        _ when selectedTag == s.adults => (item as Character).age < 50,
        _ when selectedTag == s.elderly => (item as Character).age >= 50,
        _ => true,
      };
    } else {
      return getItemTags(item).contains(selectedTag);
    }
  }
}