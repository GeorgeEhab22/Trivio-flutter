import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static const animationDuration = Duration(milliseconds: 400);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue, // Modern M3 color generation
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: AppColors.primary, // Modern M3 color generation with custom seed
        scaffoldBackgroundColor: const Color(0xFF0D1117), // GitHub-style modern dark
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.white,

        ),
      );
}