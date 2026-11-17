import 'dart:math';

class Note {
  String id;

  String title;

  String content;

  DateTime createdAt;

  DateTime updatedAt;

  List<String> characterIds;

  List<String> tags;

  String? folderId;

  Note({
    String? id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.tags = const [],
    this.characterIds = const [],
    required this.folderId,
  })  : id = (id == null || id.isEmpty) ? _generateUniqueId() : id,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'characterIds': characterIds,
        'folderId': folderId,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      characterIds: List<String>.from(json['characterIds'] ?? []),
      folderId: json['folderId']);

  static String _generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(1000000);
    return '${timestamp}_$random';
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? characterIds,
    List<String>? tags,
    String? folderId,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      characterIds: characterIds ?? List.from(this.characterIds),
      tags: tags ?? List.from(this.tags),
      folderId: folderId ?? this.folderId,
    );
  }
}
