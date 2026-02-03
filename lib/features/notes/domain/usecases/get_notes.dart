import 'package:dartz/dartz.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

// Use case to get all notes
class GetNotes {
  final NoteRepository repository;

  GetNotes(this.repository);

  Future<Either<String, List<Note>>> call() async {
    return await repository.getNotes();
  }
}
