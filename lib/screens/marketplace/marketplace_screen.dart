import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../data/products_data.dart';
import '../../models/product.dart';
import '../../providers/app_provider.dart';
import '../../utils/responsive.dart';
import 'product_detail_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _query = '';
  String _category = 'All';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    var products = allProducts.where((p) {
      final qMatch = _query.isEmpty ||
          p.name.toLowerCase().contains(_query.toLowerCase()) ||
          p.brand.toLowerCase().contains(_query.toLowerCase());
      final cMatch = _category == 'All' || p.category == _category;
      return qMatch && cMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // Search + filter
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search products or brands...',
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.warmBrown),
                    filled: true,
                    fillColor:
                        Theme.of(context).brightness == Brightness.dark
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
                    itemCount: productCategories.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final cat = productCategories[i];
                      final sel = cat == _category;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _category = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.gold
                                : Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel
                                  ? AppColors.gold
                                  : Colors.white.withAlpha(60),
                            ),
                          ),
                          child: Text(cat,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: sel
                                      ? Colors.white
                                      : Colors.white.withAlpha(200))),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Products grid
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Text('No products found',
                        style: GoogleFonts.poppins(
                            color: AppColors.warmBrown)))
                : GridView.builder(
                    padding: EdgeInsets.all(Responsive.hp(context)),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.gridCols(context),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio:
                          Responsive.cardAspect(context, phone: 0.65),
                    ),
                    itemCount: products.length,
                    itemBuilder: (_, i) => _ProductCard(
                        product: products[i], provider: provider),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final AppProvider provider;
  const _ProductCard({required this.product, required this.provider});

  @override
  Widget build(BuildContext context) {
    final isFav = provider.isFavorite(product.id);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8E0D8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image — proportional, never overflows
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEF4EE),
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                    child: Center(
                      child: Text(product.emoji,
                          style: const TextStyle(fontSize: 48)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => provider.toggleFavorite(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(220),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isFav
                              ? AppColors.errorRed
                              : AppColors.warmBrown,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product info — fills remaining space, never overflows
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(product.brand,
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: AppColors.gold,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(product.name,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: AppColors.gold, size: 12),
                            const SizedBox(width: 3),
                            Text(product.rating.toString(),
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                            Text(' (${product.reviewCount})',
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: AppColors.warmBrown)),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(product.formattedPrice,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepGreen)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
