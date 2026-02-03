import 'package:alarm_app/features/alarms/presentation/pages/alarm_home_page.dart';
import 'package:alarm_app/features/location/presentation/pages/location_screen.dart';
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
        return MaterialPageRoute(builder: (_) => const OnboardingPage());

      case AppRoutes.locationScreen:
        return MaterialPageRoute(builder: (_) => const LocationScreen());

      case AppRoutes.alarmHome:
        return MaterialPageRoute(builder: (_) => const AlarmHomePage());

      case AppRoutes.notesList:
        return MaterialPageRoute(builder: (_) => const NotesListPage());

      case AppRoutes.noteCreate:
        return MaterialPageRoute(builder: (_) => const NoteFormPage());

      case AppRoutes.noteEdit:
        final note = settings.arguments as Note?;
        return MaterialPageRoute(builder: (_) => NoteFormPage(note: note));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
