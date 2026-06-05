import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../onboarding/onboarding_screen.dart';
import 'about_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(80),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Update Profile Picture',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.deepGreen.withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt_outlined,
                      color: AppColors.deepGreen),
                ),
                title: Text('Take a Photo',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600)),
                subtitle: Text('Use your camera',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.warmBrown)),
                onTap: () =>
                    Navigator.pop(context, ImageSource.camera),
              ),
              const SizedBox(height: 4),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withAlpha(15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library_outlined,
                      color: AppColors.gold),
                ),
                title: Text('Choose from Gallery',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600)),
                subtitle: Text('Pick an existing photo',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.warmBrown)),
                onTap: () =>
                    Navigator.pop(context, ImageSource.gallery),
              ),
              if (context.read<AppProvider>().profileImagePath !=
                  null) ...[
                const SizedBox(height: 4),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.errorRed.withAlpha(15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline,
                        color: AppColors.errorRed),
                  ),
                  title: Text('Remove Photo',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColors.errorRed)),
                  onTap: () => Navigator.pop(context, null),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    // null means "remove" was tapped
    if (!mounted) return;
    final provider = context.read<AppProvider>();

    if (source == null &&
        context.read<AppProvider>().profileImagePath != null) {
      provider.setProfileImagePath(null);
      return;
    }
    if (source == null) return;

    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 600,
      );
      if (picked != null && mounted) {
        provider.setProfileImagePath(picked.path);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not access camera / gallery',
                style: GoogleFonts.poppins()),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.userProfile;
    final isDark = provider.themeMode == ThemeMode.dark;
    final imagePath = provider.profileImagePath;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: Icon(
              isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: Colors.white,
            ),
            onPressed: provider.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Profile card ────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.deepGreen, AppColors.medGreen],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // ── Avatar with camera badge ─────────────────────────
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Avatar circle
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.gold, width: 2.5),
                            color: AppColors.gold.withAlpha(50),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: imagePath != null
                              ? ClipOval(
                                  child: Image.file(
                                    File(imagePath),
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _initialsWidget(user?.name),
                                  ),
                                )
                              : _initialsWidget(user?.name),
                        ),
                        // Camera badge
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'AfriGlow User',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                  if (user != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withAlpha(50),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.gold.withAlpha(100)),
                      ),
                      child: Text(
                        user.skinTypeLabel,
                        style: GoogleFonts.poppins(
                            color: AppColors.accentGold,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '📍 ${user.location} · ${user.climate.toUpperCase()} climate',
                      style: GoogleFonts.poppins(
                          color: Colors.white.withAlpha(200),
                          fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    'Tap avatar to change photo',
                    style: GoogleFonts.poppins(
                        color: Colors.white.withAlpha(120),
                        fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Stats row ───────────────────────────────────────────────
            if (user != null) ...[
              Row(
                children: [
                  _StatTile(
                      value: '${provider.routineStreak}d',
                      label: 'Streak',
                      color: AppColors.errorRed),
                  _StatTile(
                      value:
                          '${provider.favoriteProducts.length}',
                      label: 'Favourites',
                      color: AppColors.gold),
                  _StatTile(
                      value:
                          '${provider.latestAnalysis?.skinScore.toInt() ?? '--'}',
                      label: 'Skin Score',
                      color: AppColors.deepGreen),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // ── Skin Profile ────────────────────────────────────────────
            if (user != null) ...[
              _Card(
                title: '🪞 Skin Profile',
                child: Column(
                  children: [
                    _InfoRow('Birthday', user.formattedDob),
                    _InfoRow('Age', '${user.age} years'),
                    _InfoRow('Skin Type', user.skinTypeLabel),
                    _InfoRow('Climate', user.climate),
                    _InfoRow('Location', user.location),
                    _InfoRow(
                        'Daily Water', '${user.waterIntake} glasses'),
                    _InfoRow(
                        'Sleep', '${user.sleepHours} hours/night'),
                    if (user.skinConcerns.isNotEmpty)
                      _InfoRow(
                          'Concerns', user.skinConcerns.join(', ')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Settings ────────────────────────────────────────────────
            _Card(
              title: '⚙️ Settings',
              child: Column(
                children: [
                  _ToggleTile(
                    icon: isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    value: isDark,
                    onChanged: (_) => provider.toggleTheme(),
                  ),
                  const Divider(height: 1),
                  _TapTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Notifications — coming soon!',
                            style: GoogleFonts.poppins()),
                        backgroundColor: AppColors.deepGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  _TapTile(
                    icon: Icons.language_outlined,
                    label: 'Language',
                    trailing: 'English',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── About ───────────────────────────────────────────────────
            _Card(
              title: '👥 About Us',
              child: Column(
                children: [
                  _TapTile(
                      icon: Icons.people_outline_rounded,
                      label: 'Meet the Team',
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AboutScreen()),
                          )),
                  const Divider(height: 1),
                  _TapTile(
                      icon: Icons.shield_outlined,
                      label: 'Privacy Policy',
                      onTap: () {}),
                  const Divider(height: 1),
                  _TapTile(
                      icon: Icons.star_outline,
                      label: 'Rate AfriGlow',
                      onTap: () {}),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => const OnboardingScreen()),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.refresh),
                label: Text('Redo Skin Quiz',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade300),
                ),
                onPressed: () async {
                  final authProvider = context.read<AuthProvider>();
                  final appProvider = context.read<AppProvider>();
                  final navigator = Navigator.of(context);
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Sign Out',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600)),
                      content: Text(
                          'Are you sure you want to sign out?',
                          style: GoogleFonts.poppins()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text('Sign Out',
                              style: TextStyle(
                                  color: Colors.red.shade700)),
                        ),
                      ],
                    ),
                  );
                  if (confirmed != true || !mounted) return;
                  await authProvider.signOut();
                  if (!mounted) return;
                  appProvider.resetForSignOut();
                  navigator.pushAndRemoveUntil(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LoginScreen(),
                      transitionsBuilder: (_, anim, __, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration:
                          const Duration(milliseconds: 400),
                    ),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: Text('Sign Out',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'AfriGlow v1.0.0\nAI-powered skincare for African skin 🌍',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.warmBrown,
                  height: 1.6),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _initialsWidget(String? name) {
    return Center(
      child: Text(
        name?.isNotEmpty == true ? name![0].toUpperCase() : 'A',
        style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ── Supporting widgets ─────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatTile(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withAlpha(12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: color)),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.warmBrown)),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E0D8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(title,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700, fontSize: 15)),
          ),
          const Divider(height: 1),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: AppColors.warmBrown)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile(
      {required this.icon,
      required this.label,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.deepGreen, size: 22),
      title: Text(label, style: GoogleFonts.poppins(fontSize: 14)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.deepGreen,
      ),
    );
  }
}

class _TapTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  const _TapTile(
      {required this.icon,
      required this.label,
      this.trailing,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.deepGreen, size: 22),
      title: Text(label, style: GoogleFonts.poppins(fontSize: 14)),
      trailing: trailing != null
          ? Text(trailing!,
              style: GoogleFonts.poppins(
                  color: AppColors.warmBrown, fontSize: 13))
          : const Icon(Icons.chevron_right,
              color: AppColors.warmBrown, size: 20),
      onTap: onTap,
    );
  }
}
