import 'dart:async';
import 'package:characterbook/data/models/note_model.dart';
import 'package:characterbook/data/repositories/note_repository.dart';
import 'package:characterbook/data/enums/note_sort_enum.dart';
import 'package:flutter/material.dart';

class NoteListController extends ChangeNotifier {
  final NoteRepository _repository;
  List<Note> _all = [];
  List<Note> _filtered = [];
  String _searchQuery = '';
  String? _selectedTag;
  NoteSort _sort = NoteSort.updatedAtDesc;
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _subscription;

  NoteListController(this._repository) {
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

  List<Note> get filteredItems => _filtered;
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

  void setSort(NoteSort sort) {
    if (_sort == sort) return;
    _sort = sort;
    _applyFilterAndSort();
  }

  void _applyFilterAndSort() {
    _filtered = _all.where(_matchesSearchAndTag).toList();
    _sortItems();
    notifyListeners();
  }

  bool _matchesSearchAndTag(Note n) {
    final queryLower = _searchQuery.toLowerCase();
    final matchesSearch = _searchQuery.isEmpty ||
        n.title.toLowerCase().contains(queryLower) ||
        n.content.toLowerCase().contains(queryLower);
    final matchesTag = _selectedTag == null || n.tags.contains(_selectedTag);
    return matchesSearch && matchesTag;
  }

  void _sortItems() {
    switch (_sort) {
      case NoteSort.updatedAtDesc:
        _filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case NoteSort.updatedAtAsc:
        _filtered.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      case NoteSort.titleAsc:
        _filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case NoteSort.titleDesc:
        _filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
    }
  }

  Set<String> get allTags => _all.expand((n) => n.tags).toSet();

  Future<void> deleteNote(Note note) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _repository.delete(note.key);
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
