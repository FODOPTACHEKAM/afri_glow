import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/app_images.dart';
import '../../services/firestore_service.dart';
import '../main_scaffold.dart';
import '../onboarding/onboarding_screen.dart';
import 'auth_widgets.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
            .animate(
                CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _fadeAnim =
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ── Auth ───────────────────────────────────────────────────────────────────

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final auth = context.read<AuthProvider>();
    final ok = await auth.signIn(_emailCtrl.text, _passCtrl.text);
    if (!mounted) return;
    if (ok) await _postLoginRoute(auth.user!.uid);
  }

  Future<void> _googleSignIn() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.signInWithGoogle();
    if (!mounted) return;
    if (ok) await _postLoginRoute(auth.user!.uid);
  }

  Future<void> _postLoginRoute(String uid) async {
    final appProvider = context.read<AppProvider>();
    final data = await FirestoreService.getUserProfile(uid);
    if (!mounted) return;
    if (data != null && data['isOnboarded'] == true) {
      appProvider.loadFromMap(data);
      _push(const MainScaffold());
    } else {
      _push(const OnboardingScreen());
    }
  }

  void _push(Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
      (_) => false,
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : Colors.white;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.background,
      body: Column(
        children: [
          // ── Hero ─────────────────────────────────────────────────────────
          _LoginHero(),

          // ── Form card ────────────────────────────────────────────────────
          Expanded(
            child: SlideTransition(
              position: _slideAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.fromLTRB(28, 32, 28, 32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back 👋🏾',
                              style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.onSurface)),
                          const SizedBox(height: 4),
                          Text(
                              'Sign in to continue your skin journey',
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                          const SizedBox(height: 28),

                          // Email
                          const AuthLabel('Email Address'),
                          const SizedBox(height: 6),
                          AuthField(
                            controller: _emailCtrl,
                            hint: 'you@example.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!v.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // Password
                          const AuthLabel('Password'),
                          const SizedBox(height: 6),
                          AuthField(
                            controller: _passCtrl,
                            hint: '••••••••',
                            icon: Icons.lock_outline,
                            obscure: _obscure,
                            suffix: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: isDark ? AppColors.gold : AppColors.bronze,
                                size: 20,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgotPasswordScreen())),
                              child: Text('Forgot Password?',
                                  style: GoogleFonts.poppins(
                                      color: AppColors.gold,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),

                          // Error
                          if (auth.error != null) ...[
                            AuthErrorBanner(auth.error!),
                            const SizedBox(height: 12),
                          ],

                          // Sign-in button
                          AuthPrimaryButton(
                            label: 'Sign In',
                            loading: auth.isLoading,
                            onTap: _signIn,
                          ),
                          const SizedBox(height: 22),

                          const AuthOrDivider(),
                          const SizedBox(height: 22),

                          AuthGoogleButton(
                            loading: auth.isLoading,
                            onTap: _googleSignIn,
                          ),
                          const SizedBox(height: 28),

                          // Sign-up link
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                auth.clearError();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const RegisterScreen()));
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Theme.of(context).colorScheme.onSurface),
                                  children: [
                                    const TextSpan(text: 'New here? '),
                                    TextSpan(
                                      text: 'Create Account',
                                      style: GoogleFonts.poppins(
                                          color: AppColors.gold,
                                          fontWeight: FontWeight.w700,
                                          decoration:
                                              TextDecoration.underline,
                                          decorationColor:
                                              AppColors.gold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero banner ───────────────────────────────────────────────────────────────

class _LoginHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            AppImages.onboarding1,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: AppColors.cocoa),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.espresso.withValues(alpha: 0.55),
                  AppColors.cocoa.withValues(alpha: 0.88),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppColors.gold, width: 2),
                  ),
                  child: const Center(
                      child:
                          Text('🌿', style: TextStyle(fontSize: 30))),
                ),
                const SizedBox(height: 10),
                Text('AfriGlow',
                    style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.2)),
                Text('AI-powered skincare for African skin',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.accentGold,
                        letterSpacing: 0.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
