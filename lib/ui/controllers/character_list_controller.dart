import 'dart:async';
import 'package:characterbook/data/enums/character_sort_enum.dart';
import 'package:characterbook/data/models/character_model.dart';
import 'package:characterbook/data/repositories/character_repository.dart';
import 'package:flutter/material.dart';

class CharacterListController extends ChangeNotifier {
  final CharacterRepository _repository;
  List<Character> _all = [];
  List<Character> _filtered = [];
  String _searchQuery = '';
  String? _selectedTag;
  CharacterSort _sort = CharacterSort.nameAsc;
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _subscription;

  CharacterListController(this._repository) {
    _subscription = _repository.watchAll().listen(
      (list) {
        _all = list;
        _applyFilterAndSort();
      },
      onError: (err) {
        _error = err.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  List<Character> get filteredItems => _filtered;
  String? get selectedTag => _selectedTag;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    _applyFilterAndSort();
  }

  void setSelectedTag(String? tag) {
    if (_selectedTag == tag) return;
    _selectedTag = tag;
    _applyFilterAndSort();
  }

  void setSort(CharacterSort sort) {
    if (_sort == sort) return;
    _sort = sort;
    _applyFilterAndSort();
  }

  void _applyFilterAndSort() {
    _filtered = _all.where(_matchesSearchAndTag).toList();
    _sortItems();
    notifyListeners();
  }

  bool _matchesSearchAndTag(Character c) {
    final queryLower = _searchQuery.toLowerCase();
    final matchesSearch = _searchQuery.isEmpty ||
        c.name.toLowerCase().contains(queryLower) ||
        c.age.toString().contains(_searchQuery) ||
        c.tags.any((t) => t.toLowerCase().contains(queryLower));
    final matchesTag = _selectedTag == null || c.tags.contains(_selectedTag);
    return matchesSearch && matchesTag;
  }

  void _sortItems() {
    switch (_sort) {
      case CharacterSort.nameAsc:
        _filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case CharacterSort.nameDesc:
        _filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
      case CharacterSort.ageAsc:
        _filtered.sort((a, b) => a.age.compareTo(b.age));
        break;
      case CharacterSort.ageDesc:
        _filtered.sort((a, b) => b.age.compareTo(a.age));
        break;
    }
  }

  Set<String> get allTags => _all.expand((c) => c.tags).toSet();

  Future<void> deleteCharacter(Character character) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _repository.delete(character.key);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    try {
      await _repository.reorder(oldIndex, newIndex);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
