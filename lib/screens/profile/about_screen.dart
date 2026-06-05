import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';

// ── Translations ──────────────────────────────────────────────────────────────

class _T {
  const _T(this.en, this.fr);
  final String en;
  final String fr;
  String get(String lang) => lang == 'fr' ? fr : en;
}

const _tTitle        = _T('About Us',         'À propos');
const _tBadge        = _T('AfriGlow',          'AfriGlow');
const _tHeadline     = _T('Meet the\nteam behind\nAfriGlow.',
                           'Rencontrez\nl\'équipe derrière\nAfriGlow.');
const _tSubtitle     = _T(
  'Five students from ICT University building a skincare app that celebrates African beauty ingredients.',
  'Cinq étudiants de l\'ICT University qui développent une application de soins valorisant les ingrédients beauté africains.',
);
const _tEngineers    = _T('Engineers',  'Ingénieurs');
const _tFeatures     = _T('Features',   'Fonctions');
const _tAmbition     = _T('Ambition',   'Ambition');
const _tTeamLabel    = _T('THE TEAM',   'L\'ÉQUIPE');
const _tMembers      = _T('members',    'membres');
const _tSendMessage  = _T('Send message', 'Envoyer un message');
const _tCopied       = _T('Email copied to clipboard', 'E-mail copié dans le presse-papiers');

// ── Team data ────────────────────────────────────────────────────────────────

class _Member {
  const _Member({
    required this.nameEn,
    required this.initials,
    required this.roleEn,
    required this.roleFr,
    required this.bioEn,
    required this.bioFr,
    required this.tags,
    this.email,
    this.photoAsset,
  });

  final String nameEn;
  final String initials;
  final String roleEn;
  final String roleFr;
  final String bioEn;
  final String bioFr;
  final List<String> tags;
  final String? email;
  final String? photoAsset;

  String role(String lang) => lang == 'fr' ? roleFr : roleEn;
  String bio(String lang)  => lang == 'fr' ? bioFr  : bioEn;
}

const _team = [
  _Member(
    nameEn:     'Fodop Tachekam Ivan Jordan',
    initials:   'IJ',
    roleEn:     'Software Engineer',
    roleFr:     'Ingénieur Logiciel',
    bioEn:      'Full-stack developer passionate about building seamless mobile and web experiences. Clean code, thoughtful UI, solid backends.',
    bioFr:      'Développeur full-stack passionné par la création d\'expériences mobiles et web fluides. Code propre, UI soignée, backends solides.',
    tags:       ['Flutter', 'Firebase', 'React', 'Node.js', 'UI/UX', 'SQL'],
    email:      'fodop.jordan@ictuniversity.edu.cm',
    photoAsset: 'assets/images/team/ivan.jpg',
  ),
  _Member(
    nameEn:   'Team Member 2',
    initials: 'M2',
    roleEn:   'Coming soon',
    roleFr:   'Bientôt',
    bioEn:    'Details will be added soon.',
    bioFr:    'Les détails seront ajoutés bientôt.',
    tags:     [],
  ),
  _Member(
    nameEn:   'Team Member 3',
    initials: 'M3',
    roleEn:   'Coming soon',
    roleFr:   'Bientôt',
    bioEn:    'Details will be added soon.',
    bioFr:    'Les détails seront ajoutés bientôt.',
    tags:     [],
  ),
  _Member(
    nameEn:   'Team Member 4',
    initials: 'M4',
    roleEn:   'Coming soon',
    roleFr:   'Bientôt',
    bioEn:    'Details will be added soon.',
    bioFr:    'Les détails seront ajoutés bientôt.',
    tags:     [],
  ),
  _Member(
    nameEn:   'Team Member 5',
    initials: 'M5',
    roleEn:   'Coming soon',
    roleFr:   'Bientôt',
    bioEn:    'Details will be added soon.',
    bioFr:    'Les détails seront ajoutés bientôt.',
    tags:     [],
  ),
];

