import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_colors.dart';
import 'constants/app_routes.dart';
import 'constants/app_strings.dart';
import 'routes.dart';

// Root app widget with MaterialApp configuration
class MyApp extends StatelessWidget {
  final bool isOnboardingCompleted;

  const MyApp({super.key, required this.isOnboardingCompleted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          error: AppColors.error,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          // Applies Poppins to all default text styles
          Theme.of(context).textTheme,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: isOnboardingCompleted
          ? AppRoutes.notesList
          : AppRoutes.onboarding,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
