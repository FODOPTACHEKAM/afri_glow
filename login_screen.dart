// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../widgets/afriglow_text_field.dart';
import '../widgets/left_panel.dart';
import '../widgets/toast_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus   = FocusNode();
  final _pwFocus      = FocusNode();

  bool _rememberMe  = false;
  bool _isLoading   = false;

  String? _emailError;
  String? _passwordError;
  FieldState _emailState    = FieldState.normal;
  FieldState _passwordState = FieldState.normal;

  late final AnimationController _fadeCtrl;
  late final Animation<double>   _fadeAnim;
  late final Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));

    _emailFocus.addListener(_onEmailFocusChange);
    _pwFocus.addListener(_onPasswordFocusChange);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _pwFocus.dispose();
    super.dispose();
  }

  // ── Validation ──────────────────────────────────────────────────

  bool _isValidEmail(String e) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(e);

  void _onEmailFocusChange() {
    if (!_emailFocus.hasFocus) _validateEmail(showError: true);
  }

  void _onPasswordFocusChange() {
    if (!_pwFocus.hasFocus) _validatePassword(showError: true);
  }

  bool _validateEmail({bool showError = false}) {
    final v = _emailCtrl.text.trim();
    if (v.isEmpty) {
      if (showError) setState(() {
        _emailError = 'Email is required.';
        _emailState = FieldState.error;
      });
      return false;
    }
    if (!_isValidEmail(v)) {
      if (showError) setState(() {
        _emailError = 'Please enter a valid email address.';
        _emailState = FieldState.error;
      });
      return false;
    }
    setState(() {
      _emailError = null;
      _emailState = FieldState.success;
    });
    return true;
  }

  bool _validatePassword({bool showError = false}) {
    final v = _passwordCtrl.text;
    if (v.isEmpty) {
      if (showError) setState(() {
        _passwordError = 'Password is required.';
        _passwordState = FieldState.error;
      });
      return false;
    }
    if (v.length < 8) {
      if (showError) setState(() {
        _passwordError = 'Password must be at least 8 characters.';
        _passwordState = FieldState.error;
      });
      return false;
    }
    setState(() {
      _passwordError = null;
      _passwordState = FieldState.success;
    });
    return true;
  }

  // ── Actions ─────────────────────────────────────────────────────

  void _showToast(String title, String msg,
      {ToastType type = ToastType.success}) {
    ToastOverlay.of(context).show(ToastData(
      title: title,
      message: msg,
      type: type,
    ));
  }

  Future<void> _handleLogin() async {
    final emailOk = _validateEmail(showError: true);
    final pwOk    = _validatePassword(showError: true);
    if (!emailOk || !pwOk) return;

    setState(() => _isLoading = true);

    final result = await AuthService.login(
      email:      _emailCtrl.text.trim(),
      password:   _passwordCtrl.text,
      rememberMe: _rememberMe,
    );

    setState(() => _isLoading = false);

    if (!result.success) {
      final isEmailError = result.message.toLowerCase().contains('email');
      setState(() {
        if (isEmailError) {
          _emailError = result.message;
          _emailState = FieldState.error;
        } else {
          _passwordError = result.message;
          _passwordState = FieldState.error;
        }
      });
      if (AuthService.isDemoMode) {
        _showToast('Demo mode', result.message, type: ToastType.info);
      } else {
        _showToast('Sign-in failed', result.message, type: ToastType.error);
      }
      return;
    }

    final name = result.userName ?? _emailCtrl.text.split('@').first;
    _showToast('Welcome back!', 'Hello, $name! Redirecting…');
    // TODO: Navigator.pushReplacementNamed(context, result.redirectUrl ?? '/dashboard');
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !_isValidEmail(email)) {
      _showToast(
        'Enter your email first',
        'Type your email above, then tap Forgot password.',
        type: ToastType.error,
      );
      return;
    }
    final result = await AuthService.forgotPassword(email);
    _showToast(
      result.success ? 'Reset link sent' : 'Error',
      result.message,
      type: result.success ? ToastType.success : ToastType.error,
    );
  }

  void _handleGoogle() =>
      _showToast('Google Sign-In', 'Redirecting to Google…', type: ToastType.info);

  void _handleApple() =>
      _showToast('Apple Sign-In', 'Redirecting to Apple…', type: ToastType.info);

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: isWide
          ? Row(children: [
              Expanded(child: const LeftPanel()),
              Expanded(child: _buildRightPanel()),
            ])
          : _buildRightPanel(),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      color: AppColors.cream,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormHeader(),
                    const SizedBox(height: 38),
                    _buildFormFields(),
                    const SizedBox(height: 18),
                    _buildRememberAndForgot(),
                    const SizedBox(height: 28),
                    _buildLoginButton(),
                    const SizedBox(height: 28),
                    _buildDivider(),
                    const SizedBox(height: 28),
                    _buildSocialButtons(),
                    const SizedBox(height: 28),
                    _buildSignUpPrompt(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WELCOME BACK',
          style: TextStyle(
            fontSize: 10.5,
            letterSpacing: 3,
            color: AppColors.clay,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Sign in to\nAfriGlow',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w600,
            color: AppColors.bark,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Access your personalised skincare dashboard and daily rituals.',
          style: TextStyle(
            fontSize: 13.5,
            color: AppColors.muted,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        AfriGlowTextField(
          label: 'Email address',
          placeholder: 'your@email.com',
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          leadingIcon: Icons.mail_outline_rounded,
          errorText: _emailError,
          fieldState: _emailState,
          focusNode: _emailFocus,
          onEditingComplete: () => _pwFocus.requestFocus(),
        ),
        const SizedBox(height: 18),
        AfriGlowTextField(
          label: 'Password',
          placeholder: 'Enter your password',
          controller: _passwordCtrl,
          isPassword: true,
          leadingIcon: Icons.lock_outline_rounded,
          errorText: _passwordError,
          fieldState: _passwordState,
          focusNode: _pwFocus,
          onEditingComplete: _handleLogin,
        ),
      ],
    );
  }

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember me
        GestureDetector(
          onTap: () => setState(() => _rememberMe = !_rememberMe),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: _rememberMe ? AppColors.terracotta : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: _rememberMe ? AppColors.terracotta : AppColors.sand,
                    width: 1.5,
                  ),
                ),
                child: _rememberMe
                    ? const Icon(Icons.check,
                        size: 12, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              const Text(
                'Remember me',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted),
              ),
            ],
          ),
        ),
        // Forgot password
        GestureDetector(
          onTap: _handleForgotPassword,
          child: const Text(
            'Forgot password?',
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.terracotta,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.loginButtonGradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.bark.withOpacity(0.3),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: AppColors.cream,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : const Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColors.warm)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'OR CONTINUE WITH',
            style: TextStyle(
              fontSize: 10.5,
              color: AppColors.sand,
              letterSpacing: 1.8,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: AppColors.warm)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(child: _SocialButton(label: 'Google', icon: _googleIcon, onTap: _handleGoogle)),
        const SizedBox(width: 12),
        Expanded(child: _SocialButton(label: 'Apple', icon: _appleIcon, onTap: _handleApple)),
      ],
    );
  }

  Widget _buildSignUpPrompt() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: AppColors.muted),
          children: [
            const TextSpan(text: 'New to AfriGlow? '),
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  // TODO: Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'Create your account',
                  style: TextStyle(
                    color: AppColors.terracotta,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Social button ─────────────────────────────────────────────────

class _SocialButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
          decoration: BoxDecoration(
            color: _hovered ? AppColors.warm : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? AppColors.clay : AppColors.warm,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox(width: 9),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── SVG icon widgets ──────────────────────────────────────────────

final _googleIcon = CustomPaint(
  size: const Size(18, 18),
  painter: _GoogleLogoPainter(),
);

final _appleIcon = const Icon(Icons.apple, size: 20, color: AppColors.text);

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Blue (right)
    paint.color = const Color(0xFF4285F4);
    final pathBlue = Path()
      ..moveTo(size.width * 0.94, size.height * 0.51)
      ..lineTo(size.width * 0.94, size.height * 0.51)
      ..arcTo(
        Rect.fromLTWH(0, 0, size.width, size.height),
        -0.35,
        0.35,
        false,
      );
    // Simplified: just draw colored circles approximating the logo
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height),
        -0.52, 1.57, true, paint);
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height),
        1.05, 1.57, true, paint);
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height),
        2.62, 1.57, true, paint);
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height),
        -2.09, 1.57, true, paint);
    // White center
    paint.color = Colors.white;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width * 0.35, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
