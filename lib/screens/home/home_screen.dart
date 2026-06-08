import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../providers/app_provider.dart';
import '../../data/ingredients_data.dart';
import '../../models/user_profile.dart';
import '../../utils/app_images.dart';
import '../../utils/responsive.dart';
import '../ingredients/ingredient_detail_screen.dart';
import '../marketplace/marketplace_screen.dart';
import '../community/community_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.userProfile;
    final score = provider.latestAnalysis?.skinScore ?? provider.quizBasedScore;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final todayIng =
        allIngredients[DateTime.now().weekday % allIngredients.length];
    final isTablet = Responsive.isTablet(context);
    final hp = Responsive.hp(context);
    final imagePath = provider.profileImagePath;
    final imageUrl = provider.profileImageUrl;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero header ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // African skincare banner image
                SizedBox(
                  height: isTablet ? 320 : 260,
                  width: double.infinity,
                  child: Image.network(
                    AppImages.homeBanner,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    loadingBuilder: (_, child, prog) =>
                        prog == null ? child : const SizedBox.shrink(),
                  ),
                ),
                // Gradient overlay
                Container(
                  height: isTablet ? 320 : 260,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [AppColors.darkSurface, AppColors.darkCard]
                          : [
                              AppColors.deepGreen.withAlpha(220),
                              AppColors.medGreen.withAlpha(210),
                            ],
                    ),
                  ),
                ),
                // Content on top
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(hp, 16, hp, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row: avatar + greeting + bell
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.gold.withAlpha(60),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.gold, width: 1.5),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: _AvatarImage(
                                imageUrl: imageUrl,
                                imagePath: imagePath,
                                initial: user?.name.isNotEmpty == true
                                    ? user!.name[0].toUpperCase()
                                    : 'A',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${_greeting()},',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white.withAlpha(190),
                                          fontSize:
                                              Responsive.sp(context, 13))),
                                  Text(
                                    user?.name ?? 'Welcome!',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: Responsive.sp(context, 20),
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Skin score card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withAlpha(40)),
                          ),
                          child: Row(
                            children: [
                              CircularPercentIndicator(
                                radius: 45.0,
                                lineWidth: 6.0,
                                percent: (score / 100).clamp(0.0, 1.0),
                                center: Text(
                                  '${score.toInt()}',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                progressColor: AppColors.accentGold,
                                backgroundColor:
                                    Colors.white.withAlpha(40),
                                circularStrokeCap:
                                    CircularStrokeCap.round,
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('Skin Health Score',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white
                                                .withAlpha(200),
                                            fontSize: 13)),
                                    Text(
                                      provider.latestAnalysis
                                              ?.scoreLabel ??
                                          'Good',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize:
                                              Responsive.sp(context, 22),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 4),
                                    GestureDetector(
                                      onTap: () =>
                                          provider.setNavIndex(2),
                                      child: Text(
                                        'Tap Scanner to update →',
                                        style: GoogleFonts.poppins(
                                            color:
                                                AppColors.accentGold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Body ───────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.all(hp),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _sectionTitle(context, 'Quick Actions'),
                const SizedBox(height: 12),
                _QuickActions(provider: provider),
                const SizedBox(height: 24),
                _sectionTitle(context, 'Ingredient of the Day'),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => IngredientDetailScreen(
                            ingredient: todayIng)),
                  ),
                  child: _IngredientOfDayCard(
                      ingredient: todayIng, isTablet: isTablet),
                ),
                const SizedBox(height: 24),
                if (user != null) ...[
                  _ClimateTipCard(user: user),
                  const SizedBox(height: 24),
                ],
                _sectionTitle(context, 'Explore AfriGlow'),
                const SizedBox(height: 12),
                _ExploreGrid(isTablet: isTablet),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: Responsive.sp(context, 16)));
  }
}

// ── Ingredient of the Day Card ─────────────────────────────────────────────

