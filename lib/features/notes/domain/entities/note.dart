import 'package:equatable/equatable.dart';

// Note entity (domain model)
class Note extends Equatable {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, content, createdAt, updatedAt];
}
