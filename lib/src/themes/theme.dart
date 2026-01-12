import 'package:flutter/material.dart';
import 'light_color.dart';
import 'dark_color.dart';

// lib/src/themes/theme.dart

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: LightColor.orange,
    scaffoldBackgroundColor: LightColor.background,
    cardColor: Colors.white,
    shadowColor: Colors.black.withOpacity(0.08),
    // Fix for TextFields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      hintStyle: const TextStyle(color: Colors.grey),
      labelStyle: const TextStyle(color: Colors.black),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
    colorScheme: ColorScheme.light(
      primary: LightColor.orange,
      secondary: LightColor.orange,
      onSurface: LightColor.titleTextColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: LightColor.titleTextColor),
      bodyMedium: TextStyle(color: LightColor.subTitleTextColor),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: DarkColor.orange,
    scaffoldBackgroundColor: DarkColor.background,
    cardColor: const Color(0xFF1E1E1E),
    shadowColor: Colors.black.withOpacity(0.4),
    // Fix for TextFields in Dark Mode
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2E2E2E),
      hintStyle: const TextStyle(color: Colors.white60),
      labelStyle: const TextStyle(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
    colorScheme: ColorScheme.dark(
      primary: DarkColor.orange,
      secondary: DarkColor.orange,
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}