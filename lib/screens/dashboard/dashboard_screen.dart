import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../providers/app_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});


  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final scores = provider.skinScoreHistory;
    final latestScore = scores.isNotEmpty ? scores.last : 75.0;
    final routineSteps = 5;
    final doneSeps = provider.completedStepsToday;
    final routineProgress = (doneSeps / routineSteps).clamp(0.0, 1.0);

    return
      appBar: AppBar(
        title: Text('My Dashboard',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skin score trend
            _sectionTitle(context, '📈 Skin Score Trend'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8E0D8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Current Score',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.warmBrown)),
                          Text('${latestScore.toInt()}',
                              style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepGreen)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.trending_up,
                                color: AppColors.successGreen, size: 16),
                            const SizedBox(width: 4),
                            Text('+${(latestScore - scores.first).toStringAsFixed(1)}',
                                style: GoogleFonts.poppins(
                                    color: AppColors.successGreen,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: scores.length < 2
                        ? Center(
                            child: Text('Complete more scans to see trends',
                                style: GoogleFonts.poppins(
                                    color: AppColors.warmBrown,
                                    fontSize: 13)))
                        : LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: scores
                                      .asMap()
                                      .entries
                                      .map((e) => FlSpot(
                                          e.key.toDouble(), e.value))
                                      .toList(),
                                  isCurved: true,
                                  color: AppColors.deepGreen,
                                  barWidth: 2.5,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color:
                                        AppColors.deepGreen.withAlpha(35),
                                  ),
                                ),
                              ],
                              titlesData: const FlTitlesData(
                                leftTitles: AxisTitles(
                                    sideTitles:
                                        SideTitles(showTitles: false)),
                                topTitles: AxisTitles(
                                    sideTitles:
                                        SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                    sideTitles:
                                        SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                    sideTitles:
                                        SideTitles(showTitles: false)),
                              ),
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              minY: 40,
                              maxY: 100,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    emoji: '🔥',
                    value: '${provider.routineStreak}',
                    label: 'Day Streak',
                    color: const Color(0xFFE65100),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    emoji: '✅',
                    value:
                        '${provider.completedStepsToday}',
                    label: 'Steps Today',
                    color: AppColors.deepGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    emoji: '💧',
                    value:
                        '${provider.waterGlasses}',
                    label: 'Glasses',
                    color: const Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Routine completion
            _sectionTitle(context, '📋 Today\'s Routine'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8E0D8)),
              ),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 50.0,
                    lineWidth: 7.0,
                    percent: routineProgress,
                    center: Text(
                      '${(routineProgress * 100).toInt()}%',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.deepGreen),
                    ),
                    progressColor: AppColors.deepGreen,
                    backgroundColor: AppColors.cream,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Routine Progress',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(
                          '$doneSeps of $routineSteps steps completed',
                          style: GoogleFonts.poppins(
                              color: AppColors.warmBrown, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          routineProgress == 1.0
                              ? '🎉 All done for today!'
                              : '${routineSteps - doneSeps} step(s) remaining',
                          style: GoogleFonts.poppins(
                              color: routineProgress == 1.0
                                  ? AppColors.successGreen
                                  : AppColors.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Water intake
            _sectionTitle(context, '💧 Hydration Tracker'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8E0D8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${provider.waterGlasses} / 8 glasses',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1565C0))),
                          Text('Recommended: 8 glasses/day',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.warmBrown)),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: provider.decrementWater,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1565C0)
                                    .withAlpha(15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.remove,
                                  color: Color(0xFF1565C0), size: 20),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: provider.incrementWater,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1565C0),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: List.generate(8, (i) {
                      final filled = i < provider.waterGlasses;
                      return Expanded(
                        child: Container(
                          margin:
                              const EdgeInsets.symmetric(horizontal: 2),
                          height: 36,
                          decoration: BoxDecoration(
                            color: filled
                                ? const Color(0xFF1565C0)
                                : const Color(0xFF1565C0).withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text('💧',
                                style: TextStyle(
                                    fontSize: filled ? 16 : 12)),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w700));
  }
}

class _StatCard extends StatelessWidget {
  final String emoji, value, label;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: color)),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 11, color: AppColors.warmBrown)),
        ],
      ),
    );
  }
}
