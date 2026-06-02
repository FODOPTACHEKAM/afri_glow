import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../models/ingredient.dart';
import '../../utils/responsive.dart';

class IngredientDetailScreen extends StatelessWidget {
  final Ingredient ingredient;
  const IngredientDetailScreen({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final hp = Responsive.hp(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: isTablet ? 300 : 240,
            pinned: true,
            backgroundColor: ingredient.gradientColors.first,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // ── African ingredient photo ──────────────────────────
                  if (ingredient.imageUrl != null)
                    Image.network(
                      ingredient.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const SizedBox.shrink(),
                      loadingBuilder: (_, child, prog) =>
                          prog == null ? child : const SizedBox.shrink(),
                    ),

                  // ── Gradient overlay ──────────────────────────────────
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          ingredient.gradientColors.first.withAlpha(100),
                          ingredient.gradientColors.last,
                        ],
                        stops: const [0.2, 1.0],
                      ),
                    ),
                  ),

                  // ── Big faint emoji watermark ─────────────────────────
                  Positioned(
                    right: -20,
                    top: -10,
                    child: Text(ingredient.emoji,
                        style: TextStyle(
                            fontSize: isTablet ? 180 : 140,
                            color: Colors.white.withAlpha(18))),
                  ),

                  // ── Title block ───────────────────────────────────────
                  Positioned(
                    left: hp,
                    right: hp,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(ingredient.emoji,
                            style: TextStyle(
                                fontSize: isTablet ? 56 : 48)),
                        const SizedBox(height: 6),
                        Text(ingredient.name,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize:
                                    Responsive.sp(context, 28),
                                fontWeight: FontWeight.w700)),
                        Text(ingredient.scientificName,
                            style: GoogleFonts.poppins(
                                color: Colors.white.withAlpha(180),
                                fontSize: 13,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(hp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Origin badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: ingredient.gradientColors.first
                          .withAlpha(15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: ingredient.gradientColors.first
                              .withAlpha(60)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🌍',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(ingredient.country,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: ingredient
                                      .gradientColors.first)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Skin types chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: ingredient.skinTypes.map((s) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color:
                              AppColors.deepGreen.withAlpha(12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color:
                                  AppColors.deepGreen.withAlpha(50)),
                        ),
                        child: Text(s,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.deepGreen,
                                fontWeight: FontWeight.w500)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(ingredient.description,
                      style: GoogleFonts.poppins(
                          fontSize: Responsive.sp(context, 14),
                          height: 1.7,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface)),
                  const SizedBox(height: 24),

                  _Section(
                    title: '✨ Key Benefits',
                    color: AppColors.deepGreen,
                    items: ingredient.benefits,
                    icon: '•',
                  ),
                  const SizedBox(height: 20),

                  _Section(
                    title: '🌍 Traditional Uses',
                    color: AppColors.brown,
                    items: ingredient.traditionalUses,
                    icon: '→',
                  ),
                  const SizedBox(height: 20),

                  if (ingredient.evidenceLinks.isNotEmpty) ...[
                    _Section(
                      title: '🔬 Scientific Evidence',
                      color: const Color(0xFF1A5276),
                      items: ingredient.evidenceLinks,
                      icon: '📄',
                    ),
                    const SizedBox(height: 20),
                  ],

                  _Section(
                    title: '🛍️ Common Products',
                    color: const Color(0xFF6C3483),
                    items: ingredient.commonProducts,
                    icon: '›',
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Color color;
  final List<String> items;
  final String icon;

  const _Section({
    required this.title,
    required this.color,
    required this.items,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: Responsive.sp(context, 16),
                fontWeight: FontWeight.w700,
                color: color)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withAlpha(10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(35)),
          ),
          child: Column(
            children: items
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$icon ',
                              style: TextStyle(
                                  color: color, fontSize: 14)),
                          Expanded(
                            child: Text(item,
                                style: GoogleFonts.poppins(
                                    fontSize:
                                        Responsive.sp(context, 13),
                                    height: 1.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface)),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
