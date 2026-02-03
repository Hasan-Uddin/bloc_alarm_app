import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'note_model.g.dart';

// Note data model with Hive and JSON serialization
@HiveType(typeId: 0)
class NoteModel extends Equatable {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  const NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      content:
          json['body'] as String? ?? '', // API uses 'body' instead of 'content'
      createdAt:
          DateTime.now(), // if API doesn't provide these, so we set current time
      updatedAt: DateTime.now(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'body': content,
      'userId': 1, // Default user ID for JSONPlaceholder
    };
  }

  // CopyWith method
  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, content, createdAt, updatedAt];

  @override
  String toString() {
    return 'NoteModel(id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
