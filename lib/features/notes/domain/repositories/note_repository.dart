import 'package:dartz/dartz.dart';
import '../../domain/entities/note.dart';

// Note repository interface
abstract class NoteRepository {
  Future<Either<String, List<Note>>> getNotes();
  Future<Either<String, Note>> createNote(String title, String content);
  Future<Either<String, Note>> updateNote(int id, String title, String content);
  Future<Either<String, void>> deleteNote(int id);
}
