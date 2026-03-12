import 'package:characterbook/enums/calendart_event_type_enum.dart';
import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/note_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarEventModel {
  final DateTime date;
  final CalendarEventType type;
  final Character? character;
  final Race? race;
  final Note? note;

  const CalendarEventModel._({
    required this.date,
    required this.type,
    this.character,
    this.race,
    this.note,
  });

  factory CalendarEventModel.character(DateTime date, Character character) =>
      CalendarEventModel._(
        date: date,
        type: CalendarEventType.character,
        character: character,
      );

  factory CalendarEventModel.race(DateTime date, Race race) =>
    CalendarEventModel._(
      date: date,
      type: CalendarEventType.race,
      race: race,
    );

  factory CalendarEventModel.note(DateTime date, Note note) => 
    CalendarEventModel._(
      date: date,
      type: CalendarEventType.note,
      note: note,
    );

  String getTitle(BuildContext context) {
    switch (type) {
      case CalendarEventType.character:
        return character?.name ?? S.of(context).character;
      case CalendarEventType.race:
        return race?.name ?? S.of(context).race;
      case CalendarEventType.note:
        return note?.title ?? S.of(context).posts;
    }
  }

  String getSubtitle(BuildContext context) {
    final time = DateFormat('HH:mm').format(date);
    switch (type) {
      case CalendarEventType.character:
        return '${S.of(context).character} • $time';
      case CalendarEventType.race:
        return '${S.of(context).race} • $time';
      case CalendarEventType.note:
        return '${S.of(context).posts} • $time';
    }
  }

  IconData get icon {
    switch (type) {
      case CalendarEventType.character:
        return Icons.person;
      case CalendarEventType.race:
        return Icons.flag;
      case CalendarEventType.note:
        return Icons.note;
    }
  }

  Color getColor(BuildContext context) {
    switch (type) {
      case CalendarEventType.character:
        return Theme.of(context).colorScheme.primary;
      case CalendarEventType.race:
        return Theme.of(context).colorScheme.secondary;
      case CalendarEventType.note:
        return Theme.of(context).colorScheme.tertiary;
    }
  }
}
