import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/handlers/file_handler.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:characterbook/ui/screens/characters/character_management_screen.dart';
import 'package:characterbook/ui/screens/races/race_management_screen.dart';
import 'package:characterbook/ui/screens/templates/template_management_screen.dart';

class FileHandlerWrapper extends StatefulWidget {
  final Widget child;

  const FileHandlerWrapper({super.key, required this.child});

  @override
  State<FileHandlerWrapper> createState() => _FileHandlerWrapperState();
}

class _FileHandlerWrapperState extends State<FileHandlerWrapper> {
  bool _isHandlingFile = false;
  StreamSubscription? _fileSubscription;

  @override
  void initState() {
    super.initState();
    //_fileSubscription = FileHandler.onFileOpened.listen(_handleFile as void Function(Map<String, dynamic> event)?);
    _initFileHandling();
  }

  @override
  void dispose() {
    _fileSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initFileHandling() async {
    FileHandler.onFileOpened.listen((data) {
      if (mounted) {
        _handleFile(
          path: data['path'],
          type: data['type'],
          originalName: data['originalName'] ?? data['path'].split('/').last,
        );
      }
    });

    final fileData = await FileHandler.getOpenedFile();
    if (mounted && fileData != null) {
      _handleFile(
        path: fileData['path'],
        type: fileData['type'],
        originalName:
            fileData['originalName'] ?? fileData['path'].split('/').last,
      );
    }
  }

  Future<void> _handleFile({
    required String path,
    required String type,
    required String originalName,
  }) async {
    if (!mounted) return;

    setState(() => _isHandlingFile = true);

    try {
      debugPrint('Processing file: $path with type: $type');

      final content = await FileHandler.readFileAsString(path);
      final json = jsonDecode(content);

      switch (type) {
        case 'character':
          final character = Character.fromJson(json);
          _navigateToCharacterEdit(character);
          break;
        case 'race':
          final race = Race.fromJson(json);
          _navigateToRaceManagement(race);
          break;
        case 'chax':
          final template = QuestionnaireTemplate.fromJson(json);
          _navigateToTemplateManagement(template);
          break;
        default:
          throw Exception('Unsupported file type: $type');
      }
    } catch (e, stackTrace) {
      debugPrint('Error handling file: $e');
      debugPrint('Stack trace: $stackTrace');
      _showError(e);
    } finally {
      if (mounted) {
        setState(() => _isHandlingFile = false);
      }
    }
  }

  void _navigateToCharacterEdit(Character character) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CharacterManagementScreen(character: character),
      ),
    );
  }

  void _navigateToRaceManagement(Race race) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RaceManagementScreen(race: race),
      ),
    );
  }

  void _navigateToTemplateManagement(QuestionnaireTemplate template) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TemplateManagementScreen(template: template),
      ),
    );
  }

  void _showError(dynamic error) {
    final s = S.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${s.file_pick_error}: ${error.toString()}'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isHandlingFile)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
