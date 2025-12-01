import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
import '../../models/character_model.dart';
import '../../models/note_model.dart';
import '../../models/race_model.dart';
import '../../services/character_service.dart';
import '../../services/note_service.dart';
import '../../services/race_service.dart';
import '../cards/character_modal_card.dart';
import '../cards/race_modal_card.dart';
import '../widgets/appbar/common_edit_app_bar.dart';
import '../widgets/cards/character_card.dart';
import '../widgets/cards/race_card.dart';
import '../widgets/cards/note_card.dart';
import 'note_management_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<CalendarEvent>> _events = {};
  late Map<DateTime, List<CalendarEvent>> _filteredEvents = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  CalendarEventType _selectedFilter = CalendarEventType.all;

  final CharacterService _characterService = CharacterService.forDatabase();
  final RaceService _raceService = RaceService.forDatabase();
  final NoteService _noteService = NoteService.forDatabase();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvents();
    });
  }

  Future<void> _loadEvents() async {
    try {
      final characters = await _characterService.getAllCharacters();
      final races = await _raceService.getAllRaces();
      final notes = await _noteService.getAllNotes();

      final Map<DateTime, List<CalendarEvent>> events = {};

      for (final character in characters) {
        final event = CalendarEvent.character(
          date: character.lastEdited,
          character: character,
        );
        final date = DateTime(character.lastEdited.year,
            character.lastEdited.month, character.lastEdited.day);
        events[date] = [...events[date] ?? [], event];
      }

      for (final race in races) {
        final event = CalendarEvent.race(
          date: race.lastEdited,
          race: race,
        );
        final date = DateTime(
            race.lastEdited.year, race.lastEdited.month, race.lastEdited.day);
        events[date] = [...events[date] ?? [], event];
      }

      for (final note in notes) {
        final event = CalendarEvent.note(
          date: note.updatedAt,
          note: note,
        );
        final date = DateTime(
            note.updatedAt.year, note.updatedAt.month, note.updatedAt.day);
        events[date] = [...events[date] ?? [], event];
      }

      setState(() {
        _events = events;
        _filteredEvents = _applyFilter(events, _selectedFilter);
      });
    } catch (e) {
      _showErrorSnackbar('${S.of(context).events_loading_error}: $e');
    }
  }

  Map<DateTime, List<CalendarEvent>> _applyFilter(
      Map<DateTime, List<CalendarEvent>> events, CalendarEventType filter) {
    if (filter == CalendarEventType.all) return Map.from(events);

    final filtered = <DateTime, List<CalendarEvent>>{};
    for (final entry in events.entries) {
      final filteredEvents = entry.value.where((event) {
        switch (filter) {
          case CalendarEventType.character:
            return event.type == CalendarEventType.character;
          case CalendarEventType.race:
            return event.type == CalendarEventType.race;
          case CalendarEventType.note:
            return event.type == CalendarEventType.note;
          default:
            return true;
        }
      }).toList();

      if (filteredEvents.isNotEmpty) {
        filtered[entry.key] = filteredEvents;
      }
    }

    return filtered;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onFilterChanged(CalendarEventType filter) {
    setState(() {
      _selectedFilter = filter;
      _filteredEvents = _applyFilter(_events, filter);
    });
  }

  void _showCharacterModal(Character character) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CharacterModalCard(character: character),
    );
  }

  void _showRaceModal(Race race) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RaceModalCard(race: race),
    );
  }

  void _navigateToEvent(CalendarEvent event) {
    switch (event.type) {
      case CalendarEventType.character:
        _showCharacterModal(event.character!);
        break;
      case CalendarEventType.race:
        _showRaceModal(event.race!);
        break;
      case CalendarEventType.note:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteEditPage(note: event.note!),
          ),
        );
        break;
      default:
        break;
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _filteredEvents[normalizedDay] ?? [];
  }

  Widget _buildFilterButton(BuildContext context) {
    return PopupMenuButton<CalendarEventType>(
      onSelected: _onFilterChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: CalendarEventType.all,
          child: Row(
            children: [
              const Icon(Icons.all_inclusive, size: 20),
              const SizedBox(width: 8),
              Text(S.of(context).all_events),
            ],
          ),
        ),
        PopupMenuItem(
          value: CalendarEventType.character,
          child: Row(
            children: [
              const Icon(Icons.person, size: 20),
              const SizedBox(width: 8),
              Text(S.of(context).character_events),
            ],
          ),
        ),
        PopupMenuItem(
          value: CalendarEventType.race,
          child: Row(
            children: [
              const Icon(Icons.flag, size: 20),
              const SizedBox(width: 8),
              Text(S.of(context).race_events),
            ],
          ),
        ),
        PopupMenuItem(
          value: CalendarEventType.note,
          child: Row(
            children: [
              const Icon(Icons.note, size: 20),
              const SizedBox(width: 8),
              Text(S.of(context).note_events),
            ],
          ),
        ),
      ],
      icon: const Icon(Icons.filter_list),
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    switch (event.type) {
      case CalendarEventType.character:
        return CharacterCard(
          character: event.character!,
          isSelected: false,
          onTap: () => _navigateToEvent(event),
          onLongPress: () => _showCharacterModal(event.character!),
          onMenuPressed: () => _showCharacterModal(event.character!),
        );
      case CalendarEventType.race:
        return RaceCard(
          race: event.race!,
          isSelected: false,
          onTap: () => _navigateToEvent(event),
          onLongPress: () => _showRaceModal(event.race!),
        );
      case CalendarEventType.note:
        return NoteCard(
          note: event.note!,
          isSelected: false,
          onTap: () => _navigateToEvent(event),
          enableDrag: false,
          onEdit: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditPage(note: event.note!),
            ),
          ),
          onDelete: () async {
            // Реализовать удаление заметки
            await _loadEvents();
          },
        );
      default:
        return _CalendarEventItem(
          event: event,
          onTap: () => _navigateToEvent(event),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayEvents =
        _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: CommonEditAppBar(
        title: S.of(context).event_calendar,
        additionalActions: [_buildFilterButton(context)],
        onSave: null,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              eventLoader: _getEventsForDay,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                markerSize: 6,
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonDecoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                formatButtonTextStyle: Theme.of(context).textTheme.bodyMedium!,
                titleTextStyle: Theme.of(context).textTheme.titleLarge!,
                leftChevronIcon: Icon(Icons.chevron_left,
                    color: Theme.of(context).colorScheme.primary),
                rightChevronIcon: Icon(Icons.chevron_right,
                    color: Theme.of(context).colorScheme.primary),
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.week: 'Week',
                CalendarFormat.twoWeeks: '2 Weeks',
              },
            ),
          ),
          Expanded(
            child: dayEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).no_events,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              S.of(context).events,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                dayEvents.length.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: dayEvents.length,
                          itemBuilder: (context, index) {
                            final event = dayEvents[index];
                            return _buildEventCard(event);
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

enum CalendarEventType {
  all,
  character,
  race,
  note,
}

class CalendarEvent {
  final DateTime date;
  final CalendarEventType type;
  final Character? character;
  final Race? race;
  final Note? note;

  CalendarEvent({
    required this.date,
    required this.type,
    this.character,
    this.race,
    this.note,
  });

  factory CalendarEvent.character({
    required DateTime date,
    required Character character,
  }) {
    return CalendarEvent(
      date: date,
      type: CalendarEventType.character,
      character: character,
    );
  }

  factory CalendarEvent.race({
    required DateTime date,
    required Race race,
  }) {
    return CalendarEvent(
      date: date,
      type: CalendarEventType.race,
      race: race,
    );
  }

  factory CalendarEvent.note({
    required DateTime date,
    required Note note,
  }) {
    return CalendarEvent(
      date: date,
      type: CalendarEventType.note,
      note: note,
    );
  }

  String getTitle(BuildContext context) {
    switch (type) {
      case CalendarEventType.character:
        return character?.name ?? S.of(context).character;
      case CalendarEventType.race:
        return race?.name ?? S.of(context).race;
      case CalendarEventType.note:
        return note?.title ?? S.of(context).posts;
      default:
        return S.of(context).event;
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
      default:
        return '${S.of(context).event} • $time';
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
      default:
        return Icons.event;
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
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String getActionText(BuildContext context) {
    return S.of(context).go_to_event;
  }
}

class _CalendarEventItem extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback onTap;

  const _CalendarEventItem({
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: event.getColor(context).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            event.icon,
            color: event.getColor(context),
          ),
        ),
        title: Text(
          event.getTitle(context),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(event.getSubtitle(context)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.outline,
        ),
        onTap: onTap,
      ),
    );
  }
}