class _IngredientOfDayCard extends StatelessWidget {
  final dynamic ingredient;
  final bool isTablet;
  const _IngredientOfDayCard(
      {required this.ingredient, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isTablet ? 180 : 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: ingredient.gradientColors,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Real ingredient photo (if available)
          if (ingredient.imageUrl != null)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: isTablet ? 200 : 140,
              child: Image.network(
                ingredient.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                loadingBuilder: (_, child, prog) =>
                    prog == null ? child : const SizedBox.shrink(),
              ),
            ),
          // Right-side gradient fade over image
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: isTablet ? 220 : 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    ingredient.gradientColors.last.withAlpha(0),
                    ingredient.gradientColors.first,
                  ],
                ),
              ),
            ),
          ),
          // Text content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("Today's Pick",
                            style: GoogleFonts.poppins(
                                color: Colors.white.withAlpha(200),
                                fontSize: 11)),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(ingredient.emoji,
                              style: TextStyle(
                                  fontSize: isTablet ? 28 : 24)),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(ingredient.name,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: isTablet ? 20 : 17,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      Text(ingredient.country,
                          style: GoogleFonts.poppins(
                              color: Colors.white.withAlpha(200),
                              fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(ingredient.benefits.first,
                          style: GoogleFonts.poppins(
                              color: AppColors.accentGold,
                              fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions ──────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final AppProvider provider;
  const _QuickActions({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final actions = [
      _QA(Icons.document_scanner, 'Scanner',
          () => provider.setNavIndex(2)),
      _QA(Icons.spa, 'Ingredients',
          () => provider.setNavIndex(1)),
      _QA(Icons.assignment, 'Routine',
          () => provider.setNavIndex(3)),
      _QA(Icons.shopping_bag, 'Shop', () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const MarketplaceScreen()));
      }),
    ];

    final iconSize = isTablet ? 78.0 : 62.0;
    final fontSize = Responsive.sp(context, 12);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions
          .map((a) => GestureDetector(
                onTap: a.onTap,
                child: Column(
                  children: [
                    Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Icon(a.icon,
                            color: Colors.white,
                            size: isTablet ? 34 : 28),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(a.label,
                        style: GoogleFonts.poppins(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _QA {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QA(this.icon, this.label, this.onTap);
}

// ── Climate Tip ────────────────────────────────────────────────────────────

class _ClimateTipCard extends StatelessWidget {
  final UserProfile user;
  const _ClimateTipCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final tips = {
      'harmattan': (
        '🌬️ Harmattan Season Tip',
        'Harmattan winds strip up to 40% more moisture. Layer Baobab serum under Shea Butter and seal with Marula oil every morning.',
        AppColors.warmBrown
      ),
      'tropical': (
        '🌴 Tropical Climate Tip',
        'Humidity helps hydration! Use lightweight gels and serums. Hibiscus toner is perfect for controlling pores in the heat.',
        AppColors.medGreen
      ),
      'coastal': (
        '🌊 Coastal Climate Tip',
        'Sea air can dehydrate and cause salt buildup. Rinse skin in the evening and apply Aloe Vera gel to rehydrate.',
        AppColors.deepGreen
      ),
      'savanna': (
        '🌾 Savanna Climate Tip',
        'Cool nights need a richer night cream. Apply Shea Butter before bed to protect against temperature fluctuations.',
        AppColors.brown
      ),
    };

    final tip = tips[user.climate] ?? tips['tropical']!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tip.$3.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tip.$3.withAlpha(60)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tip.$3.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('💡', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip.$1,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: tip.$3)),
                const SizedBox(height: 4),
                Text(tip.$2,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Explore Grid ──────────────────────────────────────────────────────────

class _ExploreGrid extends StatelessWidget {
  final bool isTablet;
  const _ExploreGrid({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _EC(Icons.group, 'Community',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CommunityScreen()))),
      _EC(Icons.bar_chart, 'Dashboard',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()))),
      _EC(Icons.smart_toy, 'AI Chat',
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ChatScreen()))),
    ];

    if (isTablet) {
      // On tablets show all 3 side by side with more padding
      return Row(
        children: cards
            .map((c) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _ExploreCard(card: c),
                  ),
                ))
            .toList(),
      );
    }

    return Row(
      children: [
        Expanded(child: _ExploreCard(card: cards[0])),
        const SizedBox(width: 12),
        Expanded(child: _ExploreCard(card: cards[1])),
        const SizedBox(width: 12),
        Expanded(child: _ExploreCard(card: cards[2])),
      ],
    );
  }
}

class _EC {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _EC(this.icon, this.label, this.onTap);
}

// ── Avatar image — prefers cloud URL, falls back to local file, then initial ─

class _AvatarImage extends StatelessWidget {
  final String? imageUrl;
  final String? imagePath;
  final String initial;
  const _AvatarImage(
      {required this.imageUrl,
      required this.imagePath,
      required this.initial});

  @override
  Widget build(BuildContext context) {
    final fallback = Center(
      child: Text(initial,
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700)),
    );

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(imageUrl!,
          fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback);
    }
    if (imagePath != null) {
      return Image.file(File(imagePath!),
          fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback);
    }
    return fallback;
  }
}

class _ExploreCard extends StatelessWidget {
  final _EC card;
  const _ExploreCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return GestureDetector(
      onTap: card.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(card.icon,
                color: Colors.white,
                size: isTablet ? 32 : 26),
            const SizedBox(height: 6),
            Text(card.label,
                style: GoogleFonts.poppins(
                    fontSize: Responsive.sp(context, 12),
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
