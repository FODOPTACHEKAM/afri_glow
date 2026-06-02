import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/app_provider.dart';
import '../services/firestore_service.dart';
import 'auth/login_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'main_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    // Minimum splash display time
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    // Not authenticated → go to login
    if (user == null) {
      _push(const LoginScreen());
      return;
    }

    // Authenticated → try loading profile from Firestore
    final appProvider = context.read<AppProvider>();
    if (!appProvider.isOnboarded) {
      try {
        final data = await FirestoreService.getUserProfile(user.uid);
        if (!mounted) return;
        if (data != null && data['isOnboarded'] == true) {
          appProvider.loadFromMap(data);
        }
      } catch (_) {
        // Network error: fall through to onboarding check below
      }
    }

    if (!mounted) return;
    if (appProvider.isOnboarded) {
      _push(const MainScaffold());
    } else {
      _push(const OnboardingScreen());
    }
  }

  void _push(Widget page) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.deepGreen,
              AppColors.medGreen,
              Color(0xFF1A3A2A),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: _buildPattern()),
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.gold, width: 2),
                        ),
                        child: const Center(
                          child: Text('🌿',
                              style: TextStyle(fontSize: 50)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('AfriGlow',
                          style: GoogleFonts.poppins(
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          )),
                      const SizedBox(height: 8),
                      Text(
                        'AI-powered skincare for African skin',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.accentGold,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 60),
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.gold.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Text(
                'v1.0.0 · Made for Africa',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPattern() {
    return Opacity(
      opacity: 0.06,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          childAspectRatio: 1,
        ),
        itemCount: 120,
        itemBuilder: (_, i) => const Center(
          child: Text('✦',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }
}
