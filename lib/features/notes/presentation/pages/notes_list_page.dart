import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common_widgets/empty_state_widget.dart';
import '../../../../common_widgets/error_widget.dart';
import '../../../../common_widgets/loading_widget.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_routes.dart';
import '../../../../constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../bloc/notes_bloc.dart';
import '../widgets/note_card.dart';

// Notes list screen with pull-to-refresh
class NotesListPage extends StatelessWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotesBloc>()..add(const LoadNotesEvent()),
      child: const _NotesListView(),
    );
  }
}

class _NotesListView extends StatelessWidget {
  const _NotesListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notesTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
      ),
      body: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NotesLoading) {
            return const LoadingWidget(message: 'Loading notes...');
          }

          if (state is NotesError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                context.read<NotesBloc>().add(const LoadNotesEvent());
              },
            );
          }

          if (state is NotesEmpty) {
            return EmptyStateWidget(
              title: AppStrings.noNotes,
              description: AppStrings.noNotesDescription,
              icon: Icons.note_outlined,
              actionText: AppStrings.addNote,
              onAction: () {
                Navigator.of(context).pushNamed(AppRoutes.noteCreate);
              },
            );
          }

          if (state is NotesLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotesBloc>().add(const RefreshNotesEvent());
                // Wait a bit for the refresh to complete
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: state.notes.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return NoteCard(
                    note: note,
                    onTap: () async {
                      final result = await Navigator.of(context).pushNamed(
                        AppRoutes.noteEdit,
                        arguments: note,
                      );
                      // Refresh if note was modified
                      if (result == true) {
                        context.read<NotesBloc>().add(const RefreshNotesEvent());
                      }
                    },
                    onDelete: () {
                      _showDeleteDialog(context, note.id!);
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed(
            AppRoutes.noteCreate,
          );
          // Refresh if note was created
          if (result == true) {
            context.read<NotesBloc>().add(const RefreshNotesEvent());
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textWhite),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int noteId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deleteNote),
        content: const Text(AppStrings.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<NotesBloc>().add(DeleteNoteEvent(noteId));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}
