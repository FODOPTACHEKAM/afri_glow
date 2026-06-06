import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';

// ── Bilingual strings ─────────────────────────────────────────────────────────

class _T {
  const _T(this.en, this.fr);
  final String en;
  final String fr;
  String get(String lang) => lang == 'fr' ? fr : en;
}

const _tTitle        = _T('About AfriGlow',  'À propos');
const _tTagline      = _T('Glow from the inside out', 'Brillez de l\'intérieur');
const _tMissionTitle = _T('Our mission',     'Notre mission');
const _tMission      = _T(
  'AfriGlow is a personalised skincare companion built for melanin-rich skin. We combine African botanical knowledge, AI-powered recommendations, and daily habit tracking to help every African achieve their healthiest glow.',
  'AfriGlow est un compagnon de soins personnalisé conçu pour les peaux riches en mélanine. Nous combinons la connaissance botanique africaine, des recommandations IA et un suivi quotidien pour aider chaque Africain à rayonner.',
);
const _tTeamTitle    = _T('Meet the team',   'Rencontrez l\'équipe');
const _tTeamSub      = _T(
  '5 people building the future of African skincare',
  '5 personnes construisant l\'avenir des soins africains',
);
const _tPrivacy      = _T('Privacy policy',  'Confidentialité');
const _tTerms        = _T('Terms of use',    'Conditions');
const _tContact      = _T('Contact us',      'Contactez-nous');
const _tFooter       = _T('© 2026 AfriGlow. All rights reserved.',
                           '© 2026 AfriGlow. Tous droits réservés.');
const _tMadeWith     = _T('Made with love in Africa 🌍',
                           'Fait avec amour en Afrique 🌍');
const _tCopied       = _T('Email copied to clipboard',
                           'E-mail copié dans le presse-papiers');

// ── Team data ─────────────────────────────────────────────────────────────────

class _Member {
  const _Member({
    required this.nameEn,
    required this.initials,
    required this.roleEn,
    required this.roleFr,
    required this.bioEn,
    required this.bioFr,
    this.email,
    this.photoAsset,
  });

  final String nameEn;
  final String initials;
  final String roleEn;
  final String roleFr;
  final String bioEn;
  final String bioFr;
  final String? email;
  final String? photoAsset;

  String role(String lang) => lang == 'fr' ? roleFr : roleEn;
  String bio(String lang)  => lang == 'fr' ? bioFr  : bioEn;
}

const _team = [
  _Member(
    nameEn:     'Fodop Tachekam Ivan Jordan',
    initials:   'IJ',
    roleEn:     'Scrum Master · DevOps',
    roleFr:     'Scrum Master · DevOps',
    bioEn:      'Not only a developer but an athlete.',
    bioFr:      'Pas seulement développeur, mais aussi athlète.',
    email:      'fodop.jordan@ictuniversity.edu.cm',
    photoAsset: 'assets/images/team/ivan.png',
  ),
  _Member(
    nameEn:     'Arielle Enow Kendre',
    initials:   'AK',
    roleEn:     'Software Engineer',
    roleFr:     'Ingénieure Logiciel',
    bioEn:      'Passionate about building impactful digital solutions.',
    bioFr:      'Passionnée par la création de solutions numériques à fort impact.',
    email:      'arielle.kendre@ictuniversity.edu.cm',
    photoAsset: 'assets/images/team/arielle.png',
  ),
  _Member(
    nameEn:   'Team Member 3',
    initials: 'M3',
    roleEn:   'Coming soon',
    roleFr:   'Bientôt',
    bioEn:    'Details will be added soon.',
    bioFr:    'Les détails seront ajoutés bientôt.',
  ),
  _Member(
    nameEn:   'Team Member 4',
    initials: 'M4',
    roleEn:   'Coming soon',
    roleFr:   'Bientôt',
    bioEn:    'Details will be added soon.',
    bioFr:    'Les détails seront ajoutés bientôt.',
  ),
  _Member(
    nameEn:   'Team Member 5',
    initials: 'M5',
    roleEn:   'Coming soon',
    roleFr:   'Bientôt',
    bioEn:    'Details will be added soon.',
    bioFr:    'Les détails seront ajoutés bientôt.',
  ),
];

