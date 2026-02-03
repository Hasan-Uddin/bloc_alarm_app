import 'package:hive_flutter/hive_flutter.dart';
import '../../../../constants/storage_keys.dart';
import '../../../../helpers/logger.dart';
import '../models/note_model.dart';

// Note local data source abstract class
abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<NoteModel?> getNoteById(int id);
  Future<void> saveNote(NoteModel note);
  Future<void> saveNotes(List<NoteModel> notes);
  Future<void> deleteNote(int id);
  Future<void> clearAllNotes();
}

// Implementation of note local data source using Hive
class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  Box<NoteModel>? _notesBox;

  Future<Box<NoteModel>> get notesBox async {
    if (_notesBox == null || !_notesBox!.isOpen) {
      _notesBox = await Hive.openBox<NoteModel>(StorageKeys.notesBox);
    }
    return _notesBox!;
  }

  @override
  Future<List<NoteModel>> getNotes() async {
    try {
      final box = await notesBox;
      final notes = box.values.toList();
      // Sort by updated date (newest first)
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      AppLogger.debug('Loaded ${notes.length} notes from local storage');
      return notes;
    } catch (e) {
      AppLogger.error('Error getting notes from local storage', e);
      return [];
    }
  }

  @override
  Future<NoteModel?> getNoteById(int id) async {
    try {
      final box = await notesBox;
      final note = box.values.firstWhere(
        (note) => note.id == id,
        orElse: () => throw Exception('Note not found'),
      );
      return note;
    } catch (e) {
      AppLogger.error('Error getting note by id from local storage', e);
      return null;
    }
  }

  @override
  Future<void> saveNote(NoteModel note) async {
    try {
      final box = await notesBox;
      // Use note id as key if available, otherwise generate unique key
      final key = note.id ?? DateTime.now().millisecondsSinceEpoch;
      await box.put(key, note);
      AppLogger.debug('Saved note to local storage: ${note.title}');
    } catch (e) {
      AppLogger.error('Error saving note to local storage', e);
      rethrow;
    }
  }

  @override
  Future<void> saveNotes(List<NoteModel> notes) async {
    try {
      final box = await notesBox;
      final notesMap = <dynamic, NoteModel>{};
      for (final note in notes) {
        final key = note.id ?? DateTime.now().millisecondsSinceEpoch;
        notesMap[key] = note;
      }
      await box.putAll(notesMap);
      AppLogger.debug('Saved ${notes.length} notes to local storage');
    } catch (e) {
      AppLogger.error('Error saving notes to local storage', e);
      rethrow;
    }
  }

  @override
  Future<void> deleteNote(int id) async {
    try {
      final box = await notesBox;
      await box.delete(id);
      AppLogger.debug('Deleted note from local storage: $id');
    } catch (e) {
      AppLogger.error('Error deleting note from local storage', e);
      rethrow;
    }
  }

  @override
  Future<void> clearAllNotes() async {
    try {
      final box = await notesBox;
      await box.clear();
      AppLogger.debug('Cleared all notes from local storage');
    } catch (e) {
      AppLogger.error('Error clearing notes from local storage', e);
      rethrow;
    }
  }
}
