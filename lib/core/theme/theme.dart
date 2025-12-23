import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF1B7743),
    scaffoldBackgroundColor: Color(
      0xFF0D0F0D,
    ), // deeper, non-distracting background
    cardColor: Color(0xFF1F1F1F), // slight contrast from scaffold
    bottomAppBarTheme: BottomAppBarThemeData(
      color: Color(0xFF1F1F1F),
      elevation: 0,
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
      labelSmall: TextStyle(color: Colors.white60, fontSize: 12),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(color: Colors.white, fontSize: 18),
      titleSmall: TextStyle(color: Colors.white70, fontSize: 14),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    colorScheme: ColorScheme.dark(
      primary: Color(0xFF1B7743),
      secondary: Color(0xFF2C9C57), // accent green
      brightness: Brightness.dark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      surface: Color(0xFF2A2A2A),
      onSurface: Colors.white,
      surfaceVariant: Color(0xFF1F1F1F),
      onSurfaceVariant: Colors.white70,
      error: Color(0xFFDC3545),
      onError: Colors.white,
      shadow: Colors.black.withOpacity(0.6),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1B7743),
        foregroundColor: Colors.white,
      ),
    ),
  );

  // ---------------- LIGHT THEME ----------------
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF1B7743),
    scaffoldBackgroundColor: const Color.fromARGB(255, 220, 250, 221),

    cardColor: Colors.white,
    bottomAppBarTheme: const BottomAppBarThemeData(color: Colors.white),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1A1A1A)),
      bodyMedium: TextStyle(color: Color(0xFF1A1A1A)),
      bodySmall: TextStyle(color: Color(0xFF4B4B4B)), // Add this

      labelSmall: TextStyle(color: Color(0xFF4B4B4B), fontSize: 12),

      titleLarge: TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(color: Color(0xFF1A1A1A), fontSize: 18),
      titleSmall: TextStyle(color: Color(0xFF1A1A1A), fontSize: 14),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B7743),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    colorScheme: ColorScheme.light(
      primary: Color(0xFF1B7743),
      secondary: Color(0xFF1B7743),
      brightness: Brightness.light,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF1A1A1A),
      surfaceVariant: Color(0xFFF2F2F2),
      onSurfaceVariant: Color(0xFF4B4B4B), // This replaces black54!
      error: Colors.red,
      onError: Colors.white,
      shadow: Colors.grey.withOpacity(0.3),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1B7743),
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
      ),
    ),
  );
}

// ---------------- CUSTOM COLOR EXTENSIONS ----------------
extension CustomColors on ColorScheme {
  Color get success => const Color(0xFF28A745);
  Color get warning => const Color(0xFFFFC107);
  Color get danger => const Color(0xFFDC3545);
}
