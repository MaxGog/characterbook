import 'package:characterbook/features/characters/domain/custom_field_model.dart';
import 'package:characterbook/features/races/domain/race_model.dart';
import 'dart:typed_data';

class Character {
  static const _unset = Object();

  String id;

  String name;

  int age;

  String gender;

  String biography;

  String personality;

  String appearance;

  Uint8List? imageBytes;

  String abilities;

  String other;

  Uint8List? referenceImageBytes;

  List<CustomField> customFields;

  List<Uint8List> additionalImages;

  DateTime lastEdited;

  Race? race;

  String? folderId;

  List<String> tags;

  Character({
    String? id,
    this.name = '',
    this.age = 0,
    this.gender = '',
    this.biography = '',
    this.personality = '',
    this.appearance = '',
    this.abilities = '',
    this.other = '',
    this.imageBytes,
    this.referenceImageBytes,
    this.race,
    List<String> tags = const [],
    List<CustomField>? customFields,
    List<Uint8List>? additionalImages,
    DateTime? lastEdited,
    this.folderId,
  })  : id = (id == null || id.isEmpty) ? _generateUniqueId() : id,
        customFields = customFields ?? [],
        additionalImages = additionalImages ?? [],
        lastEdited = lastEdited ?? DateTime.now(),
        tags = List.from(tags);

  static String _generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    return '${timestamp}_$random';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'biography': biography,
      'personality': personality,
      'appearance': appearance,
      'abilities': abilities,
      'other': other,
      'imageBytes': imageBytes?.toList(),
      'referenceImageBytes': referenceImageBytes?.toList(),
      'customFields':
          customFields.map((f) => {'key': f.key, 'value': f.value}).toList(),
      'additionalImages': additionalImages.map((img) => img.toList()).toList(),
      'lastEdited': lastEdited.toIso8601String(),
      'race': race?.name,
      'raceId': race?.id,
      'folderId': folderId,
      'tags': tags,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    final raceName = json['race'] as String?;
    final raceId = json['raceId'] as String?;
    final Race? parsedRace = raceName != null
        ? Race(id: raceId ?? _generateUniqueId(), name: raceName)
        : null;

    return Character(
      id: (json['id'] as String?)?.isNotEmpty == true
          ? json['id']
          : _generateUniqueId(),
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      biography: json['biography'] ?? '',
      personality: json['personality'] ?? '',
      appearance: json['appearance'] ?? '',
      abilities: json['abilities'] ?? '',
      other: json['other'] ?? '',
      imageBytes: json['imageBytes'] != null
          ? Uint8List.fromList(List<int>.from(json['imageBytes']))
          : null,
      referenceImageBytes: json['referenceImageBytes'] != null
          ? Uint8List.fromList(List<int>.from(json['referenceImageBytes']))
          : null,
      customFields: (json['customFields'] as List?)
              ?.map((e) => CustomField(e['key'] ?? '', e['value'] ?? ''))
              .toList() ??
          [],
      additionalImages: (json['additionalImages'] as List?)
              ?.map((e) => Uint8List.fromList(List<int>.from(e)))
              .toList() ??
          [],
      lastEdited: json['lastEdited'] != null
          ? DateTime.parse(json['lastEdited'])
          : DateTime.now(),
      race: parsedRace,
      folderId: json['folderId'] as String?,
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
    );
  }

  void updateLastEdited() {
    lastEdited = DateTime.now();
  }

  factory Character.empty() {
    return Character(
      id: '',
      name: '',
      age: 20,
      gender: 'male',
      biography: '',
      personality: '',
      appearance: '',
      abilities: '',
      other: '',
      imageBytes: null,
      referenceImageBytes: null,
      customFields: [],
      additionalImages: [],
      race: null,
      tags: [],
    );
  }

  Character copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? biography,
    String? personality,
    String? appearance,
    String? abilities,
    String? other,
    Uint8List? imageBytes,
    Uint8List? referenceImageBytes,
    List<CustomField>? customFields,
    List<Uint8List>? additionalImages,
    Object? race = _unset,
    String? folderId,
    List<String>? tags,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      biography: biography ?? this.biography,
      personality: personality ?? this.personality,
      appearance: appearance ?? this.appearance,
      abilities: abilities ?? this.abilities,
      other: other ?? this.other,
      imageBytes: imageBytes ?? this.imageBytes,
      referenceImageBytes: referenceImageBytes ?? this.referenceImageBytes,
      customFields: customFields != null
          ? customFields.map((f) => f.copyWith()).toList()
          : this.customFields.map((f) => f.copyWith()).toList(),
      additionalImages: additionalImages ?? List.from(this.additionalImages),
      race: identical(race, _unset) ? this.race : race as Race?,
      folderId: folderId ?? this.folderId,
      tags: tags ?? List.from(this.tags),
      lastEdited: DateTime.now(),
    );
  }

  Map<String, dynamic> toExportMap() {
    return {
      'type': 'character',
      'id': id,
      'name': name,
      'description': biography,
      'mainImage': mainImage,
      'additionalImages': additionalImages,
      'tags': tags,
      'lastEdited': lastEdited,
      'details': {
        'age': age,
        'gender': gender,
        'biography': biography,
        'personality': personality,
        'appearance': appearance,
        'abilities': abilities,
        'other': other,
        'race': race?.name,
        'customFields':
            customFields.map((f) => {'key': f.key, 'value': f.value}).toList(),
        'referenceImage': referenceImageBytes,
      }
    };
  }

  String get modelType => 'character';

  String get description => biography;

  Uint8List? get mainImage => imageBytes ?? referenceImageBytes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
