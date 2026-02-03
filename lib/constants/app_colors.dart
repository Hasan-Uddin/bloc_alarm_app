import 'package:flutter/material.dart';

/// Application-wide color constants
/// This ensures consistent theming across the entire app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color.fromARGB(255, 82, 0, 255);
  static const Color primaryDark = Color.fromARGB(166, 81, 0, 255);
  static const Color primaryLight = Color.fromARGB(94, 81, 0, 255);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF6B9D);
  static const Color secondaryDark = Color(0xFFE85A8B);
  static const Color secondaryLight = Color(0xFFFF8AB0);

  // Accent Colors
  static const Color accent = Color(0xFFFD79A8);
  static const Color accentLight = Color(0xFFFF9EC3);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1E1E1E);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Text Colors
  static const Color textPrimary = Color.fromARGB(255, 255, 255, 255);
  static const Color textSecondary = Color.fromARGB(255, 230, 230, 230);
  static const Color textHint = Color(0xFFB2BEC3);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Semantic Colors
  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFD63031);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color info = Color(0xFF74B9FF);

  // Neutral Colors
  static const Color divider = Color(0xFFDFE6E9);
  static const Color border = Color(0xFFB2BEC3);
  static const Color shadow = Color(0x1A000000);
  static const Color transparent = Color.fromARGB(0, 255, 255, 255);

  // Gradient Colors (for modern UI effects)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color.fromARGB(248, 11, 0, 36), transparent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
