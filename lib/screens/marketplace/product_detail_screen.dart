import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../models/product.dart';
import '../../providers/app_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isFav = provider.isFavorite(product.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.deepGreen,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? AppColors.errorRed : Colors.white,
                ),
                onPressed: () => provider.toggleFavorite(product.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.deepGreen, AppColors.medGreen],
                  ),
                ),
                child: Center(
                  child: Text(product.emoji,
                      style: const TextStyle(fontSize: 90)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand + category
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(product.brand,
                            style: GoogleFonts.poppins(
                                color: AppColors.gold,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.deepGreen.withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(product.category,
                            style: GoogleFonts.poppins(
                                color: AppColors.deepGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.medGreen.withAlpha(15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Text('🌍',
                                style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(product.origin,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.deepGreen,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(product.name,
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Icon(
                          i < product.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: AppColors.gold,
                          size: 18,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text('${product.rating}',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700, fontSize: 14)),
                      Text(' (${product.reviewCount} reviews)',
                          style: GoogleFonts.poppins(
                              color: AppColors.warmBrown, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Text(product.formattedPrice,
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepGreen)),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Description
                  Text('About this product',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(product.description,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 1.7,
                          color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 20),

                  // Key ingredients
                  Text('Key Ingredients',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.keyIngredients.map((ing) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.deepGreen.withAlpha(12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.deepGreen.withAlpha(50)),
                        ),
                        child: Text('🌿  $ing',
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.deepGreen,
                                fontWeight: FontWeight.w500)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Best for
                  Text('Best For',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.skinTypes.map((st) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.brown.withAlpha(12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.brown.withAlpha(50)),
                        ),
                        child: Text(st,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.brown,
                                fontWeight: FontWeight.w500)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.name} added to cart 🛒',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: AppColors.deepGreen,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      child: Text('Add to Cart — ${product.formattedPrice}',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => provider.toggleFavorite(product.id),
                      child: Text(
                        isFav
                            ? '❤️ Saved to Favourites'
                            : '🤍 Save to Favourites',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
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
