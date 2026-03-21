import 'package:characterbook/enums/tool_type_enum.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:flutter/material.dart';

sealed class HomeItem {
  const HomeItem();
}

final class CharacterHomeItem extends HomeItem {
  final Character character;
  const CharacterHomeItem(this.character);
}

final class RaceHomeItem extends HomeItem {
  final Race race;
  const RaceHomeItem(this.race);
}

class ToolHomeItem extends HomeItem {
  final ToolType type;
  final Widget page;

  ToolHomeItem({required this.type, required this.page});

  String getTitle(BuildContext context) {
    final s = S.of(context);
    switch (type) {
      case ToolType.randomNumber:
        return s.randomNumberGenerator;
      case ToolType.pdfExport:
        return s.export_pdf_settings;
      case ToolType.templates:
        return s.templates;
      case ToolType.calendar:
        return s.calendar;
      case ToolType.relationships:
        return "s.relationships";
    }
  }

  String getSubtitle(BuildContext context) {
    if (type == ToolType.calendar) {
      return S.of(context).event_calendar;
    }
    return '';
  }

  IconData getIcon() {
    switch (type) {
      case ToolType.randomNumber:
        return Icons.casino_rounded;
      case ToolType.pdfExport:
        return Icons.picture_as_pdf_rounded;
      case ToolType.templates:
        return Icons.library_books_rounded;
      case ToolType.calendar:
        return Icons.calendar_today_rounded;
      case ToolType.relationships:
        return Icons.family_restroom_outlined;
    }
  }
}
