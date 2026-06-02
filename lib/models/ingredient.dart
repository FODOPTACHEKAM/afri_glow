import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Ingredient {
  final String id;
  final String name;
  final String scientificName;
  final String origin;
  final String country;
  final String description;
  final List<String> benefits;
  final List<String> evidenceLinks;
  final List<String> traditionalUses;
  final List<String> commonProducts;
  final List<String> skinTypes;
  final List<String> concerns;
  final String emoji;
  final List<Color> gradientColors;
  final String? imageUrl;

  const Ingredient({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.origin,
    required this.country,
    required this.description,
    required this.benefits,
    required this.evidenceLinks,
    required this.traditionalUses,
    required this.commonProducts,
    required this.skinTypes,
    required this.concerns,
    required this.emoji,
    required this.gradientColors,
    this.imageUrl,
  });

  factory Ingredient.fromMap(Map<String, dynamic> m) => Ingredient(
        id: m['id'] ?? '',
        name: m['name'] ?? '',
        scientificName: m['scientificName'] ?? '',
        origin: m['origin'] ?? '',
        country: m['country'] ?? '',
        description: m['description'] ?? '',
        benefits: List<String>.from(m['benefits'] ?? []),
        evidenceLinks: List<String>.from(m['evidenceLinks'] ?? []),
        traditionalUses: List<String>.from(m['traditionalUses'] ?? []),
        commonProducts: List<String>.from(m['commonProducts'] ?? []),
        skinTypes: List<String>.from(m['skinTypes'] ?? []),
        concerns: List<String>.from(m['concerns'] ?? []),
        emoji: m['emoji'] ?? '🌿',
        gradientColors: [AppColors.deepGreen, AppColors.medGreen],
      );
}
