import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBrown = Color(0xFF6B4226);
  static const Color darkBrown = Color(0xFF4A2C17);
  static const Color naturalGreen = Color(0xFF4CAF50);
  static const Color cream = Color(0xFFF5F0E6);

  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: cream,
    primaryColor: primaryBrown,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: naturalGreen,
        foregroundColor: Colors.white,
      ),
    ),
  );
}