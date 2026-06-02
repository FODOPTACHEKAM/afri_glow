import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../theme/app_colors.dart';
import '../../models/skin_analysis.dart';
import '../../data/ingredients_data.dart';
import '../ingredients/ingredient_detail_screen.dart';

class SkinResultScreen extends StatelessWidget {
  final SkinAnalysis analysis;
  const SkinResultScreen({super.key, required this.analysis});

  Color _concernColor(double value) {
    if (value >= 0.7) return AppColors.errorRed;
    if (value >= 0.45) return AppColors.warningAmber;
    return AppColors.successGreen;
  }

  @override
  Widget build(BuildContext context) {
    final suggestedIngs = allIngredients
        .where((i) => analysis.suggestedIngredients.contains(i.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Skin Analysis',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
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
                  CircularPercentIndicator(
                    radius: 70.0,
                    lineWidth: 10.0,
                    percent: (analysis.skinScore / 100).clamp(0.0, 1.0),
                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${analysis.skinScore.toInt()}',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700),
                        ),
                        Text('/100',
                            style: GoogleFonts.poppins(
                                color: Colors.white.withAlpha(160),
                                fontSize: 14)),
                      ],
                    ),
                    progressColor: AppColors.accentGold,
                    backgroundColor: Colors.white.withAlpha(35),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    analysis.scoreLabel,
                    style: GoogleFonts.poppins(
                        color: AppColors.accentGold,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Skin Tone: ${analysis.skinTone}',
                    style: GoogleFonts.poppins(
                        color: Colors.white.withAlpha(200), fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Concerns breakdown
            Text('Skin Concerns Detected',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...analysis.concerns.entries.map((e) {
              final color = _concernColor(e.value);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            e.value >= 0.7
                                ? 'High'
                                : e.value >= 0.45
                                    ? 'Moderate'
                                    : 'Low',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: e.value,
                      backgroundColor: color.withAlpha(25),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Recommendations
            Text('Personalised Recommendations',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.deepGreen.withAlpha(10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.deepGreen.withAlpha(40)),
              ),
              child: Column(
                children: analysis.recommendations
                    .asMap()
                    .entries
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: AppColors.deepGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text('${e.key + 1}',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(e.value,
                                    style: GoogleFonts.poppins(
                                        fontSize: 13, height: 1.5)),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Suggested ingredients
            if (suggestedIngs.isNotEmpty) ...[
              Text('Recommended Ingredients for You',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              SizedBox(
                height: 130,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestedIngs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final ing = suggestedIngs[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                IngredientDetailScreen(ingredient: ing)),
                      ),
                      child: Container(
                        width: 110,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: ing.gradientColors,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ing.emoji,
                                style: const TextStyle(fontSize: 32)),
                            const Spacer(),
                            Text(ing.name,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(
                    context, (route) => route.isFirst),
                child: Text('Back to Home',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
