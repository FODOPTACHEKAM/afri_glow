import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../providers/app_provider.dart';
import '../../data/routines_data.dart';
import '../../models/routine.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final skinType = provider.userProfile?.skinType ?? 'normal';
    final routines = getRoutinesForSkinType(skinType);
    final morning = routines.firstWhere((r) => r.type == 'morning',
        orElse: () => routines.first);
    final evening = routines.firstWhere((r) => r.type == 'evening',
        orElse: () => routines.first);
    final weekly = routines.firstWhere((r) => r.type == 'weekly',
        orElse: () => routines.first);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Routine',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        bottom: TabBar(
          controller: _tabs,
          labelStyle:
              GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
          unselectedLabelStyle:
              GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withAlpha(160),
          indicatorColor: AppColors.accentGold,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: '☀️ Morning'),
            Tab(text: '🌙 Evening'),
            Tab(text: '📅 Weekly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _RoutineTab(routine: morning, provider: provider),
          _RoutineTab(routine: evening, provider: provider),
          _RoutineTab(routine: weekly, provider: provider),
        ],
      ),
    );
  }
}

class _RoutineTab extends StatelessWidget {
  final Routine routine;
  final AppProvider provider;

  const _RoutineTab({required this.routine, required this.provider});

  @override
  Widget build(BuildContext context) {
    final totalSteps = routine.steps.length;
    final doneSteps = routine.steps
        .where((s) => provider.isRoutineStepDone('${routine.id}_${s.stepNumber}'))
        .length;
    final progress = totalSteps > 0 ? doneSteps / totalSteps : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.deepGreen, AppColors.medGreen],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(routine.name,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(routine.description,
                              style: GoogleFonts.poppins(
                                  color: Colors.white.withAlpha(190),
                                  fontSize: 12,
                                  height: 1.4)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        Text('$doneSteps/$totalSteps',
                            style: GoogleFonts.poppins(
                                color: AppColors.accentGold,
                                fontSize: 22,
                                fontWeight: FontWeight.w700)),
                        Text('steps done',
                            style: GoogleFonts.poppins(
                                color: Colors.white.withAlpha(180),
                                fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withAlpha(35),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  progress == 1.0
                      ? '✅ Routine complete! Great work!'
                      : '${(progress * 100).toInt()}% complete',
                  style: GoogleFonts.poppins(
                      color: Colors.white.withAlpha(200), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Steps
          ...routine.steps.map((step) {
            final key = '${routine.id}_${step.stepNumber}';
            final done = provider.isRoutineStepDone(key);
            return _StepCard(
              step: step,
              isDone: done,
              onToggle: () => provider.toggleRoutineStep(key),
            );
          }),

          if (doneSteps == totalSteps && totalSteps > 0)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.successGreen.withAlpha(60)),
              ),
              child: Row(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Routine Complete!',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: AppColors.successGreen)),
                        Text('Consistency is the key to great skin. Keep it up!',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: AppColors.darkBrown)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // Reset button
          if (doneSteps > 0)
            Center(
              child: TextButton.icon(
                onPressed: provider.resetRoutineChecks,
                icon: const Icon(Icons.refresh, color: AppColors.warmBrown),
                label: Text('Reset Today\'s Progress',
                    style: GoogleFonts.poppins(
                        color: AppColors.warmBrown, fontSize: 13)),
              ),
            ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final RoutineStep step;
  final bool isDone;
  final VoidCallback onToggle;

  const _StepCard(
      {required this.step,
      required this.isDone,
      required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.deepGreen.withAlpha(10)
            : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone
              ? AppColors.deepGreen.withAlpha(60)
              : const Color(0xFFE8E0D8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDone
                    ? AppColors.deepGreen
                    : AppColors.cream,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : Text('${step.stepNumber}',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepGreen,
                            fontSize: 14)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(step.emoji,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(step.title,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: isDone
                                    ? AppColors.deepGreen
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                decoration: isDone
                                    ? TextDecoration.none
                                    : null)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(step.ingredient,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(step.instructions,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.warmBrown,
                          height: 1.4)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 12, color: AppColors.warmBrown),
                      const SizedBox(width: 4),
                      Text(step.duration,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: AppColors.warmBrown)),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppColors.deepGreen : Colors.transparent,
                  border: Border.all(
                    color: isDone ? AppColors.deepGreen : AppColors.warmBrown,
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
