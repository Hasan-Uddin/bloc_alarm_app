import 'package:dartz/dartz.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

// Use case to update a note
class UpdateNote {
  final NoteRepository repository;

  UpdateNote(this.repository);

  Future<Either<String, Note>> call(int id, String title, String content) async {
    // Validation
    if (title.trim().isEmpty) {
      return const Left('Title cannot be empty');
    }
    if (content.trim().isEmpty) {
      return const Left('Content cannot be empty');
    }

    return await repository.updateNote(id, title, content);
  }
}
