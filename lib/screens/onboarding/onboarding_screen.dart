import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/responsive.dart';
import '../quiz/skin_quiz_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _slides = [
    _Slide(
      imageUrl: AppImages.onboarding1,
      title: 'African Ingredients,\nAfrican Power',
      subtitle:
          'Discover 12 powerful African botanicals — from Shea Butter to Baobab Oil — backed by science and centuries of tradition.',
      gradientColors: [AppColors.deepGreen, AppColors.medGreen],
      accentColor: AppColors.accentGold,
      emoji: '🌍',
    ),
    _Slide(
      imageUrl: AppImages.onboarding2,
      title: 'AI Skin Analysis\nBuilt for You',
      subtitle:
          'Upload a selfie and our AI analyses your skin tone, detects concerns, and generates a personalised skin health score.',
      gradientColors: [AppColors.darkBrown, AppColors.brown],
      accentColor: AppColors.lightGold,
      emoji: '🔬',
    ),
    _Slide(
      imageUrl: AppImages.onboarding3,
      title: 'Routines That Match\nYour Climate',
      subtitle:
          'Get morning, evening, and weekly routines adapted to your skin type, location, and season — Harmattan, rainy, or tropical.',
      gradientColors: [Color(0xFF1A3A4A), Color(0xFF0D2233)],
      accentColor: AppColors.mintGreen,
      emoji: '🌿',
    ),
  ];

  void _next() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SkinQuizScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => _SlideWidget(slide: _slides[i]),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context),
          ),
          if (_page < _slides.length - 1)
            Positioned(
              top: 56,
              right: 24,
              child: TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => const SkinQuizScreen()),
                ),
                child: Text(
                  'Skip',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withAlpha(180),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final hp = Responsive.hp(context);
    return Container(
      padding: EdgeInsets.fromLTRB(hp, 20, hp, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmoothPageIndicator(
            controller: _controller,
            count: _slides.length,
            effect: ExpandingDotsEffect(
              activeDotColor: AppColors.accentGold,
              dotColor: Colors.white.withAlpha(80),
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                _page == _slides.length - 1 ? 'Get Started' : 'Next',
                style: GoogleFonts.poppins(
                    fontSize: Responsive.sp(context, 16),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide {
  final String imageUrl;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Color accentColor;
  final String emoji;

  const _Slide({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.accentColor,
    required this.emoji,
  });
}

class _SlideWidget extends StatelessWidget {
  final _Slide slide;
  const _SlideWidget({required this.slide});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final hp = Responsive.hp(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── African background image ────────────────────────────────────
        Image.network(
          slide.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : const SizedBox.shrink(),
        ),

        // ── Gradient overlay — ensures readability regardless of image ──
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                slide.gradientColors[0].withAlpha(200),
                slide.gradientColors[1],
              ],
              stops: const [0.0, 0.7],
            ),
          ),
        ),

        // ── Content ─────────────────────────────────────────────────────
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hp, isTablet ? 80 : 60, hp, 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emoji badge
                Container(
                  width: isTablet ? 110 : 90,
                  height: isTablet ? 110 : 90,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: slide.accentColor.withAlpha(120),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(slide.emoji,
                        style: TextStyle(
                            fontSize: isTablet ? 52 : 44)),
                  ),
                ),
                SizedBox(height: isTablet ? 48 : 40),
                Text(
                  slide.title,
                  style: GoogleFonts.poppins(
                    fontSize: Responsive.sp(context, 32),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 48,
                  height: 3,
                  decoration: BoxDecoration(
                    color: slide.accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  slide.subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: Responsive.sp(context, 16),
                    color: Colors.white.withAlpha(210),
                    height: 1.6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
