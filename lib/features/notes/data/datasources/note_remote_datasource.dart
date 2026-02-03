import '../../../../constants/api_endpoints.dart';
import '../../../../helpers/logger.dart';
import '../../../../networks/dio_client.dart';
import '../models/note_model.dart';

// Note remote data source abstract class
abstract class NoteRemoteDataSource {
  Future<List<NoteModel>> getNotes();
  Future<NoteModel> createNote(NoteModel note);
  Future<NoteModel> updateNote(NoteModel note);
  Future<void> deleteNote(int id);
}

// Implementation of note remote data source using JSONPlaceholder API
class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  @override
  Future<List<NoteModel>> getNotes() async {
    try {
      final response = await DioClient.get(ApiEndpoints.notes);
      final List<dynamic> data = response.data as List<dynamic>;
      final notes = data.map((json) => NoteModel.fromJson(json as Map<String, dynamic>)).toList();
      AppLogger.debug('Fetched ${notes.length} notes from API');
      return notes;
    } catch (e) {
      AppLogger.error('Error fetching notes from API', e);
      rethrow;
    }
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    try {
      final response = await DioClient.post(
        ApiEndpoints.notes,
        data: note.toJson(),
      );
      final createdNote = NoteModel.fromJson(response.data as Map<String, dynamic>);
      AppLogger.debug('Created note via API: ${createdNote.title}');
      return createdNote;
    } catch (e) {
      AppLogger.error('Error creating note via API', e);
      rethrow;
    }
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      final response = await DioClient.put(
        ApiEndpoints.noteById(note.id!),
        data: note.toJson(),
      );
      final updatedNote = NoteModel.fromJson(response.data as Map<String, dynamic>);
      AppLogger.debug('Updated note via API: ${updatedNote.title}');
      return updatedNote;
    } catch (e) {
      AppLogger.error('Error updating note via API', e);
      rethrow;
    }
  }

  @override
  Future<void> deleteNote(int id) async {
    try {
      await DioClient.delete(ApiEndpoints.noteById(id));
      AppLogger.debug('Deleted note via API: $id');
    } catch (e) {
      AppLogger.error('Error deleting note via API', e);
      rethrow;
    }
  }
}
