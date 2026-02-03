import 'package:dartz/dartz.dart';
import '../../../../helpers/logger.dart';
import '../../../../networks/api_error.dart';
import '../../../../networks/network_info.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_datasource.dart';
import '../datasources/note_remote_datasource.dart';
import '../models/note_model.dart';

// Implementation of note repository with caching strategy
class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;
  final NoteRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NoteRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<String, List<Note>>> getNotes() async {
    try {
      // Check network connectivity
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        // Try to fetch from API
        try {
          final remoteNotes = await remoteDataSource.getNotes();
          // Save to local storage for offline access
          await localDataSource.saveNotes(remoteNotes);
          // Convert models to entities
          final notes = remoteNotes.map((model) => _modelToEntity(model)).toList();
          return Right(notes);
        } on ApiError catch (e) {
          AppLogger.warning('API error, falling back to local storage', e);
          // Fall back to local storage
          return await _getLocalNotes();
        }
      } else {
        // No connection, use local storage
        return await _getLocalNotes();
      }
    } catch (e) {
      AppLogger.error('Error getting notes', e);
      return Left('Failed to load notes: ${e.toString()}');
    }
  }

  Future<Either<String, List<Note>>> _getLocalNotes() async {
    try {
      final localNotes = await localDataSource.getNotes();
      final notes = localNotes.map((model) => _modelToEntity(model)).toList();
      return Right(notes);
    } catch (e) {
      return Left('Failed to load local notes: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Note>> createNote(String title, String content) async {
    try {
      final now = DateTime.now();
      final noteModel = NoteModel(
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );

      // Save to local storage first (for offline support)
      await localDataSource.saveNote(noteModel);

      // Try to sync with API if connected
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        try {
          final remoteNote = await remoteDataSource.createNote(noteModel);
          // Update local storage with server ID
          final updatedNote = noteModel.copyWith(id: remoteNote.id);
          await localDataSource.saveNote(updatedNote);
          return Right(_modelToEntity(updatedNote));
        } on ApiError catch (e) {
          AppLogger.warning('Failed to sync with API, note saved locally', e);
          // Return local note even if API fails
          return Right(_modelToEntity(noteModel));
        }
      }

      return Right(_modelToEntity(noteModel));
    } catch (e) {
      AppLogger.error('Error creating note', e);
      return Left('Failed to create note: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Note>> updateNote(int id, String title, String content) async {
    try {
      final noteModel = NoteModel(
        id: id,
        title: title,
        content: content,
        createdAt: DateTime.now(), // Will be overwritten by actual value if exists
        updatedAt: DateTime.now(),
      );

      // Update local storage first
      await localDataSource.saveNote(noteModel);

      // Try to sync with API if connected
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        try {
          await remoteDataSource.updateNote(noteModel);
        } on ApiError catch (e) {
          AppLogger.warning('Failed to sync update with API', e);
        }
      }

      return Right(_modelToEntity(noteModel));
    } catch (e) {
      AppLogger.error('Error updating note', e);
      return Left('Failed to update note: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteNote(int id) async {
    try {
      // Delete from local storage first
      await localDataSource.deleteNote(id);

      // Try to sync with API if connected
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        try {
          await remoteDataSource.deleteNote(id);
        } on ApiError catch (e) {
          AppLogger.warning('Failed to sync deletion with API', e);
        }
      }

      return const Right(null);
    } catch (e) {
      AppLogger.error('Error deleting note', e);
      return Left('Failed to delete note: ${e.toString()}');
    }
  }

  // Helper to convert model to entity
  Note _modelToEntity(NoteModel model) {
    return Note(
      id: model.id,
      title: model.title,
      content: model.content,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