// ── Screen ───────────────────────────────────────────────────────────────────

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _lang = 'en';

  void _toggleLang() => setState(() => _lang = _lang == 'en' ? 'fr' : 'en');

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await Clipboard.setData(ClipboardData(text: email));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_tCopied.get(_lang),
                style: GoogleFonts.poppins(fontSize: 13)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.espresso,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor      = isDark ? AppColors.darkBg   : AppColors.background;
    final surfaceColor = isDark ? AppColors.darkCard  : Colors.white;
    final borderColor  = isDark ? AppColors.darkDivider : const Color(0xFFEDE5D8);
    final textPrimary  = isDark ? Colors.white        : AppColors.espresso;
    final textSecondary = isDark ? Colors.white60     : AppColors.bronze;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // ── App bar with language toggle ────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: bgColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.pop(context),
              color: textPrimary,
            ),
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _tTitle.get(_lang),
                key: ValueKey(_lang),
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textPrimary),
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _LangToggle(
                  lang: _lang,
                  onToggle: _toggleLang,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                ),
              ),
            ],
          ),

          // ── Hero banner ────────────────────────────────────────
          SliverToBoxAdapter(
            child: _HeroBanner(lang: _lang),
          ),

          // ── Team header ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
              child: Row(
                children: [
                  Container(width: 3, height: 18, color: AppColors.gold),
                  const SizedBox(width: 10),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      _tTeamLabel.get(_lang),
                      key: ValueKey('team-$_lang'),
                      style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.8,
                          color: textSecondary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Divider(color: borderColor, thickness: 0.5)),
                  const SizedBox(width: 8),
                  Text('${_team.length} ${_tMembers.get(_lang)}',
                      style: GoogleFonts.dmSans(
                          fontSize: 10.5, color: textSecondary)),
                ],
              ),
            ),
          ),

          // ── Member cards ───────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: EdgeInsets.fromLTRB(
                    20, i == 0 ? 14 : 12, 20,
                    i == _team.length - 1 ? 40 : 0),
                child: _MemberCard(
                  member: _team[i],
                  lang: _lang,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onEmail: _team[i].email != null
                      ? () => _launchEmail(_team[i].email!)
                      : null,
                ),
              ),
              childCount: _team.length,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Language toggle pill ──────────────────────────────────────────────────────

class _LangToggle extends StatelessWidget {
  const _LangToggle({
    required this.lang,
    required this.onToggle,
    required this.borderColor,
    required this.textPrimary,
  });

  final String lang;
  final VoidCallback onToggle;
  final Color borderColor;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        height: 32,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: ['en', 'fr'].map((code) {
            final active = lang == code;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: active ? AppColors.espresso : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                code.toUpperCase(),
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: active ? Colors.white : textPrimary.withValues(alpha: 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Hero banner ───────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.lang});

  final String lang;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D1F0E), Color(0xFF1A0D05)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge + year
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.6)),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(_tBadge.get(lang),
                    style: GoogleFonts.dmSans(
                        fontSize: 10,
                        color: AppColors.accentGold,
                        letterSpacing: 1.2)),
              ),
              const Spacer(),
              Text('2025 – 2026',
                  style: GoogleFonts.dmSans(
                      fontSize: 10,
                      color: Colors.white38,
                      letterSpacing: 0.5)),
            ],
          ),
          const SizedBox(height: 20),

          // Headline
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Text(
              _tHeadline.get(lang),
              key: ValueKey('headline-$lang'),
              style: GoogleFonts.cormorantGaramond(
                  fontSize: 34,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  height: 1.15),
            ),
          ),
          const SizedBox(height: 14),

          Container(
              width: 36,
              height: 1,
              color: AppColors.gold.withValues(alpha: 0.5)),
          const SizedBox(height: 14),

          // Subtitle
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Text(
              _tSubtitle.get(lang),
              key: ValueKey('sub-$lang'),
              style: GoogleFonts.dmSans(
                  fontSize: 13, height: 1.7, color: Colors.white60),
            ),
          ),
          const SizedBox(height: 20),

          // Stats
          Row(
            children: [
              _BannerStat(value: '5',   label: _tEngineers.get(lang)),
              _divider(),
              _BannerStat(value: '12+', label: _tFeatures.get(lang)),
              _divider(),
              _BannerStat(value: '∞',   label: _tAmbition.get(lang)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 32,
        color: Colors.white12,
        margin: const EdgeInsets.symmetric(horizontal: 20),
      );
}

class _BannerStat extends StatelessWidget {
  const _BannerStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: GoogleFonts.cormorantGaramond(
                fontSize: 26,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        Text(label.toUpperCase(),
            style: GoogleFonts.dmSans(
                fontSize: 9, letterSpacing: 1.2, color: Colors.white38)),
      ],
    );
  }
}

