import 'dart:convert';
import 'dart:io';

import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:characterbook/models/template_model.dart';
import 'package:characterbook/services/character_service.dart';
import 'package:characterbook/services/clipboard_service.dart';
import 'package:characterbook/services/race_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ContextMenu extends StatelessWidget {
  final dynamic item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showExportPdf;
  final bool showCopy;
  final bool showShare;

  const ContextMenu({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    this.showExportPdf = false,
    this.showCopy = true,
    this.showShare = true,
  });

  factory ContextMenu.character({
    required Character character,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    Key? key,
  }) {
    return ContextMenu(
      key: key,
      item: character,
      onEdit: onEdit,
      onDelete: onDelete,
      showExportPdf: true,
    );
  }

  factory ContextMenu.race({
    required Race race,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    Key? key,
  }) {
    return ContextMenu(
      key: key,
      item: race,
      onEdit: onEdit,
      onDelete: onDelete,
      showExportPdf: true
    );
  }

  factory ContextMenu.note({
    required Note note,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    Key? key,
  }) {
    return ContextMenu(
      key: key,
      item: note,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    final s = S.of(context);
    try {
      if (item is Character) {
        final character = item as Character;
        await ClipboardService.copyCharacterToClipboard(
          context: context,
          name: character.name,
          age: character.age,
          gender: character.gender,
          raceName: character.race?.name,
          biography: character.biography,
          appearance: character.appearance,
          personality: character.personality,
          abilities: character.abilities,
          other: character.other,
          customFields: character.customFields.map((f) => {'key': f.key, 'value': f.value}).toList(),
        );
      } else if (item is Race) {
        final race = item as Race;
        await ClipboardService.copyRaceToClipboard(
          context: context,
          name: race.name,
          description: race.description,
          biology: race.biology,
          backstory: race.backstory,
        );
      } else if (item is Note) {
        final note = item as Note;
        await Clipboard.setData(ClipboardData(text: note.content));
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.copied_to_clipboard),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${s.copy_error}: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _exportToPdf(BuildContext context) async {
    final s = S.of(context);

    try {
      if (item is Character) {
        final exportService = CharacterService.forExport(item as Character);
        await exportService.exportToPdf(context);
      } else if (item is Race) {
        final exportService = RaceService.forExport(item as Race);
        await exportService.exportToPdf(context);
      } else {
        return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.pdf_export_success),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${s.export_error}: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _shareAsFile(BuildContext context) async {
    final s = S.of(context);
    try {
      String fileName;
      String content;
      String shareText;

      if (item is Character) {
        final character = item as Character;
        fileName = '${character.name}.character';
        shareText = s.character_share_text(character.name);
        content = jsonEncode(character.toJson());
      } else if (item is Race) {
        final race = item as Race;
        fileName = '${race.name}.race';
        shareText = s.race_share_text(race.name);
        content = jsonEncode(race.toJson());
      } else if (item is Note) {
        final note = item as Note;
        fileName = '${note.title}_note.json';
        shareText = note.title;
        content = jsonEncode(note.toJson());
      } else if (item is QuestionnaireTemplate) {
        final template = item as QuestionnaireTemplate;
        fileName = '${template.name}.chax';
        shareText = template.name;
        content = jsonEncode(template.toJson());
      } else {
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(content);
      await Share.shareXFiles([XFile(file.path)], text: shareText);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${s.error}: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    Widget buildMenuItem({
      required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap,
    }) {
      final theme = Theme.of(context);
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.pop(context);
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildMenuItem(
            icon: Icons.edit_rounded,
            label: s.edit,
            color: colorScheme.onSurface,
            onTap: onEdit,
          ),
          
          if (showCopy)
            buildMenuItem(
              icon: Icons.copy_rounded,
              label: s.copy,
              color: colorScheme.onSurface,
              onTap: () => _copyToClipboard(context),
            ),
          
          if (showShare)
            buildMenuItem(
              icon: Icons.share_rounded,
              label: s.share,
              color: colorScheme.onSurface,
              onTap: () => _shareAsFile(context),
            ),
          
          if (showExportPdf)
            buildMenuItem(
              icon: Icons.picture_as_pdf_rounded,
              label: s.file_pdf,
              color: colorScheme.onSurface,
              onTap: () => _exportToPdf(context),
            ),
          
          Divider(
            height: 1,
            color: colorScheme.outlineVariant,
            indent: 16,
            endIndent: 16,
          ),
          
          buildMenuItem(
            icon: Icons.delete_rounded,
            label: s.delete,
            color: colorScheme.error,
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}