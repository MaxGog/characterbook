import 'package:characterbook/data/models/folder_model.dart';
import 'package:characterbook/data/models/race_model.dart';
import 'package:characterbook/data/repositories/folder_repository.dart';
import 'package:characterbook/data/repositories/race_repository.dart';
import 'package:characterbook/services/clipboard_service.dart';
import 'package:characterbook/data/services/race_service.dart';
import 'package:flutter/material.dart';

class RaceModalController extends ChangeNotifier {
  final Race race;
  final RaceRepository _raceRepo;
  final FolderRepository _folderRepo;
  final RaceService _raceService;

  Folder? _currentFolder;
  bool _isLoading = false;
  String? _error;
  final Map<String, bool> _expandedSections = {
    'description': true,
    'biology': true,
    'backstory': true,
    'additionalImages': true,
  };

  RaceModalController({
    required this.race,
    required RaceRepository raceRepo,
    required FolderRepository folderRepo,
    required RaceService raceService,
    ClipboardService? clipboardService,
  })  : _raceRepo = raceRepo,
        _folderRepo = folderRepo,
        _raceService = raceService {
    _loadFolder();
  }

  Folder? get currentFolder => _currentFolder;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, bool> get expandedSections => _expandedSections;

  void toggleSection(String key) {
    _expandedSections[key] = !(_expandedSections[key] ?? true);
    notifyListeners();
  }

  Future<void> _loadFolder() async {
    if (race.folderId == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      _currentFolder = await _folderRepo.getById(race.folderId!);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRace() async {
    try {
      await _raceRepo.delete(race.key);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> exportToPdf(BuildContext context) async {
    try {
      await _raceService.exportToPdf(context, race);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> exportToJson(BuildContext context) async {
    try {
      await _raceService.exportToJson(context, race);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> copyToClipboard(BuildContext context) async {
    try {
      await ClipboardService.copyRaceToClipboard(
        context: context,
        name: race.name,
        description: race.description,
        biology: race.biology,
        backstory: race.backstory,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
