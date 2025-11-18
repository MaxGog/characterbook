import 'package:characterbook/models/characters/character_model.dart';
import 'package:characterbook/models/custom_field_model.dart';
import 'package:characterbook/models/race_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'character_universal_model.g.dart';

@HiveType(typeId: 10)
class CharacterUniversal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int age;

  @HiveField(3)
  String gender;

  @HiveField(4)
  Race? race;

  @HiveField(5)
  List<CustomField> customFields;

  @HiveField(6)
  Uint8List? imageBytes;

  @HiveField(7)
  List<Uint8List> additionalImages;

  @HiveField(8)
  DateTime lastEdited;

  @HiveField(9)
  String? folderId;

  @HiveField(10, defaultValue: [])
  List<String> tags;

  CharacterUniversal({
    String? id,
    this.name = '',
    this.age = 0,
    this.gender = 'male',
    this.race,
    List<String> tags = const [],
    List<CustomField>? customFields,
    List<Uint8List>? additionalImages,
    DateTime? lastEdited,
    this.folderId,
    this.imageBytes,
  })  : id = id ?? '',
        customFields = customFields ?? [],
        additionalImages = additionalImages ?? [],
        lastEdited = lastEdited ?? DateTime.now(),
        tags = List.from(tags);

  factory CharacterUniversal.fromV1(Character v1) {
    final customFields = <CustomField>[
      if (v1.biography.isNotEmpty) 
        CustomField('Биография', v1.biography),
      if (v1.personality.isNotEmpty) 
        CustomField('Характер', v1.personality),
      if (v1.appearance.isNotEmpty) 
        CustomField('Внешность', v1.appearance),
      if (v1.abilities.isNotEmpty) 
        CustomField('Способности', v1.abilities),
      if (v1.other.isNotEmpty) 
        CustomField('Другое', v1.other),
      ...v1.customFields,
    ];

    return CharacterUniversal(
      id: v1.id,
      name: v1.name,
      age: v1.age,
      gender: v1.gender,
      race: v1.race,
      tags: v1.tags,
      customFields: customFields,
      additionalImages: v1.additionalImages,
      lastEdited: v1.lastEdited,
      folderId: v1.folderId,
      imageBytes: v1.imageBytes,
    );
  }

  Character toV1() {
    String getCustomFieldValue(String key) {
      final field = customFields.firstWhere(
        (f) => f.key == key,
        orElse: () => CustomField(key, ''),
      );
      return field.value;
    }

    return Character(
      id: id,
      name: name,
      age: age,
      gender: gender,
      race: race,
      tags: tags,
      customFields: customFields.where((f) => 
        !['Биография', 'Характер', 'Внешность', 'Способности', 'Другое'].contains(f.key)
      ).toList(),
      additionalImages: additionalImages,
      lastEdited: lastEdited,
      folderId: folderId,
      imageBytes: imageBytes,
      biography: getCustomFieldValue('Биография'),
      personality: getCustomFieldValue('Характер'),
      appearance: getCustomFieldValue('Внешность'),
      abilities: getCustomFieldValue('Способности'),
      other: getCustomFieldValue('Другое'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'race': race?.toJson(),
      'customFields': customFields.map((f) => f.toJson()).toList(),
      'imageBytes': imageBytes?.toList(),
      'additionalImages': additionalImages.map((img) => img.toList()).toList(),
      'lastEdited': lastEdited.toIso8601String(),
      'folderId': folderId,
      'tags': tags,
    };
  }

  factory CharacterUniversal.fromJson(Map<String, dynamic> json) {
    return CharacterUniversal(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? 'male',
      race: json['race'] != null ? Race.fromJson(json['race']) : null,
      customFields: (json['customFields'] as List?)?.map((e) => 
        CustomField.fromJson(e)).toList() ?? [],
      imageBytes: json['imageBytes'] != null
          ? Uint8List.fromList(List<int>.from(json['imageBytes']))
          : null,
      additionalImages: (json['additionalImages'] as List?)?.map((e) =>
          Uint8List.fromList(List<int>.from(e))).toList() ?? [],
      lastEdited: json['lastEdited'] != null
          ? DateTime.parse(json['lastEdited'])
          : DateTime.now(),
      folderId: json['folderId'],
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
    );
  }

  CharacterUniversal copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    Race? race,
    List<CustomField>? customFields,
    Uint8List? imageBytes,
    List<Uint8List>? additionalImages,
    DateTime? lastEdited,
    String? folderId,
    List<String>? tags,
  }) {
    return CharacterUniversal(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      race: race ?? this.race,
      customFields: customFields ?? List.from(this.customFields),
      imageBytes: imageBytes ?? this.imageBytes,
      additionalImages: additionalImages ?? List.from(this.additionalImages),
      lastEdited: lastEdited ?? this.lastEdited,
      folderId: folderId ?? this.folderId,
      tags: tags ?? List.from(this.tags),
    );
  }

  factory CharacterUniversal.empty() {
    return CharacterUniversal(
      id: '',
      name: '',
      age: 20,
      gender: 'male',
      race: null,
      customFields: [],
      additionalImages: [],
      tags: [],
    );
  }

  void updateLastEdited() {
    lastEdited = DateTime.now();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterUniversal &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          age == other.age &&
          gender == other.gender &&
          race == other.race &&
          folderId == other.folderId &&
          listEquals(customFields, other.customFields) &&
          listEquals(tags, other.tags);

  @override
  int get hashCode => Object.hash(
        id,
        name,
        age,
        gender,
        race,
        folderId,
        Object.hashAll(customFields),
        Object.hashAll(tags),
      );

  String getCustomFieldValue(String key) {
    final field = customFields.firstWhere(
      (f) => f.key == key,
      orElse: () => CustomField(key, ''),
    );
    return field.value;
  }

  void setCustomFieldValue(String key, String value) {
    final index = customFields.indexWhere((f) => f.key == key);
    if (index >= 0) {
      customFields[index] = customFields[index].copyWith(value: value);
    } else {
      customFields.add(CustomField(key, value));
    }
    updateLastEdited();
  }

  void removeCustomField(String key) {
    customFields.removeWhere((f) => f.key == key);
    updateLastEdited();
  }

  bool hasCustomField(String key) {
    return customFields.any((f) => f.key == key);
  }
}