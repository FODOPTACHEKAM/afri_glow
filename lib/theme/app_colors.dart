import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── AfriGlow Brand Palette ─────────────────────────────────────
  static const Color gold       = Color(0xFFD4A14A); // Primary – Rich Gold
  static const Color cocoa      = Color(0xFF5A2D16); // Secondary – Deep Cocoa Brown
  static const Color bronze     = Color(0xFFA8652A); // Warm Bronze (accents / outlines)
  static const Color olive      = Color(0xFF6B6A32); // Olive Green (botanical)
  static const Color cream      = Color(0xFFF4EEE7); // Soft Cream / Ivory
  static const Color background = Color(0xFFF8F4EF); // App scaffold background
  static const Color espresso   = Color(0xFF2E1A0F); // Dark Espresso (body text / buttons)

  // ── Gold tints ─────────────────────────────────────────────────
  static const Color lightGold     = Color(0xFFF0DEB5);
  static const Color veryLightGold = Color(0xFFFAF3E3);
  static const Color warmWhite     = Color(0xFFFFFDF9);

  // ── Dark mode surfaces ─────────────────────────────────────────
  static const Color darkBg      = Color(0xFF1A0D05);
  static const Color darkSurface = Color(0xFF2E1A0F);
  static const Color darkCard    = Color(0xFF3D2010);
  static const Color darkDivider = Color(0xFF5A3218);

  // ── Semantic aliases (keep old names so screens compile) ───────
  static const Color deepGreen  = cocoa;
  static const Color medGreen   = olive;
  static const Color lightGreen = bronze;
  static const Color mintGreen  = lightGold;
  static const Color accentGold = Color(0xFFE8C25A);
  static const Color brown      = cocoa;
  static const Color darkBrown  = espresso;
  static const Color warmBrown  = bronze;
  static const Color softCream  = background;

  // ── Status colors ──────────────────────────────────────────────
  static const Color errorRed     = Color(0xFFE53935);
  static const Color successGreen = Color(0xFF43A047);
  static const Color warningAmber = Color(0xFFFF8F00);

  // ── Concern colors ─────────────────────────────────────────────
  static const Color acneColor     = Color(0xFFE57373);
  static const Color hyperColor    = Color(0xFFBA68C8);
  static const Color drynessColor  = Color(0xFF64B5F6);
  static const Color oilinessColor = Color(0xFFFFD54F);
  static const Color agingColor    = Color(0xFFFF8A65);

  // ── Ingredient gradient pairs ─────────────────────────────────
  static const List<Color> sheaGrad      = [Color(0xFFE8C547), Color(0xFFD4A017)];
  static const List<Color> baobabGrad    = [Color(0xFF8B5E3C), Color(0xFF5C3D2E)];
  static const List<Color> aloeGrad      = [Color(0xFF52B788), Color(0xFF2D6A4F)];
  static const List<Color> moringaGrad   = [Color(0xFF1B4332), Color(0xFF2D6A4F)];
  static const List<Color> blackSeedGrad = [Color(0xFF2C3E50), Color(0xFF1A252F)];
  static const List<Color> coconutGrad   = [Color(0xFFE8DCC8), Color(0xFFD4C5A9)];
  static const List<Color> hibiscusGrad  = [Color(0xFFE91E63), Color(0xFFC2185B)];
  static const List<Color> arganGrad     = [Color(0xFFE8A838), Color(0xFFC9A227)];
  static const List<Color> marulaGrad    = [Color(0xFFFF8C42), Color(0xFFE67E22)];
  static const List<Color> blackSoapGrad = [Color(0xFF4A3728), Color(0xFF2C1A0E)];
  static const List<Color> rooibosGrad   = [Color(0xFFBF360C), Color(0xFF870000)];
  static const List<Color> neemGrad      = [Color(0xFF558B2F), Color(0xFF33691E)];
}