// Per-member avatar palette (matches the HTML mockup colours)
const _avatarBg = [
  Color(0xFFFAECE7), // Ivan      — warm orange tint
  Color(0xFFE1F5EE), // Arielle   — mint green tint
  Color(0xFFEEEDFE), // Member 3  — lavender tint
  Color(0xFFE6F1FB), // Member 4  — sky blue tint
  Color(0xFFEAF3DE), // Member 5  — soft green tint
];
const _avatarFg = [
  Color(0xFF8B3A0F),
  Color(0xFF1A6B4A),
  Color(0xFF4B3F9E),
  Color(0xFF1A5C8B),
  Color(0xFF3A6B1A),
];

// ── Screen ────────────────────────────────────────────────────────────────────

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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_tCopied.get(_lang),
              style: GoogleFonts.poppins(fontSize: 13)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.espresso,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final bgColor     = isDark ? AppColors.darkBg     : const Color(0xFFFFF9F6);
    final cardColor   = isDark ? AppColors.darkCard    : Colors.white;
    final borderColor = isDark ? AppColors.darkDivider : const Color(0xFFD3D1C7);
    final textPrimary = isDark ? Colors.white          : const Color(0xFF2C2C2A);
    final textBrown   = isDark ? AppColors.gold        : const Color(0xFF8B3A0F);
    final textRole    = isDark ? AppColors.accentGold  : const Color(0xFFC45E1A);
    final textMuted   = isDark ? Colors.white60        : const Color(0xFF888780);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : const Color(0xFF5A2D16),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            _tTitle.get(_lang),
            key: ValueKey('title-$_lang'),
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _LangToggle(lang: _lang, onToggle: _toggleLang),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── App hero ──────────────────────────────────────────
            _AppHero(lang: _lang, isDark: isDark,
                textBrown: textBrown, textMuted: textMuted, textRole: textRole),

            // ── Mission card ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: _MissionCard(lang: _lang, isDark: isDark,
                  titleColor: textBrown, textColor: textMuted),
            ),

            // ── Info chips ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _InfoChipsRow(
                  borderColor: borderColor,
                  iconColor: textRole,
                  textColor: textMuted),
            ),

            // ── Team header ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      _tTeamTitle.get(_lang),
                      key: ValueKey('tt-$_lang'),
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: textBrown),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      _tTeamSub.get(_lang),
                      key: ValueKey('ts-$_lang'),
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: textMuted, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            // ── Member cards ──────────────────────────────────────
            ...List.generate(_team.length, (i) => Padding(
              padding: EdgeInsets.fromLTRB(
                  20, i == 0 ? 12 : 8, 20,
                  i == _team.length - 1 ? 0 : 0),
              child: _MemberCard(
                member:      _team[i],
                index:       i,
                lang:        _lang,
                cardColor:   cardColor,
                borderColor: borderColor,
                textPrimary: textPrimary,
                textRole:    textRole,
                textMuted:   textMuted,
                onEmail:     _team[i].email != null
                    ? () => _launchEmail(_team[i].email!)
                    : null,
              ),
            )),

            // ── Footer ────────────────────────────────────────────
            _Footer(
              lang:        _lang,
              borderColor: borderColor,
              textRole:    textRole,
              textMuted:   textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Language toggle pill ──────────────────────────────────────────────────────

class _LangToggle extends StatelessWidget {
  const _LangToggle({required this.lang, required this.onToggle});
  final String lang;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.white30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: ['en', 'fr'].map((code) {
            final active = lang == code;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                code.toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: active
                      ? const Color(0xFF5A2D16)
                      : Colors.white54,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── App hero ──────────────────────────────────────────────────────────────────

class _AppHero extends StatelessWidget {
  const _AppHero({
    required this.lang,
    required this.isDark,
    required this.textBrown,
    required this.textMuted,
    required this.textRole,
  });

  final String lang;
  final bool isDark;
  final Color textBrown;
  final Color textMuted;
  final Color textRole;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          // Logo icon box
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.espresso,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
                child: Text('🌿', style: TextStyle(fontSize: 32))),
          ),
          const SizedBox(height: 12),

          Text('AfriGlow',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: textBrown)),
          const SizedBox(height: 4),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              _tTagline.get(lang),
              key: ValueKey('tag-$lang'),
              style: GoogleFonts.poppins(fontSize: 13, color: textMuted),
            ),
          ),
          const SizedBox(height: 10),

          // Version badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCard
                  : const Color(0xFFFAECE7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('Version 1.0.0',
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textRole)),
          ),
        ],
      ),
    );
  }
}

