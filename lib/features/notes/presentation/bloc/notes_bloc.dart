import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/base/base_event.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_notes.dart';

// Notes List Events
abstract class NotesEvent extends BaseEvent {
  const NotesEvent();
}

class LoadNotesEvent extends NotesEvent {
  const LoadNotesEvent();
}

class RefreshNotesEvent extends NotesEvent {
  const RefreshNotesEvent();
}

class DeleteNoteEvent extends NotesEvent {
  final int noteId;

  const DeleteNoteEvent(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

// Notes List States
abstract class NotesState extends BaseState {
  const NotesState();
}

class NotesInitial extends NotesState {
  const NotesInitial();
}

class NotesLoading extends NotesState {
  const NotesLoading();
}

class NotesLoaded extends NotesState {
  final List<Note> notes;

  const NotesLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

class NotesEmpty extends NotesState {
  const NotesEmpty();
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}

class NoteDeleting extends NotesState {
  final int noteId;

  const NoteDeleting(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

// Notes BLoC for managing notes list
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetNotes getNotes;
  final DeleteNote deleteNote;

  NotesBloc({
    required this.getNotes,
    required this.deleteNote,
  }) : super(const NotesInitial()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<RefreshNotesEvent>(_onRefreshNotes);
    on<DeleteNoteEvent>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(
    LoadNotesEvent event,
    Emitter<NotesState> emit,
  ) async {
    emit(const NotesLoading());
    
    final result = await getNotes();
    
    result.fold(
      (error) => emit(NotesError(error)),
      (notes) {
        if (notes.isEmpty) {
          emit(const NotesEmpty());
        } else {
          emit(NotesLoaded(notes));
        }
      },
    );
  }

  Future<void> _onRefreshNotes(
    RefreshNotesEvent event,
    Emitter<NotesState> emit,
  ) async {
    // Don't show loading state on refresh, keep current state
    final result = await getNotes();
    
    result.fold(
      (error) => emit(NotesError(error)),
      (notes) {
        if (notes.isEmpty) {
          emit(const NotesEmpty());
        } else {
          emit(NotesLoaded(notes));
        }
      },
    );
  }

  Future<void> _onDeleteNote(
    DeleteNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    emit(NoteDeleting(event.noteId));
    
    final result = await deleteNote(event.noteId);
    
    result.fold(
      (error) => emit(NotesError(error)),
      (_) {
        // Reload notes after deletion
        add(const LoadNotesEvent());
      },
    );
  }
}
