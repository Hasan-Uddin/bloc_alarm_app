import 'package:dartz/dartz.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

// Use case to create a note
class CreateNote {
  final NoteRepository repository;

  CreateNote(this.repository);

  Future<Either<String, Note>> call(String title, String content) async {
    // Validation
    if (title.trim().isEmpty) {
      return const Left('Title cannot be empty');
    }
    if (content.trim().isEmpty) {
      return const Left('Content cannot be empty');
    }

    return await repository.createNote(title, content);
  }
}