// ── Mission card ──────────────────────────────────────────────────────────────

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.lang,
    required this.isDark,
    required this.titleColor,
    required this.textColor,
  });

  final String lang;
  final bool isDark;
  final Color titleColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : const Color(0xFFFAECE7),
        borderRadius: BorderRadius.circular(14),
        border: isDark
            ? Border.all(color: AppColors.darkDivider, width: 0.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              _tMissionTitle.get(lang),
              key: ValueKey('mt-$lang'),
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: titleColor),
            ),
          ),
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Text(
              _tMission.get(lang),
              key: ValueKey('mb-$lang'),
              style: GoogleFonts.poppins(
                  fontSize: 12, color: textColor, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info chips row ────────────────────────────────────────────────────────────

class _ChipItem {
  final IconData icon;
  final String label;
  const _ChipItem(this.icon, this.label);
}

class _InfoChipsRow extends StatelessWidget {
  const _InfoChipsRow({
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
  });

  final Color borderColor;
  final Color iconColor;
  final Color textColor;

  static const _chips = [
    _ChipItem(Icons.smartphone_rounded,   'Flutter'),
    _ChipItem(Icons.cloud_done_outlined,  'Firebase'),
    _ChipItem(Icons.verified_outlined,    'v1.0.0'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_chips.length, (i) {
        final chip = _chips[i];
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < _chips.length - 1 ? 8 : 0),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Icon(chip.icon, size: 20, color: iconColor),
                const SizedBox(height: 4),
                Text(chip.label,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: textColor)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ── Member card ───────────────────────────────────────────────────────────────

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.member,
    required this.index,
    required this.lang,
    required this.cardColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textRole,
    required this.textMuted,
    this.onEmail,
  });

  final _Member member;
  final int index;
  final String lang;
  final Color cardColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textRole;
  final Color textMuted;
  final VoidCallback? onEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor, width: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SmallAvatar(member: member, index: index),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.nameEn,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textPrimary),
                ),
                const SizedBox(height: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Text(
                    member.role(lang),
                    key: ValueKey('r-${member.initials}-$lang'),
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: textRole),
                  ),
                ),
                const SizedBox(height: 5),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: Text(
                    member.bio(lang),
                    key: ValueKey('b-${member.initials}-$lang'),
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: textMuted, height: 1.5),
                  ),
                ),
                if (member.email != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: onEmail,
                    child: Row(
                      children: [
                        Icon(Icons.mail_outline_rounded,
                            size: 12, color: textMuted),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            member.email!,
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: textMuted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small circular avatar ─────────────────────────────────────────────────────

class _SmallAvatar extends StatelessWidget {
  const _SmallAvatar({required this.member, required this.index});
  final _Member member;
  final int index;

  @override
  Widget build(BuildContext context) {
    final safeIdx = index.clamp(0, _avatarBg.length - 1);
    final bg = _avatarBg[safeIdx];
    final fg = _avatarFg[safeIdx];

    if (member.photoAsset != null) {
      return ClipOval(
        child: Image.asset(
          member.photoAsset!,
          width: 46,
          height: 46,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              _InitialsCircle(initials: member.initials, bg: bg, fg: fg),
        ),
      );
    }
    return _InitialsCircle(initials: member.initials, bg: bg, fg: fg);
  }
}

class _InitialsCircle extends StatelessWidget {
  const _InitialsCircle({
    required this.initials,
    required this.bg,
    required this.fg,
  });
  final String initials;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w500, color: fg),
        ),
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer({
    required this.lang,
    required this.borderColor,
    required this.textRole,
    required this.textMuted,
  });

  final String lang;
  final Color borderColor;
  final Color textRole;
  final Color textMuted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        children: [
          Divider(color: borderColor, thickness: 0.5),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _FooterLink(
                icon: Icons.privacy_tip_outlined,
                label: _tPrivacy.get(lang),
                color: textRole,
              ),
              _FooterLink(
                icon: Icons.description_outlined,
                label: _tTerms.get(lang),
                color: textRole,
              ),
              _FooterLink(
                icon: Icons.mail_outline_rounded,
                label: _tContact.get(lang),
                color: textRole,
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              _tFooter.get(lang),
              key: ValueKey('foot-$lang'),
              style: GoogleFonts.poppins(fontSize: 11, color: textMuted),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              _tMadeWith.get(lang),
              key: ValueKey('made-$lang'),
              style: GoogleFonts.poppins(fontSize: 11, color: textMuted),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.poppins(fontSize: 11, color: color),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
