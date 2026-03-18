import 'package:flutter/material.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/relationship_model.dart';
import 'package:characterbook/services/character_service.dart';
import 'package:characterbook/services/relationship_service.dart';
import 'package:provider/provider.dart';

class EditRelationshipDialog extends StatefulWidget {
  final Relationship? relationship;
  const EditRelationshipDialog({Key? key, this.relationship}) : super(key: key);

  @override
  _EditRelationshipDialogState createState() => _EditRelationshipDialogState();
}

class _EditRelationshipDialogState extends State<EditRelationshipDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late String _type;
  late bool _directed;
  Character? _character1;
  Character? _character2;

  @override
  void initState() {
    super.initState();
    final rel = widget.relationship;
    _name = rel?.name ?? '';
    _description = rel?.description ?? '';
    _type = rel?.type ?? '';
    _directed = rel?.directed ?? false;
    // TODO: загрузить объекты персонажей по их ID (потребуется CharacterService)
  }

  @override
  Widget build(BuildContext context) {
    final characterService = Provider.of<CharacterService>(context);
    final relationshipService = Provider.of<RelationshipService>(context);

    return AlertDialog(
      title: Text(widget.relationship == null
          ? 'Add Relationship'
          : 'Edit Relationship'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<List<Character>>(
                future: characterService.getAllCharacters(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final characters = snapshot.data!;
                  return DropdownButtonFormField<Character>(
                    value: _character1,
                    items: characters
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.name),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _character1 = value),
                    decoration: InputDecoration(labelText: 'Character 1'),
                    validator: (value) => value == null ? 'Required' : null,
                  );
                },
              ),
              FutureBuilder<List<Character>>(
                future: characterService.getAllCharacters(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final characters = snapshot.data!;
                  return DropdownButtonFormField<Character>(
                    value: _character2,
                    items: characters
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.name),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _character2 = value),
                    decoration: InputDecoration(labelText: 'Character 2'),
                    validator: (value) => value == null ? 'Required' : null,
                  );
                },
              ),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Relationship Name'),
                onSaved: (val) => _name = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (val) => _description = val ?? '',
              ),
              TextFormField(
                initialValue: _type,
                decoration: InputDecoration(labelText: 'Type (optional)'),
                onSaved: (val) => _type = val ?? '',
              ),
              CheckboxListTile(
                title: Text('Directed relationship'),
                value: _directed,
                onChanged: (val) => setState(() => _directed = val ?? false),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              if (_character1 == null || _character2 == null) return;
              final exists = await relationshipService.relationshipExists(
                  _character1!.id, _character2!.id);
              if (exists && widget.relationship == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Relationship already exists')));
                return;
              }
              final rel = Relationship(
                id: widget.relationship?.id,
                character1Id: _character1!.id,
                character2Id: _character2!.id,
                name: _name,
                description: _description,
                type: _type.isNotEmpty ? _type : null,
                directed: _directed,
              );
              await relationshipService.saveRelationship(rel,
                  key: widget.relationship?.key);
              Navigator.pop(context);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
