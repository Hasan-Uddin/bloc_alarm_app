import 'package:flutter/material.dart';
import 'constants/app_routes.dart';
import 'features/notes/domain/entities/note.dart';
import 'features/notes/presentation/pages/note_form_page.dart';
import 'features/notes/presentation/pages/notes_list_page.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';

// Route generator for named navigation
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingPage(),
        );

      case AppRoutes.notesList:
        return MaterialPageRoute(
          builder: (_) => const NotesListPage(),
        );

      case AppRoutes.noteCreate:
        return MaterialPageRoute(
          builder: (_) => const NoteFormPage(),
        );

      case AppRoutes.noteEdit:
        final note = settings.arguments as Note?;
        return MaterialPageRoute(
          builder: (_) => NoteFormPage(note: note),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
