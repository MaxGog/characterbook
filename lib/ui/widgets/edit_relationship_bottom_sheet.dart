import 'package:flutter/material.dart';
import 'package:characterbook/models/character_model.dart';
import 'package:characterbook/models/relationship_model.dart';
import 'package:characterbook/services/character_service.dart';
import 'package:characterbook/services/relationship_service.dart';
import 'package:provider/provider.dart';

class EditRelationshipBottomSheet extends StatefulWidget {
  final Relationship? relationship;

  const EditRelationshipBottomSheet({super.key, this.relationship});

  @override
  State<EditRelationshipBottomSheet> createState() =>
      _EditRelationshipBottomSheetState();
}

class _EditRelationshipBottomSheetState
    extends State<EditRelationshipBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final String _initialName;
  late final String _initialDescription;
  late final String _initialType;
  late final bool _initialDirected;

  late String _name;
  late String _description;
  late String _type;
  late bool _directed;

  Character? _character1;
  Character? _character2;
  List<Character>? _characters;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final rel = widget.relationship;
    _initialName = rel?.name ?? '';
    _initialDescription = rel?.description ?? '';
    _initialType = rel?.type ?? '';
    _initialDirected = rel?.directed ?? false;

    _name = _initialName;
    _description = _initialDescription;
    _type = _initialType;
    _directed = _initialDirected;

    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    final characterService =
        Provider.of<CharacterService>(context, listen: false);
    final characters = await characterService.getAllCharacters();

    if (!mounted) return;

    final unique = characters.toSet().toList();

    debugPrint('Загружено персонажей: ${unique.length}');
    for (var c in unique) {
      debugPrint(' - ${c.name} (${c.id})');
    }

    setState(() {
      _characters = unique;
      _isLoading = false;

      final rel = widget.relationship;
      if (rel != null) {
        _character1 = unique.firstWhere(
          (c) => c.id == rel.character1Id,
        ) as Character?;
        _character2 = unique.firstWhere(
          (c) => c.id == rel.character2Id,
        ) as Character?;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_character1 == null || _character2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите обоих персонажей')),
      );
      return;
    }

    if (_character1!.id == _character2!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Нельзя создать связь персонажа с самим собой')),
      );
      return;
    }

    final relationshipService =
        Provider.of<RelationshipService>(context, listen: false);

    if (widget.relationship == null) {
      final exists = await relationshipService.relationshipExists(
        _character1!.id,
        _character2!.id,
      );
      if (exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Такая связь уже существует')),
          );
        }
        return;
      }
    }

    final relationship = Relationship(
      id: widget.relationship?.id,
      character1Id: _character1!.id,
      character2Id: _character2!.id,
      name: _name.trim(),
      description: _description.trim(),
      type: _type.trim().isEmpty ? null : _type.trim(),
      directed: _directed,
    );

    await relationshipService.saveRelationship(
      relationship,
      key: widget.relationship?.key,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.relationship == null
                ? 'Создание связи'
                : 'Редактирование связи',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          DropdownButtonFormField<Character>(
                            value: _character1,
                            isExpanded: true,
                            items: _characters?.map((c) {
                              return DropdownMenuItem<Character>(
                                key: ValueKey(c.id),
                                value: c,
                                child: Row(
                                  children: [
                                    _buildCharacterAvatar(c),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(c.name)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _character1 = value;
                                // Если выбрали того же, что и во втором поле, сбросим второе?
                                if (_character2 != null &&
                                    value != null &&
                                    _character2!.id == value.id) {
                                  _character2 = null;
                                }
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Персонаж 1',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null ? 'Выберите персонажа' : null,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<Character>(
                            value: _character2,
                            isExpanded: true,
                            items: _characters?.map((c) {
                              return DropdownMenuItem<Character>(
                                key: ValueKey(c.id),
                                value: c,
                                child: Row(
                                  children: [
                                    _buildCharacterAvatar(c),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(c.name)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _character2 = value;
                                if (_character1 != null &&
                                    value != null &&
                                    _character1!.id == value.id) {
                                  _character1 = null;
                                }
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Персонаж 2',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null ? 'Выберите персонажа' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: _initialName,
                            decoration: const InputDecoration(
                              labelText: 'Название связи',
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (val) => _name = val ?? '',
                            validator: (val) => val?.trim().isEmpty == true
                                ? 'Введите название'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: _initialDescription,
                            decoration: const InputDecoration(
                              labelText: 'Описание',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            onSaved: (val) => _description = val ?? '',
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: _initialType,
                            decoration: const InputDecoration(
                              labelText: 'Тип (необязательно)',
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (val) => _type = val ?? '',
                          ),
                          const SizedBox(height: 8),
                          CheckboxListTile(
                            title: const Text('Направленная связь'),
                            value: _directed,
                            onChanged: (val) =>
                                setState(() => _directed = val ?? false),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Сохранить'),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCharacterAvatar(Character character) {
    final hasAvatar = character.imageBytes != null;
    return CircleAvatar(
      radius: 14,
      backgroundColor: hasAvatar ? null : Theme.of(context).primaryColor,
      backgroundImage: hasAvatar ? MemoryImage(character.imageBytes!) : null,
      child: !hasAvatar
          ? Text(
              character.name.isNotEmpty ? character.name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            )
          : null,
    );
  }
}
