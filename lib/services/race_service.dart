import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:characterbook/services/pdf_export_manager.dart';
import 'package:characterbook/services/file_share_service.dart';
import 'package:characterbook/ui/dialogs/error_dialog.dart';
import 'package:characterbook/ui/dialogs/loading_dialog.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:characterbook/models/race_model.dart';

class RaceService {
  static const String _boxName = 'races';

  final Race? race;

  RaceService.forDatabase() : race = null;

  RaceService.forExport(this.race);

  Future<Box<Race>> get _box => Hive.openBox<Race>(_boxName);

  Future<int?> saveRace(Race race, {int? key}) async {
    try {
      final box = Hive.box<Race>('races');
      if (key != null) {
        await box.put(key, race);
        return key;
      } else {
        return await box.add(race);
      }
    } catch (e) {
      throw Exception('Ошибка сохранения расы: ${e.toString()}');
    }
  }

  Future<List<Race>> getAllRaces() async {
    try {
      final box = await _box;
      return box.values.toList();
    } catch (e) {
      throw Exception('Ошибка загрузки рас: ${e.toString()}');
    }
  }

  Future<Race?> getRaceById(String id) async {
    try {
      final box = await _box;
      return box.values.firstWhere(
        (race) => race.id == id,
        orElse: () => Race.empty(),
      );
    } catch (e) {
      throw Exception('Ошибка поиска расы по ID: ${e.toString()}');
    }
  }

