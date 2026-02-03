import 'package:dartz/dartz.dart';
import '../repositories/note_repository.dart';

// Use case to delete a note
class DeleteNote {
  final NoteRepository repository;

  DeleteNote(this.repository);

  Future<Either<String, void>> call(int id) async {
    return await repository.deleteNote(id);
  }
}
