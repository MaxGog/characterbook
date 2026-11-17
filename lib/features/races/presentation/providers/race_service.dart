import 'package:characterbook/features/races/domain/race_model.dart';
import 'package:characterbook/features/races/domain/race_repository.dart';
import 'package:flutter/foundation.dart';

class RaceService extends ChangeNotifier {
  final RaceRepository _repository;

  RaceService(this._repository);

  Future<void> saveRace(Race race) async {
    await _repository.save(race);
    notifyListeners();
  }

  Future<void> deleteRace(String id) async {
    await _repository.delete(id);
    notifyListeners();
  }

  Future<List<Race>> getAllRaces() => _repository.getAll();
  Future<Race?> getRaceById(String id) => _repository.getById(id);

  Future<void> deleteRaceById(String id) async {
    await _repository.delete(id);
  }

  Future<List<Race>> getRacesByName(String name) async {
    final all = await _repository.getAll();
    return all
        .where((race) => race.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  Future<List<Race>> getRacesByTags(List<String> tags) async {
    final all = await _repository.getAll();
    return all
        .where((race) => race.tags.any((tag) => tags.contains(tag)))
        .toList();
  }

  Future<List<Race>> getRacesByFolderId(String folderId) async {
    final all = await _repository.getAll();
    return all.where((race) => race.folderId == folderId).toList();
  }

  Future<List<Race>> getRacesWithoutFolder() async {
    final all = await _repository.getAll();
    return all
        .where((race) => race.folderId == null || race.folderId!.isEmpty)
        .toList();
  }

  Future<void> updateRaceLogo(String id, Uint8List? logoBytes) async {
    final race = await _repository.getById(id);
    if (race != null) {
      race.logo = logoBytes;
      await _repository.save(race);
    }
  }

  Future<void> updateRaceTags(String id, List<String> tags) async {
    final race = await _repository.getById(id);
    if (race != null) {
      race.tags = tags;
      await _repository.save(race);
    }
  }

  Future<void> updateRaceFolder(String id, String? folderId) async {
    final race = await _repository.getById(id);
    if (race != null) {
      race.folderId = folderId;
      await _repository.save(race);
    }
  }

  Future<int> getRacesCount() async => (await _repository.getAll()).length;

  Future<int> getRacesCountInFolder(String folderId) async =>
      (await _repository.getAll())
          .where((race) => race.folderId == folderId)
          .length;

  Future<List<Race>> searchRaces(String query) async {
    final all = await _repository.getAll();
    final lower = query.toLowerCase();
    return all
        .where(
          (race) =>
              race.name.toLowerCase().contains(lower) ||
              race.description.toLowerCase().contains(lower) ||
              race.biology.toLowerCase().contains(lower) ||
              race.backstory.toLowerCase().contains(lower) ||
              race.tags.any((tag) => tag.toLowerCase().contains(lower)),
        )
        .toList();
  }

  Future<Set<String>> getAllUniqueTags() async {
    final all = await _repository.getAll();
    return all.expand((race) => race.tags).toSet();
  }

  Future<Map<String, int>> getPopularTags({int limit = 10}) async {
    final tagCounts = _countTags(await _repository.getAll()).entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(tagCounts.take(limit));
  }

  Future<Map<String, dynamic>> exportRaceToJson(String id) async {
    final race = await _repository.getById(id);
    if (race == null) throw Exception('Race not found');
    return race.toJson();
  }

  Future<String> importRaceFromJson(Map<String, dynamic> json) async {
    final race = Race.fromJson(json);
    await _repository.save(race);
    return race.id;
  }

  Future<List<String>> importRacesFromJsonList(
    List<Map<String, dynamic>> jsonList,
  ) async {
    final results = <String>[];
    for (final json in jsonList) {
      try {
        final race = Race.fromJson(json);
        await _repository.save(race);
        results.add(race.id);
      } catch (error) {
        if (kDebugMode) debugPrint('Ошибка импорта расы: $error');
      }
    }
    return results;
  }

  Future<void> clearAllRaces() => _repository.clear();

  Future<List<Race>> getRacesPaginated({
    int page = 1,
    int pageSize = 20,
    String? folderId,
    List<String>? tags,
  }) async {
    var filtered = await _repository.getAll();
    if (folderId != null) {
      filtered = filtered.where((race) => race.folderId == folderId).toList();
    } else if (tags != null && tags.isNotEmpty) {
      filtered = filtered
          .where((race) => race.tags.any((tag) => tags.contains(tag)))
          .toList();
    }
    filtered.sort((a, b) => a.name.compareTo(b.name));
    final start = (page - 1) * pageSize;
    if (start >= filtered.length) return [];
    final end = start + pageSize;
    return filtered.sublist(
      start,
      end > filtered.length ? filtered.length : end,
    );
  }

  Future<bool> doesRaceExist(String name, {String? excludeId}) async {
    final all = await _repository.getAll();
    return all.any(
      (race) =>
          race.name == name && (excludeId == null || race.id != excludeId),
    );
  }

  Future<Map<String, dynamic>> getRacesStatistics() async {
    final all = await _repository.getAll();
    final total = all.length;
    final withLogo = all.where((race) => race.logo != null).length;
    final withFolder = all
        .where((race) => race.folderId != null && race.folderId!.isNotEmpty)
        .length;
    final withTags = all.where((race) => race.tags.isNotEmpty).length;
    final avgTags = total == 0
        ? 0
        : all.fold(0, (sum, race) => sum + race.tags.length) / total;
    final tagCounts = _countTags(all);
    final mostCommonTag = tagCounts.isEmpty
        ? null
        : tagCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    return {
      'totalRaces': total,
      'racesWithLogo': withLogo,
      'racesWithFolder': withFolder,
      'racesWithTags': withTags,
      'averageTagsPerRace': avgTags,
      'mostCommonTag': mostCommonTag,
    };
  }

  Map<String, int> _countTags(List<Race> races) {
    final tagCounts = <String, int>{};
    for (final race in races) {
      for (final tag in race.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    return tagCounts;
  }
}
