// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const cream      = Color(0xFFFAF5EE);
  static const warm       = Color(0xFFF0E6D3);
  static const sand       = Color(0xFFD9C4A8);
  static const clay       = Color(0xFFB8956A);
  static const terracotta = Color(0xFF9C6B42);
  static const bark       = Color(0xFF5C3D2E);
  static const forest     = Color(0xFF2D4A3E);
  static const gold       = Color(0xFFC8A96E);
  static const goldLite   = Color(0xFFE8D5B0);
  static const text       = Color(0xFF2A1F14);
  static const muted      = Color(0xFF7A6555);
  static const error      = Color(0xFFC0392B);
  static const success    = Color(0xFF27AE60);

  // Gradients
  static const leftPanelGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.45, 1.0],
    colors: [Color(0xFF1A2E26), Color(0xFF2D4A3E), Color(0xFF3A5A4A)],
  );

  static const loginButtonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bark, terracotta],
  );
}
