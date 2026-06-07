// lib/widgets/left_panel.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LeftPanel extends StatelessWidget {
  const LeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.leftPanelGradient,
      ),
      child: Stack(
        children: [
          // Radial glow overlays
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.6, 0.6),
                  radius: 1.1,
                  colors: [
                    AppColors.gold.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Botanical decoration — large circle top-right
          Positioned(
            top: -80,
            right: -80,
            width: 360,
            height: 360,
            child: Opacity(
              opacity: 0.13,
              child: CustomPaint(painter: _BotanicalCirclePainter()),
            ),
          ),
          // Botanical decoration — diamond bottom-left
          Positioned(
            bottom: -60,
            left: -60,
            width: 280,
            height: 280,
            child: Opacity(
              opacity: 0.13,
              child: CustomPaint(painter: _BotanicalDiamondPainter()),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Brand
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.gold, AppColors.clay],
                        ),
                      ),
                      child: const Center(
                        child: Text('✦',
                            style: TextStyle(
                                fontSize: 20, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AfriGlow',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cream,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const Text(
                          'RADIANCE REDEFINED',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 2.8,
                            color: AppColors.goldLite,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Hero text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            width: 28,
                            height: 1,
                            color: AppColors.gold),
                        const SizedBox(width: 8),
                        const Text(
                          'YOUR SKIN JOURNEY',
                          style: TextStyle(
                            fontSize: 10.5,
                            letterSpacing: 3,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w300,
                          color: AppColors.cream,
                          height: 1.12,
                        ),
                        children: [
                          TextSpan(text: 'Rooted in\n'),
                          TextSpan(
                            text: 'African Botanicals,\n',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: AppColors.goldLite,
                            ),
                          ),
                          TextSpan(text: 'crafted for you.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Personalised skincare powered by ancestral wisdom and modern science. '
                      'Discover routines, ingredients, and rituals that honour your skin\'s unique story.',
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.7,
                        color: AppColors.cream.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),

                // Badges
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: const [
                    _Badge('100% Natural'),
                    _Badge('Dermatologist Tested'),
                    _Badge('African Sourced'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.gold.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.goldLite,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom painters for botanical SVG decorations ──

class _BotanicalCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC8A96E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final cx = size.width / 2;
    final cy = size.height / 2;

    canvas.drawCircle(Offset(cx, cy), cx * 0.975, paint);
    paint.strokeWidth = 0.8;
    canvas.drawCircle(Offset(cx, cy), cx * 0.8, paint);

    paint.strokeWidth = 1.0;
    final path = Path();
    // top petal
    path.moveTo(cx, cy - cx * 0.975);
    path.quadraticBezierTo(cx + cx * 0.2, cy, cx, cy);
    path.quadraticBezierTo(cx - cx * 0.2, cy, cx, cy - cx * 0.975);
    canvas.drawPath(path, paint);
    // bottom petal
    final path2 = Path();
    path2.moveTo(cx, cy + cx * 0.975);
    path2.quadraticBezierTo(cx + cx * 0.2, cy, cx, cy);
    path2.quadraticBezierTo(cx - cx * 0.2, cy, cx, cy + cx * 0.975);
    canvas.drawPath(path2, paint);

    canvas.drawCircle(Offset(cx, cy), cx * 0.15, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BotanicalDiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC8A96E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final cx = size.width / 2;
    final cy = size.height / 2;

    final path = Path();
    path.moveTo(cx, 10);
    path.cubicTo(cx + cx * 0.6, cy - cy * 0.4, cx + cx * 0.9, cy - cy * 0.3,
        size.width - 10, cy);
    path.cubicTo(cx + cx * 0.6, cy + cy * 0.4, cx + cx * 0.3, cy + cy * 0.9,
        cx, size.height - 10);
    path.cubicTo(cx - cx * 0.6, cy + cy * 0.4, cx - cx * 0.7, cy + cy * 0.3,
        10, cy);
    path.cubicTo(cx - cx * 0.4, cy - cy * 0.6, cx - cx * 0.3, cy - cy * 0.7,
        cx, 10);
    canvas.drawPath(path, paint);

    paint.strokeWidth = 0.8;
    canvas.drawCircle(Offset(cx, cy), cx * 0.27, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
