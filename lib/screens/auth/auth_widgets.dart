import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

const _googleLogoSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 18 18">
  <path fill="#4285F4" d="M16.51 8H8.98v3h4.3c-.18 1-.74 1.48-1.6 2.04v2.01h2.6a7.8 7.8 0 002.38-5.88c0-.57-.05-.66-.15-1.18z"/>
  <path fill="#34A853" d="M8.98 17c2.16 0 3.97-.72 5.3-1.94l-2.6-2.04a4.8 4.8 0 01-7.18-2.54H1.83v2.07A8 8 0 008.98 17z"/>
  <path fill="#FBBC05" d="M4.5 10.52a4.8 4.8 0 010-3.04V5.41H1.83a8 8 0 000 7.18l2.67-2.07z"/>
  <path fill="#EA4335" d="M8.98 4.18c1.17 0 2.23.4 3.06 1.2l2.3-2.3A8 8 0 001.83 5.4L4.5 7.49a4.77 4.77 0 014.48-3.3z"/>
</svg>
''';

// Shared form widgets used by login, register, and forgot-password screens.

class AuthLabel extends StatelessWidget {
  final String text;
  const AuthLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Text(text,
        style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: onSurface,
            letterSpacing: 0.3));
  }
}

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AuthField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final fillColor = isDark ? AppColors.darkCard : AppColors.background;
    final borderColor = isDark
        ? AppColors.darkDivider
        : AppColors.bronze.withValues(alpha: 0.25);
    final iconColor = isDark ? AppColors.gold : AppColors.bronze;

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14, color: onSurface),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
            fontSize: 13,
            color: (isDark ? Colors.white : AppColors.bronze)
                .withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, color: iconColor, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: fillColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.errorRed, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.errorRed, width: 1.8),
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onTap;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.espresso,
          disabledBackgroundColor:
              AppColors.gold.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: AppColors.espresso))
            : Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3)),
      ),
    );
  }
}

class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark
        ? AppColors.darkDivider
        : AppColors.bronze.withValues(alpha: 0.25);
    final textColor = isDark ? AppColors.gold : AppColors.bronze;

    return Row(
      children: [
        Expanded(
            child: Divider(color: dividerColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('or',
              style: GoogleFonts.poppins(fontSize: 12, color: textColor)),
        ),
        Expanded(
            child: Divider(color: dividerColor, thickness: 1)),
      ],
    );
  }
}

class AuthGoogleButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const AuthGoogleButton(
      {super.key, required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.cream : AppColors.espresso;
    final borderColor = isDark
        ? AppColors.darkDivider
        : AppColors.bronze.withValues(alpha: 0.35);
    final bgColor = isDark ? AppColors.darkCard : Colors.white;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: loading ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: bgColor,
          side: BorderSide(color: borderColor, width: 1.2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.string(_googleLogoSvg, width: 20, height: 20),
            const SizedBox(width: 10),
            Text('Continue with Google',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor)),
          ],
        ),
      ),
    );
  }
}

class AuthErrorBanner extends StatelessWidget {
  final String message;
  const AuthErrorBanner(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: AppColors.errorRed.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline,
              color: AppColors.errorRed, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.errorRed,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
