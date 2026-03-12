import 'dart:async';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/services/character_service.dart';
import 'package:characterbook/services/race_service.dart';
import 'package:characterbook/ui/widgets/home_item.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final CharacterService _characterService;
  final RaceService _raceService;

  HomeController({
    CharacterService? characterService,
    RaceService? raceService,
  })  : _characterService = characterService ?? CharacterService.forDatabase(),
        _raceService = raceService ?? RaceService.forDatabase();

  List<CharacterHomeItem> _characters = [];
  List<RaceHomeItem> _races = [];
  List<HomeItem> _allItems = [];
  List<HomeItem> _filteredItems = [];
  String _searchQuery = '';

  List<HomeItem> get filteredItems => _filteredItems;
  String get searchQuery => _searchQuery;
  bool get hasItems => _filteredItems.isNotEmpty;

  Future<void> loadData() async {
    try {
      final characters = await _characterService.getAllCharacters();
      final races = await _raceService.getAllRaces();

      _characters = characters.map(CharacterHomeItem.new).toList();
      _races = races.map(RaceHomeItem.new).toList();
      _allItems = [..._characters, ..._races];
      _applyFilter();
    } catch (e) {
      rethrow;
    }
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    _applyFilter();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredItems = List.from(_allItems);
    } else {
      final lowerQuery = _searchQuery.toLowerCase();
      _filteredItems = _allItems.where((item) {
        return switch (item) {
          CharacterHomeItem(:final character) =>
            character.name.toLowerCase().contains(lowerQuery),
          RaceHomeItem(:final race) =>
            race.name.toLowerCase().contains(lowerQuery),
        };
      }).toList();
    }
    notifyListeners();
  }

  int characterCountForRace(Race race) {
    return _characters
        .where((item) => item.character.race?.id == race.id)
        .length;
  }

  Future<void> deleteItem(HomeItem item) async {
    final originalAll = List<HomeItem>.from(_allItems);
    final originalFiltered = List<HomeItem>.from(_filteredItems);

    _allItems.remove(item);
    _applyFilter(); // пересчитывает _filteredItems

    try {
      switch (item) {
        case CharacterHomeItem(:final character):
          await _characterService.deleteCharacter(character);
        case RaceHomeItem(:final race):
          await _raceService.deleteRace(race.key);
      }
    } catch (e) {
      _allItems = originalAll;
      _filteredItems = originalFiltered;
      notifyListeners();
      rethrow;
    }
  }
  int get itemCount => _filteredItems.length;
}
