import 'package:characterbook/generated/l10n.dart';
import 'package:characterbook/data/models/race_model.dart';
import 'package:characterbook/ui/screens/races/race_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RaceSelectorField extends StatefulWidget {
  final Race? initialRace;
  final ValueChanged<Race?>? onChanged;

  final bool isRequired;

  const RaceSelectorField({
    super.key,
    this.initialRace,
    this.onChanged,
    this.isRequired = false,
  });

  @override
  State<RaceSelectorField> createState() => _RaceSelectorFieldState();
}

class _RaceSelectorFieldState extends State<RaceSelectorField> {
  Race? _selectedRace;

  @override
  void initState() {
    super.initState();
    _selectedRace = widget.initialRace;
  }

  @override
  void didUpdateWidget(RaceSelectorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldId = oldWidget.initialRace?.id;
    final newId = widget.initialRace?.id;
    if (oldId != newId) {
      _selectedRace = widget.initialRace;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return ValueListenableBuilder(
      valueListenable: Hive.box<Race>('races').listenable(),
      builder: (context, Box<Race> box, _) {
        final races = box.values.toList();

        if (_selectedRace != null &&
            !races.any((r) => r.id == _selectedRace!.id)) {
          _selectedRace = null;
        }

        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<Race?>(
                value: _selectedRace,
                decoration: InputDecoration(
                  labelText: widget.isRequired ? '${s.race} *' : s.race,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  DropdownMenuItem<Race?>(
                    value: null,
                    child: Text(
                      s.not_selected,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  ...races.map(
                    (race) => DropdownMenuItem<Race?>(
                      value: race,
                      child: Text(race.name),
                    ),
                  ),
                ],
                onChanged: (race) {
                  setState(() => _selectedRace = race);
                  widget.onChanged?.call(race);
                },
                validator: widget.isRequired
                    ? (value) {
                        if (value == null) return s.select_race_error;
                        return null;
                      }
                    : null,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RaceManagementScreen(),
                  ),
                );
              },
              tooltip: s.race_management,
            ),
          ],
        );
      },
    );
  }
}
