import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../data/ingredients_data.dart';
import '../../models/ingredient.dart';
import '../../utils/responsive.dart';
import 'ingredient_detail_screen.dart';

class IngredientListScreen extends StatefulWidget {
  const IngredientListScreen({super.key});

  @override
  State<IngredientListScreen> createState() => _IngredientListScreenState();
}

class _IngredientListScreenState extends State<IngredientListScreen> {
  String _query = '';
  String _category = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = filterIngredients(_category, _query);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cols = Responsive.gridCols(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            title: Text('Ingredient Library',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700, color: Colors.white)),
            backgroundColor: AppColors.deepGreen,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: Container(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.deepGreen,
                padding: EdgeInsets.fromLTRB(
                    Responsive.hp(context), 0, Responsive.hp(context), 12),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search ingredients...',
                        hintStyle: GoogleFonts.poppins(
                            color: AppColors.warmBrown, fontSize: 14),
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.warmBrown),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.darkCard
                            : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: ingredientCategories.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final cat = ingredientCategories[i];
                          final selected = cat == _category;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _category = cat),
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.gold
                                    : Colors.white.withAlpha(25),
                                borderRadius:
                                    BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.gold
                                      : Colors.white.withAlpha(60),
                                ),
                              ),
                              child: Text(cat,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? Colors.white
                                        : Colors.white.withAlpha(200),
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: filtered.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔍',
                        style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text('No ingredients found',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors.warmBrown)),
                  ],
                ),
              )
            : GridView.builder(
                padding: EdgeInsets.all(Responsive.hp(context)),
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio:
                      Responsive.cardAspect(context, phone: 0.75),
                ),
                itemCount: filtered.length,
                itemBuilder: (_, i) =>
                    _IngredientCard(ingredient: filtered[i]),
              ),
      ),
    );
  }
}

class _IngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  const _IngredientCard({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                IngredientDetailScreen(ingredient: ingredient)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ingredient.gradientColors,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── African ingredient photo ──────────────────────────
            if (ingredient.imageUrl != null)
              Positioned.fill(
                child: Image.network(
                  ingredient.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const SizedBox.shrink(),
                  loadingBuilder: (_, child, prog) =>
                      prog == null ? child : const SizedBox.shrink(),
                ),
              ),
            // ── Bottom gradient scrim for text readability ────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: isTablet ? 130 : 110,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      ingredient.gradientColors.first,
                      ingredient.gradientColors.first.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
            // ── Text content ─────────────────────────────────────
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(ingredient.emoji,
                      style: TextStyle(
                          fontSize: isTablet ? 28 : 22)),
                  const SizedBox(height: 2),
                  Text(ingredient.name,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: Responsive.sp(context, 14),
                          fontWeight: FontWeight.w700)),
                  Text(
                      ingredient.country
                          .split('·')
                          .first
                          .trim(),
                      style: GoogleFonts.poppins(
                          color: Colors.white.withAlpha(200),
                          fontSize: 10)),
                  const SizedBox(height: 6),
                  ...ingredient.benefits
                      .take(isTablet ? 3 : 2)
                      .map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  margin: const EdgeInsets.only(
                                      right: 5),
                                  decoration: const BoxDecoration(
                                    color: AppColors.accentGold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(b,
                                      style: GoogleFonts.poppins(
                                          color: Colors.white
                                              .withAlpha(210),
                                          fontSize: 10),
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