// ── Member card ───────────────────────────────────────────────────────────────

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.member,
    required this.lang,
    required this.surfaceColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    this.onEmail,
  });

  final _Member member;
  final String lang;
  final Color surfaceColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback? onEmail;

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = member.tags.isEmpty;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo / avatar
            SizedBox(
              width: 100,
              child: _MemberAvatar(
                  member: member, isPlaceholder: isPlaceholder),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Role chip
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Container(
                        key: ValueKey('role-${member.initials}-$lang'),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: isPlaceholder
                              ? borderColor.withValues(alpha: 0.5)
                              : AppColors.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: isPlaceholder
                                ? borderColor
                                : AppColors.gold.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          member.role(lang).toUpperCase(),
                          style: GoogleFonts.dmSans(
                              fontSize: 8.5,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w600,
                              color: isPlaceholder
                                  ? textSecondary.withValues(alpha: 0.6)
                                  : AppColors.gold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Name (same in both languages)
                    Text(
                      member.nameEn,
                      style: GoogleFonts.cormorantGaramond(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: isPlaceholder
                              ? textSecondary.withValues(alpha: 0.5)
                              : textPrimary,
                          height: 1.2),
                    ),
                    const SizedBox(height: 8),

                    Container(
                        width: 24,
                        height: 1,
                        color: textPrimary
                            .withValues(alpha: isPlaceholder ? 0.08 : 0.15)),
                    const SizedBox(height: 8),

                    // Bio
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      transitionBuilder: (child, anim) =>
                          FadeTransition(opacity: anim, child: child),
                      child: Text(
                        member.bio(lang),
                        key: ValueKey('bio-${member.initials}-$lang'),
                        style: GoogleFonts.dmSans(
                            fontSize: 11.5,
                            height: 1.65,
                            color: isPlaceholder
                                ? textSecondary.withValues(alpha: 0.4)
                                : textSecondary),
                      ),
                    ),

                    // Tags
                    if (member.tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: member.tags
                            .map((t) => _Tag(
                                label: t,
                                borderColor: borderColor,
                                textColor: textSecondary))
                            .toList(),
                      ),
                    ],

                    // Email button
                    if (onEmail != null) ...[
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: onEmail,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mail_outline_rounded,
                                size: 14, color: textSecondary),
                            const SizedBox(width: 6),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Text(
                                _tSendMessage.get(lang),
                                key: ValueKey('mail-$lang'),
                                style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: textPrimary,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        textPrimary.withValues(alpha: 0.3)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

// ── Member avatar ─────────────────────────────────────────────────────────────

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({
    required this.member,
    required this.isPlaceholder,
  });

  final _Member member;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 180),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPlaceholder
              ? [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)]
              : [const Color(0xFF3D1F0E), const Color(0xFF1A0D05)],
        ),
      ),
      child: member.photoAsset != null
          ? _PhotoWithFallback(
              assetPath: member.photoAsset!,
              initials: member.initials,
            )
          : _InitialsAvatar(
              initials: member.initials,
              isPlaceholder: isPlaceholder,
            ),
    );
  }
}

class _PhotoWithFallback extends StatelessWidget {
  const _PhotoWithFallback({
    required this.assetPath,
    required this.initials,
  });

  final String assetPath;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _InitialsAvatar(
        initials: initials,
        isPlaceholder: false,
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({
    required this.initials,
    required this.isPlaceholder,
  });

  final String initials;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: 0.06,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
            ),
            itemCount: 40,
            itemBuilder: (_, __) => const Center(
              child: Text('✦',
                  style: TextStyle(color: Colors.white, fontSize: 8)),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isPlaceholder ? Colors.white12 : AppColors.gold,
                    width: 1.5,
                  ),
                  color: Colors.white.withValues(alpha: 0.06),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: GoogleFonts.cormorantGaramond(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: isPlaceholder
                            ? Colors.white24
                            : AppColors.accentGold,
                        letterSpacing: 2),
                  ),
                ),
              ),
              if (!isPlaceholder) ...[
                const SizedBox(height: 8),
                Text(
                  'AFRIGLOW',
                  style: GoogleFonts.dmSans(
                      fontSize: 7, color: Colors.white24, letterSpacing: 1.5),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ── Tag chip ──────────────────────────────────────────────────────────────────

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.borderColor,
    required this.textColor,
  });

  final String label;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: borderColor),
      ),
      child: Text(label,
          style: GoogleFonts.dmSans(
              fontSize: 9.5, letterSpacing: 0.5, color: textColor)),
    );
  }
}