  Future<List<Race>> getRacesByName(String name) async {
    try {
      final box = await _box;
      return box.values
          .where((race) => race.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Ошибка поиска рас по имени: ${e.toString()}');
    }
  }

  Future<List<Race>> getRacesByTags(List<String> tags) async {
    try {
      final box = await _box;
      return box.values
          .where((race) => race.tags.any((tag) => tags.contains(tag)))
          .toList();
    } catch (e) {
      throw Exception('Ошибка поиска рас по тегам: ${e.toString()}');
    }
  }

  Future<List<Race>> getRacesByFolderId(String folderId) async {
    try {
      final box = await _box;
      return box.values.where((race) => race.folderId == folderId).toList();
    } catch (e) {
      throw Exception('Ошибка поиска рас по папке: ${e.toString()}');
    }
  }

  Future<List<Race>> getRacesWithoutFolder() async {
    try {
      final box = await _box;
      return box.values
          .where((race) => race.folderId == null || race.folderId!.isEmpty)
          .toList();
    } catch (e) {
      throw Exception('Ошибка загрузки рас без папки: ${e.toString()}');
    }
  }

  Future<void> deleteRace(int key) async {
    try {
      final box = await _box;
      await box.delete(key);
    } catch (e) {
      throw Exception('Ошибка удаления расы: ${e.toString()}');
    }
  }

  Future<void> deleteRaceById(String id) async {
    try {
      final box = await _box;
      final raceKey = _getKeyForRaceId(box, id);
      if (raceKey != null) {
        await box.delete(raceKey);
      }
    } catch (e) {
      throw Exception('Ошибка удаления расы по ID: ${e.toString()}');
    }
  }

  Future<void> updateRaceLogo(int key, Uint8List? logoBytes) async {
    try {
      final box = await _box;
      final race = box.get(key);
      if (race != null) {
        race.logo = logoBytes;
        await race.save();
      }
    } catch (e) {
      throw Exception('Ошибка обновления логотипа расы: ${e.toString()}');
    }
  }

  Future<void> updateRaceTags(int key, List<String> tags) async {
    try {
      final box = await _box;
      final race = box.get(key);
      if (race != null) {
        race.tags = tags;
        await race.save();
      }
    } catch (e) {
      throw Exception('Ошибка обновления тегов расы: ${e.toString()}');
    }
  }

  Future<void> updateRaceFolder(int key, String? folderId) async {
    try {
      final box = await _box;
      final race = box.get(key);
      if (race != null) {
        race.folderId = folderId;
        await race.save();
      }
    } catch (e) {
      throw Exception('Ошибка обновления папки расы: ${e.toString()}');
    }
  }

  Future<int> getRacesCount() async {
    try {
      final box = await _box;
      return box.length;
    } catch (e) {
      throw Exception('Ошибка получения количества рас: ${e.toString()}');
    }
  }

  Future<int> getRacesCountInFolder(String folderId) async {
    try {
      final box = await _box;
      return box.values.where((race) => race.folderId == folderId).length;
    } catch (e) {
      throw Exception(
          'Ошибка получения количества рас в папке: ${e.toString()}');
    }
  }

  Future<List<Race>> searchRaces(String query) async {
    try {
      final box = await _box;
      final lowerQuery = query.toLowerCase();

      return box.values
          .where((race) =>
              race.name.toLowerCase().contains(lowerQuery) ||
              race.description.toLowerCase().contains(lowerQuery) ||
              race.biology.toLowerCase().contains(lowerQuery) ||
              race.backstory.toLowerCase().contains(lowerQuery) ||
              race.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)))
          .toList();
    } catch (e) {
      throw Exception('Ошибка поиска рас: ${e.toString()}');
    }
  }

  Future<Set<String>> getAllUniqueTags() async {
    try {
      final box = await _box;
      final allTags = <String>{};

      for (final race in box.values) {
        allTags.addAll(race.tags);
      }

      return allTags;
    } catch (e) {
      throw Exception('Ошибка получения уникальных тегов: ${e.toString()}');
    }
  }

  Future<Map<String, int>> getPopularTags({int limit = 10}) async {
    try {
      final box = await _box;
      final tagCounts = <String, int>{};

      for (final race in box.values) {
        for (final tag in race.tags) {
          tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
        }
      }

      final sortedEntries = tagCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return Map.fromEntries(
        sortedEntries.take(limit),
      );
    } catch (e) {
      throw Exception('Ошибка получения популярных тегов: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> exportRaceToJson(int key) async {
    try {
      final box = await _box;
      final race = box.get(key);

      if (race == null) {
        throw Exception('Раса с ключом $key не найдена');
      }

      return race.toJson();
    } catch (e) {
      throw Exception('Ошибка экспорта расы в JSON: ${e.toString()}');
    }
  }

  Future<int> importRaceFromJson(Map<String, dynamic> json) async {
    try {
      final race = Race.fromJson(json);
      return await saveRace(race) ?? -1;
    } catch (e) {
      throw Exception('Ошибка импорта расы из JSON: ${e.toString()}');
    }
  }

  Future<List<int>> importRacesFromJsonList(
      List<Map<String, dynamic>> jsonList) async {
    try {
      final results = <int>[];

      for (final json in jsonList) {
        try {
          final race = Race.fromJson(json);
          final key = await saveRace(race);
          if (key != null) {
            results.add(key);
          }
        } catch (e) {
          if (kDebugMode) {
            print('Ошибка импорта расы: $e');
          }
        }
      }

      return results;
    } catch (e) {
      throw Exception('Ошибка импорта списка рас: ${e.toString()}');
    }
  }

  Future<void> clearAllRaces() async {
    try {
      final box = await _box;
      await box.clear();
    } catch (e) {
      throw Exception('Ошибка очистки всех рас: ${e.toString()}');
    }
  }

  int? _getKeyForRaceId(Box<Race> box, String id) {
    for (var i = 0; i < box.length; i++) {
      final key = box.keyAt(i);
      final race = box.get(key);
      if (race != null && race.id == id) {
        return key;
      }
    }
    return null;
  }

  Future<List<Race>> getRacesPaginated({
    int page = 1,
    int pageSize = 20,
    String? folderId,
    List<String>? tags,
  }) async {
    try {
      final box = await _box;
      List<Race> filteredRaces;

      if (folderId != null) {
        filteredRaces =
            box.values.where((race) => race.folderId == folderId).toList();
      } else if (tags != null && tags.isNotEmpty) {
        filteredRaces = box.values
            .where((race) => race.tags.any((tag) => tags.contains(tag)))
            .toList();
      } else {
        filteredRaces = box.values.toList();
      }

      filteredRaces.sort((a, b) => a.name.compareTo(b.name));

      final startIndex = (page - 1) * pageSize;
      if (startIndex >= filteredRaces.length) {
        return [];
      }

      final endIndex = startIndex + pageSize;
      return filteredRaces.sublist(
        startIndex,
        endIndex > filteredRaces.length ? filteredRaces.length : endIndex,
      );
    } catch (e) {
      throw Exception('Ошибка получения пагинированных рас: ${e.toString()}');
    }
  }

  Future<bool> doesRaceExist(String name, {String? excludeId}) async {
    try {
      final box = await _box;
      return box.values.any((race) =>
          race.name == name && (excludeId == null || race.id != excludeId));
    } catch (e) {
      throw Exception('Ошибка проверки существования расы: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getRacesStatistics() async {
    try {
      final box = await _box;
      final races = box.values.toList();

      return {
        'totalRaces': races.length,
        'racesWithLogo': races.where((race) => race.logo != null).length,
        'racesWithFolder': races
            .where((race) => race.folderId != null && race.folderId!.isNotEmpty)
            .length,
        'racesWithTags': races.where((race) => race.tags.isNotEmpty).length,
        'averageTagsPerRace': races.isEmpty
            ? 0
            : races.fold(
                    0,
                    (sum, race) =>
                        int.parse(sum.toString()) + race.tags.length) /
                races.length,
        'mostCommonTag': _getMostCommonTag(races),
      };
    } catch (e) {
      throw Exception('Ошибка получения статистики рас: ${e.toString()}');
    }
  }

  String? _getMostCommonTag(List<Race> races) {
    final tagCounts = <String, int>{};

    for (final race in races) {
      for (final tag in race.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    if (tagCounts.isEmpty) return null;

    return tagCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Future<void> exportToPdf(BuildContext context) async {
    if (race == null) {
      _showErrorDialog(
        context,
        'Ошибка экспорта',
        'Раса не установлена для экспорта',
      );
      return;
    }

    await PdfExportManager.exportRaceWithDialog(
      context,
      race!,
      fileName: '${race!.name}.pdf',
      shareText: 'Описание расы ${race!.name}',
    );
  }

  Future<void> exportToJson(BuildContext context) async {
    if (race == null) {
      _showErrorDialog(
        context,
        'Ошибка экспорта',
        'Раса не установлена для экспорта',
      );
      return;
    }

    try {
      showLoadingDialog(
        context: context,
        message: S.of(context).creating_file,
      );

      final jsonStr = jsonEncode(race!.toJson());
      final fileName =
          '${race!.name}_${DateTime.now().millisecondsSinceEpoch}.race';

      await Future.delayed(const Duration(milliseconds: 100));

      if (context.mounted) {
        hideLoadingDialog(context);
      }

      await FileShareService.shareFile(
        Uint8List.fromList(jsonStr.codeUnits),
        fileName,
        text: 'Раса: ${race!.name}',
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException(
          'Экспорт в JSON занял слишком много времени',
        ),
      );
    } on TimeoutException {
      if (context.mounted) {
        hideLoadingDialog(context);
        _showErrorDialog(
          context,
          'Таймаут',
          'Экспорт в JSON занял слишком много времени',
        );
      }
    } catch (e) {
      if (context.mounted) {
        hideLoadingDialog(context);
        _showErrorDialog(
          context,
          'Ошибка экспорта',
          'Не удалось экспортировать в JSON: ${e.toString()}',
        );
      }
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showErrorDialog(
          context: context,
          title: title,
          message: message,
        );
      }
    });
  }
}
