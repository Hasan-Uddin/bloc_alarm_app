import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/base/base_event.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/create_note.dart';
import '../../domain/usecases/update_note.dart';

// Note Form Events
abstract class NoteFormEvent extends BaseEvent {
  const NoteFormEvent();
}

class CreateNoteEvent extends NoteFormEvent {
  final String title;
  final String content;

  const CreateNoteEvent({
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [title, content];
}

class UpdateNoteEvent extends NoteFormEvent {
  final int noteId;
  final String title;
  final String content;

  const UpdateNoteEvent({
    required this.noteId,
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [noteId, title, content];
}

// Note Form States
abstract class NoteFormState extends BaseState {
  const NoteFormState();
}

class NoteFormInitial extends NoteFormState {
  const NoteFormInitial();
}

class NoteFormSubmitting extends NoteFormState {
  const NoteFormSubmitting();
}

class NoteFormSuccess extends NoteFormState {
  final Note note;
  final String message;

  const NoteFormSuccess({
    required this.note,
    required this.message,
  });

  @override
  List<Object?> get props => [note, message];
}

class NoteFormError extends NoteFormState {
  final String message;

  const NoteFormError(this.message);

  @override
  List<Object?> get props => [message];
}

// Note Form BLoC for create/edit operations
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final CreateNote createNote;
  final UpdateNote updateNote;

  NoteFormBloc({
    required this.createNote,
    required this.updateNote,
  }) : super(const NoteFormInitial()) {
    on<CreateNoteEvent>(_onCreateNote);
    on<UpdateNoteEvent>(_onUpdateNote);
  }

  Future<void> _onCreateNote(
    CreateNoteEvent event,
    Emitter<NoteFormState> emit,
  ) async {
    emit(const NoteFormSubmitting());
    
    final result = await createNote(event.title, event.content);
    
    result.fold(
      (error) => emit(NoteFormError(error)),
      (note) => emit(NoteFormSuccess(
        note: note,
        message: 'Note created successfully',
      )),
    );
  }

  Future<void> _onUpdateNote(
    UpdateNoteEvent event,
    Emitter<NoteFormState> emit,
  ) async {
    emit(const NoteFormSubmitting());
    
    final result = await updateNote(
      event.noteId,
      event.title,
      event.content,
    );
    
    result.fold(
      (error) => emit(NoteFormError(error)),
      (note) => emit(NoteFormSuccess(
        note: note,
        message: 'Note updated successfully',
      )),
    );
  }
}
