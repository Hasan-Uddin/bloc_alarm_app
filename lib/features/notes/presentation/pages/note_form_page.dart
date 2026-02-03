import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_text_field.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../helpers/extensions.dart';
import '../../domain/entities/note.dart';
import '../bloc/note_form_bloc.dart';

// Note create/edit screen
class NoteFormPage extends StatefulWidget {
  final Note? note; // Null for create, non-null for edit

  const NoteFormPage({super.key, this.note});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.note != null;

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (isEditMode) {
        context.read<NoteFormBloc>().add(
              UpdateNoteEvent(
                noteId: widget.note!.id!,
                title: _titleController.text.trim(),
                content: _contentController.text.trim(),
              ),
            );
      } else {
        context.read<NoteFormBloc>().add(
              CreateNoteEvent(
                title: _titleController.text.trim(),
                content: _contentController.text.trim(),
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NoteFormBloc>(),
      child: BlocListener<NoteFormBloc, NoteFormState>(
        listener: (context, state) {
          if (state is NoteFormSuccess) {
            context.showSnackBar(state.message);
            Navigator.of(context).pop(true); // Return true to indicate success
          } else if (state is NoteFormError) {
            context.showSnackBar(state.message);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(isEditMode ? AppStrings.editNote : AppStrings.addNote),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
            elevation: 0,
          ),
          body: BlocBuilder<NoteFormBloc, NoteFormState>(
            builder: (context, state) {
              final isSubmitting = state is NoteFormSubmitting;

              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    CustomTextField(
                      controller: _titleController,
                      labelText: AppStrings.noteTitle,
                      hintText: 'Enter note title',
                      enabled: !isSubmitting,
                      prefixIcon: const Icon(Icons.title),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _contentController,
                      labelText: AppStrings.noteContent,
                      hintText: 'Enter note content',
                      enabled: !isSubmitting,
                      maxLines: 12,
                      prefixIcon: const Icon(Icons.description),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Content cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: isEditMode ? AppStrings.save : AppStrings.addNote,
                      onPressed: isSubmitting ? null : () => _submit(context),
                      isLoading: isSubmitting,
                      icon: isEditMode ? Icons.save : Icons.add,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
