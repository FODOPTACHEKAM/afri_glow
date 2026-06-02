import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _email = 'fodop.jordan@ictuniversity.edu.cm';

  Future<void> _launchEmail(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: _email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await Clipboard.setData(const ClipboardData(text: _email));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email copied to clipboard',
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
    final surfaceColor =
        isDark ? AppColors.darkCard : Colors.white;
    final bgColor =
        isDark ? AppColors.darkBg : AppColors.background;
    final borderColor =
        isDark ? AppColors.darkDivider : const Color(0xFFEDE5D8);
    final textPrimary =
        isDark ? Colors.white : AppColors.espresso;
    final textSecondary =
        isDark ? Colors.white60 : AppColors.bronze;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('About the Developer',
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          children: [
            // ── Hero card ─────────────────────────────────────────────
            _HeroCard(
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 16),

            // ── Stats row ─────────────────────────────────────────────
            _StatsRow(
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            const SizedBox(height: 16),

            // ── Contact card ──────────────────────────────────────────
            _ContactCard(
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onSendMessage: () => _launchEmail(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero ────────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.surfaceColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  final Color surfaceColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  static const _tags = [
    'Flutter', 'Firebase', 'React', 'Node.js', 'UI/UX', 'SQL',
  ];

  @override
  Widget build(BuildContext context) {
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
            // Portrait
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.38,
              child: const _Portrait(),
            ),

            // Bio
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About me',
                        style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                            color: textSecondary)),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.cormorantGaramond(
                            fontSize: 22,
                            fontWeight: FontWeight.w300,
                            color: textPrimary,
                            height: 1.2),
                        children: const [
                          TextSpan(text: 'Fodop Tachekam\n'),
                          TextSpan(
                            text: 'Ivan Jordan',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('Flutter · React · Firebase · Node.js',
                        style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: textSecondary,
                            letterSpacing: 0.3)),
                    const SizedBox(height: 12),
                    Container(
                        width: 28, height: 1.5, color: textPrimary.withValues(alpha: 0.2)),
                    const SizedBox(height: 12),
                    Text(
                      'Full-stack developer passionate about building seamless mobile and web experiences. Clean code, thoughtful UI, solid backends.',
                      style: GoogleFonts.dmSans(
                          fontSize: 11.5,
                          height: 1.7,
                          color: textSecondary),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _tags
                          .map((t) => _Tag(label: t, borderColor: borderColor, textColor: textSecondary))
                          .toList(),
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

class _Portrait extends StatelessWidget {
  const _Portrait();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 280),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D1F0E), Color(0xFF1A0D05)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle pattern
          Opacity(
            opacity: 0.07,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
              ),
              itemCount: 80,
              itemBuilder: (_, __) => const Center(
                child: Text('✦',
                    style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
          ),
          // Initials avatar
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 2),
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: Text('IJ',
                        style: GoogleFonts.cormorantGaramond(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            color: AppColors.accentGold,
                            letterSpacing: 2)),
                  ),
                ),
                const SizedBox(height: 10),
                Text('FODOPTACHEKAM',
                    style: GoogleFonts.dmSans(
                        fontSize: 8,
                        color: Colors.white38,
                        letterSpacing: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
        color: Colors.transparent,
      ),
      child: Text(label,
          style: GoogleFonts.dmSans(
              fontSize: 9.5,
              letterSpacing: 0.6,
              color: textColor)),
    );
  }
}

// ── Stats ────────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.surfaceColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  final Color surfaceColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('2+', 'Years exp.'),
      ('5+', 'Projects'),
      ('∞', 'Curiosity'),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: List.generate(stats.length * 2 - 1, (i) {
            if (i.isOdd) {
              return VerticalDivider(
                  width: 1, thickness: 0.5, color: borderColor);
            }
            final stat = stats[i ~/ 2];
            return Expanded(
              child: Container(
                color: surfaceColor,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(stat.$1,
                        style: GoogleFonts.cormorantGaramond(
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                            color: textPrimary)),
                    const SizedBox(height: 4),
                    Text(stat.$2.toUpperCase(),
                        style: GoogleFonts.dmSans(
                            fontSize: 9.5,
                            letterSpacing: 1.0,
                            color: textSecondary)),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Contact card ─────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.surfaceColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onSendMessage,
  });

  final Color surfaceColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onSendMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: surfaceColor,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Let's build something.",
                    style: GoogleFonts.cormorantGaramond(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: textPrimary)),
                const SizedBox(height: 6),
                Text(
                  "Got an idea that needs building? I turn concepts into real, polished products — from Flutter apps to full-stack web solutions.",
                  style: GoogleFonts.dmSans(
                      fontSize: 13,
                      height: 1.65,
                      color: textSecondary),
                ),
              ],
            ),
          ),

          Container(height: 0.5, color: borderColor),

          // Body
          Container(
            color: AppColors.background.withValues(alpha: 0.5),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Row(
              children: [
                Icon(Icons.mail_outline_rounded,
                    size: 18, color: textSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('fodop.jordan@ictuniversity.edu.cm',
                      style: GoogleFonts.dmSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: textPrimary)),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onSendMessage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.espresso,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text('Message →',
                        style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: Colors.white,
                            letterSpacing: 0.2)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
