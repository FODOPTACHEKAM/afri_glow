import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../models/user_profile.dart';
import '../../providers/app_provider.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import '../../utils/app_images.dart';
import '../../utils/responsive.dart';
import '../main_scaffold.dart';

class SkinQuizScreen extends StatefulWidget {
  const SkinQuizScreen({super.key});

  @override
  State<SkinQuizScreen> createState() => _SkinQuizScreenState();
}

class _SkinQuizScreenState extends State<SkinQuizScreen> {
  int _step = 0;
  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  DateTime? _dateOfBirth;
  String _skinType = 'combination';
  final Set<String> _concerns = {};
  String _climate = 'tropical';
  int _waterIntake = 6;
  int _sleepHours = 7;

  // ── Step metadata shown in image overlay ─────────────────────────────────
  static const _stepMeta = [
    ('👋🏾', "Let's get to know you",
        'Your name and birthday help us personalise AfriGlow'),
    ('🪞', "What's your skin type?",
        'Choose the one that best describes your skin'),
    ('🔍', 'What are your concerns?', 'Select all that apply'),
    ('📍', 'Where are you located?',
        'Used for climate-aware recommendations'),
    ('💧', 'Daily Habits',
        'Hydration and sleep quality directly affect your skin health'),
  ];

  // ── Per-step background images ────────────────────────────────────────────
  static const _stepImages = [
    AppImages.quizStep1,
    AppImages.quizStep2,
    AppImages.quizStep3,
    AppImages.quizStep4,
    AppImages.quizStep5,
  ];

  // ── Per-step gradient colours (overlay on image) ──────────────────────────
  static const _stepGradients = [
    [Color(0xFF2E1A0F), Color(0xFF5A2D16)],
    [Color(0xFF1A2A1A), Color(0xFF1B4332)],
    [Color(0xFF1A0D18), Color(0xFF4A1942)],
    [Color(0xFF0D1A2E), Color(0xFF1A3A4A)],
    [Color(0xFF0A1828), Color(0xFF1A2C3E)],
  ];

  // ── Location auto-detect ──────────────────────────────────────────────────
  bool _isDetecting = false;
  LocationResult? _detectedLocation;

  Future<void> _autoDetectLocation() async {
    setState(() => _isDetecting = true);
    try {
      final result = await LocationService.detect();
      if (!mounted) return;
      setState(() {
        _detectedLocation = result;
        _locationCtrl.text = result.displayName;
        _climate = result.climate;
        _isDetecting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDetecting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString(), style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  // ── Skin-type diagnostic ──────────────────────────────────────────────────
  bool _showDiagnostic = false;
  int _diagStep = 0;
  final List<int?> _diagAnswers = [null, null, null];

  static const _skinTypes = [
    ('oily', '💧', 'Oily', 'Shine, enlarged pores, frequent breakouts'),
    ('dry', '🏜️', 'Dry', 'Tight, flaky, rough texture'),
    ('combination', '⚖️', 'Combination', 'Oily T-zone, dry cheeks'),
    ('sensitive', '🌸', 'Sensitive', 'Redness, reactions, easily irritated'),
    ('normal', '✨', 'Normal', 'Balanced, few concerns'),
    ('unknown', '🤷', "I'm Not Sure", 'Take a quick 3-question test'),
  ];

  static const _concernList = [
    ('Acne & Breakouts', '🔴'),
    ('Hyperpigmentation', '🟤'),
    ('Dark Spots', '⚫'),
    ('Dryness', '💧'),
    ('Oiliness', '✨'),
    ('Uneven Skin Tone', '🎨'),
    ('Fine Lines', '〰️'),
    ('Large Pores', '🔵'),
    ('Sensitivity', '🌸'),
    ('Dullness', '😶'),
  ];

  static const _climates = [
    ('tropical', '🌴', 'Tropical', 'Hot & humid year-round'),
    ('harmattan', '🌬️', 'Harmattan / Dry', 'Dry, dusty, low humidity'),
    ('coastal', '🌊', 'Coastal', 'Humid, sea breeze'),
    ('savanna', '🌾', 'Savanna', 'Warm days, cooler nights'),
  ];

  static const _diagQuestions = [
    ('☀️ By midday, how does your face look?', [
      ('Shiny all over', 'oily'),
      ('Shiny only on forehead, nose & chin', 'combination'),
      ('Comfortable and balanced', 'normal'),
      ('Tight, dull or flaky', 'dry'),
      ('Red or blotchy in patches', 'sensitive'),
    ]),
    ('🚿 Right after washing, how does your skin feel within 15 min?', [
      ('Still somewhat oily', 'oily'),
      ('Tight and uncomfortable immediately', 'dry'),
      ('Slightly tight, then settles', 'normal'),
      ('Oily in some areas, tight in others', 'combination'),
      ('Itchy, red or reactive', 'sensitive'),
    ]),
    ('🔴 How often do you get breakouts?', [
      ('Almost every week — constant struggle', 'oily'),
      ('Around periods or when stressed', 'combination'),
      ('Very rarely or never', 'dry'),
      ('Mostly balanced — occasional pimple', 'normal'),
      ('Mainly when I try new products', 'sensitive'),
    ]),
  ];

  static const _skinTypeDescriptions = {
    'oily':
        'Your skin produces excess sebum. African Black Soap, Hibiscus, and Neem are your best friends.',
    'dry':
        'Your skin needs rich moisture. Shea Butter, Baobab Oil, and Marula will transform your skin.',
    'combination':
        'You have an oily T-zone but drier cheeks. Moringa and Hibiscus balance both areas perfectly.',
    'normal':
        'Lucky you — your skin is well-balanced! Maintain that glow with Rooibos and Aloe Vera.',
    'sensitive':
        'Your skin reacts easily. Rooibos, Aloe Vera, and fragrance-free Shea Butter are safest.',
    'unknown': 'Answer the 3 quick questions below to discover your skin type.',
  };

  String _determineSkinType() {
    final scores = <String, int>{
      'oily': 0, 'dry': 0, 'combination': 0, 'normal': 0, 'sensitive': 0
    };
    for (int q = 0; q < _diagQuestions.length; q++) {
      final ans = _diagAnswers[q];
      if (ans == null) continue;
      final type = _diagQuestions[q].$2[ans].$2;
      scores[type] = (scores[type] ?? 0) + 2;
    }
    return scores.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  bool get _canProceed {
    switch (_step) {
      case 0:
        return _nameCtrl.text.trim().isNotEmpty && _dateOfBirth != null;
      case 1:
        return _skinType != 'unknown';
      case 3:
        return _locationCtrl.text.trim().isNotEmpty;
      default:
        return true;
    }
  }

  void _next() {
    if (_step < 4) {
      setState(() => _step++);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final dob = _dateOfBirth!;
    final profile = UserProfile(
      name: _nameCtrl.text.trim(),
      dateOfBirth: dob,
      skinType: _skinType,
      skinConcerns: _concerns.toList(),
      location: _locationCtrl.text.trim(),
      climate: _climate,
      waterIntake: _waterIntake,
      sleepHours: _sleepHours,
    );
    context.read<AppProvider>().setUserProfile(profile);
    await NotificationService.scheduleBirthday(dob, profile.name);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScaffold()),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isTablet = Responsive.isTablet(context);
    final imgH = size.height * (isTablet ? 0.32 : 0.36);
    final meta = _stepMeta[_step];

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // ── Image header ─────────────────────────────────────────────────
          SizedBox(
            height: imgH,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image — switches with step
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: Image.network(
                    _stepImages[_step],
                    key: ValueKey(_step),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: imgH,
                    errorBuilder: (_, __, ___) =>
                        Container(color: _stepGradients[_step][1]),
                  ),
                ),
                // Gradient overlay
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _stepGradients[_step][0].withAlpha(180),
                        _stepGradients[_step][1].withAlpha(240),
                      ],
                    ),
                  ),
                ),
                // Header content
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Responsive.hp(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button + step counter row
                        Row(
                          children: [
                            if (_step > 0)
                              GestureDetector(
                                onTap: () => setState(() {
                                  _step--;
                                  _showDiagnostic = false;
                                }),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(30),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.arrow_back_ios,
                                      color: Colors.white, size: 18),
                                ),
                              )
                            else
                              const SizedBox(width: 36),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(30),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_step + 1} of 5',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Step emoji + title
                        Text(meta.$1,
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 36))),
                        SizedBox(height: Responsive.vp(context, 6)),
                        Text(
                          meta.$2,
                          style: GoogleFonts.poppins(
                            fontSize: Responsive.sp(context, 22),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: Responsive.vp(context, 16)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── White content card ────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_step + 1) / 5,
                        backgroundColor:
                            AppColors.bronze.withAlpha(40),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.deepGreen),
                        minHeight: 4,
                      ),
                    ),
                  ),
                  // Subtitle
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        Responsive.hp(context), 10, Responsive.hp(context), 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        meta.$3,
                        style: GoogleFonts.poppins(
                          fontSize: Responsive.sp(context, 13),
                          color: AppColors.warmBrown,
                        ),
                      ),
                    ),
                  ),
                  // Step content
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                            parent: anim, curve: Curves.easeOut)),
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: _buildStep(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Footer button ─────────────────────────────────────────────────
          _buildFooter(isTablet),
        ],
      ),
    );
  }

  // ── Steps ─────────────────────────────────────────────────────────────────

  Widget _buildStep() {
    final hp = Responsive.hp(context);
    switch (_step) {
      // ── Step 0: Name + Date of Birth ──────────────────────────────────────
      case 0:
        return _ScrollPad(
          key: const ValueKey(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameCtrl,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Your first name',
                  prefixIcon:
                      Icon(Icons.person_outline, color: AppColors.deepGreen),
                ),
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.poppins(
                    fontSize: Responsive.sp(context, 15)),
              ),
              SizedBox(height: Responsive.vp(context, 20)),
              Text('Date of Birth',
                  style: GoogleFonts.poppins(
                      fontSize: Responsive.sp(context, 13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBrown)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dateOfBirth ??
                        DateTime(now.year - 20, now.month, now.day),
                    firstDate: DateTime(now.year - 100),
                    lastDate: DateTime(now.year - 10),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.deepGreen,
                          onPrimary: Colors.white,
                          surface: Colors.white,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) setState(() => _dateOfBirth = picked);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: hp, vertical: 16),
                  decoration: BoxDecoration(
                    color: _dateOfBirth != null
                        ? AppColors.deepGreen.withAlpha(12)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _dateOfBirth != null
                          ? AppColors.deepGreen
                          : const Color(0xFFE0D8D0),
                      width: _dateOfBirth != null ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cake_outlined,
                          color: _dateOfBirth != null
                              ? AppColors.deepGreen
                              : AppColors.warmBrown,
                          size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _dateOfBirth != null
                              ? _fmtDate(_dateOfBirth!)
                              : 'Select your date of birth',
                          style: GoogleFonts.poppins(
                            fontSize: Responsive.sp(context, 14),
                            color: _dateOfBirth != null
                                ? AppColors.deepGreen
                                : AppColors.warmBrown.withAlpha(160),
                          ),
                        ),
                      ),
                      Icon(
                        _dateOfBirth != null
                            ? Icons.check_circle
                            : Icons.calendar_today_outlined,
                        color: _dateOfBirth != null
                            ? AppColors.deepGreen
                            : AppColors.warmBrown,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
              if (_dateOfBirth != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.gold.withAlpha(80)),
                  ),
                  child: Row(
                    children: [
                      const Text('🎂', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "We'll send you a birthday notification on your special day 🌿",
                          style: GoogleFonts.poppins(
                              fontSize: Responsive.sp(context, 12),
                              color: AppColors.darkBrown,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );

      // ── Step 1: Skin type ─────────────────────────────────────────────────
      case 1:
        return _ScrollPad(
          key: const ValueKey(1),
          child: Column(
            children: [
              ..._skinTypes.map((t) {
                final selected = _skinType == t.$1;
                final isUnknown = t.$1 == 'unknown';
                return GestureDetector(
                  onTap: () => setState(() {
                    _skinType = t.$1;
                    if (isUnknown) {
                      _showDiagnostic = true;
                      _diagStep = 0;
                      _diagAnswers.fillRange(0, 3, null);
                    } else {
                      _showDiagnostic = false;
                    }
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? (isUnknown ? AppColors.gold : AppColors.deepGreen)
                          : (isUnknown
                              ? AppColors.gold.withAlpha(15)
                              : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? (isUnknown ? AppColors.gold : AppColors.deepGreen)
                            : (isUnknown
                                ? AppColors.gold.withAlpha(80)
                                : const Color(0xFFE0D8D0)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(t.$2,
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 20))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.$3,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? Colors.white
                                        : AppColors.darkBrown,
                                    fontSize: Responsive.sp(context, 14),
                                  )),
                              Text(t.$4,
                                  style: GoogleFonts.poppins(
                                    fontSize: Responsive.sp(context, 11),
                                    color: selected
                                        ? Colors.white.withAlpha(200)
                                        : AppColors.warmBrown,
                                  )),
                            ],
                          ),
                        ),
                        if (selected && !isUnknown)
                          const Icon(Icons.check_circle,
                              color: AppColors.accentGold, size: 20),
                        if (isUnknown)
                          Icon(
                            selected
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color:
                                selected ? Colors.white : AppColors.gold,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: _buildDiagnosticPanel(),
                crossFadeState: _showDiagnostic
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        );

      // ── Step 2: Concerns ─────────────────────────────────────────────────
      case 2:
        return _ScrollPad(
          key: const ValueKey(2),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _concernList.map((c) {
              final selected = _concerns.contains(c.$1);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) {
                    _concerns.remove(c.$1);
                  } else {
                    _concerns.add(c.$1);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.deepGreen : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: selected
                          ? AppColors.deepGreen
                          : const Color(0xFFE0D8D0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c.$2,
                          style: TextStyle(
                              fontSize: Responsive.sp(context, 15))),
                      const SizedBox(width: 6),
                      Text(c.$1,
                          style: GoogleFonts.poppins(
                            fontSize: Responsive.sp(context, 12),
                            fontWeight: FontWeight.w500,
                            color: selected
                                ? Colors.white
                                : AppColors.darkBrown,
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );

      // ── Step 3: Location ─────────────────────────────────────────────────
      case 3:
        return _ScrollPad(
          key: const ValueKey(3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _isDetecting ? null : _autoDetectLocation,
                  icon: _isDetecting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.deepGreen),
                        )
                      : const Icon(Icons.my_location,
                          color: AppColors.deepGreen, size: 18),
                  label: Text(
                    _isDetecting
                        ? 'Detecting your location…'
                        : 'Auto-detect My Location',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.sp(context, 14)),
                  ),
                ),
              ),
              if (_detectedLocation != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.deepGreen.withAlpha(15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.deepGreen.withAlpha(60)),
                  ),
                  child: Row(
                    children: [
                      const Text('✅', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_detectedLocation!.climateEmoji} ${_detectedLocation!.climateLabel} climate — ${_detectedLocation!.displayName}',
                          style: GoogleFonts.poppins(
                              fontSize: Responsive.sp(context, 12),
                              color: AppColors.deepGreen,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or enter manually',
                      style: GoogleFonts.poppins(
                          fontSize: Responsive.sp(context, 12),
                          color: AppColors.warmBrown)),
                ),
                const Expanded(child: Divider()),
              ]),
              const SizedBox(height: 16),
              TextField(
                controller: _locationCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Yaoundé, Accra, Lagos',
                  prefixIcon: Icon(Icons.location_on_outlined,
                      color: AppColors.deepGreen),
                ),
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.poppins(
                    fontSize: Responsive.sp(context, 15)),
              ),
              const SizedBox(height: 20),
              Text('Your climate zone:',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: Responsive.sp(context, 13),
                      color: AppColors.darkBrown)),
              const SizedBox(height: 10),
              ...(_climates.map((c) {
                final selected = _climate == c.$1;
                return GestureDetector(
                  onTap: () => setState(() => _climate = c.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.deepGreen : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? AppColors.deepGreen
                            : const Color(0xFFE0D8D0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(c.$2,
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 18))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.$3,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? Colors.white
                                        : AppColors.darkBrown,
                                    fontSize: Responsive.sp(context, 13),
                                  )),
                              Text(c.$4,
                                  style: GoogleFonts.poppins(
                                    fontSize: Responsive.sp(context, 11),
                                    color: selected
                                        ? Colors.white.withAlpha(200)
                                        : AppColors.warmBrown,
                                  )),
                            ],
                          ),
                        ),
                        if (selected)
                          const Icon(Icons.check_circle,
                              color: AppColors.accentGold, size: 20),
                      ],
                    ),
                  ),
                );
              })),
            ],
          ),
        );

      // ── Step 4: Water intake + Sleep hours (combined) ─────────────────────
      case 4:
        return _ScrollPad(
          key: const ValueKey(4),
          child: Column(
            children: [
              // Water intake section
              _HabitCard(
                emoji: '💧',
                title: 'Daily Water Intake',
                unit: 'glasses / day',
                value: _waterIntake,
                min: 1,
                max: 20,
                onDecrement: _waterIntake > 1
                    ? () => setState(() => _waterIntake--)
                    : null,
                onIncrement: _waterIntake < 20
                    ? () => setState(() => _waterIntake++)
                    : null,
                tip: _waterTip(_waterIntake),
              ),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(children: [
                  const Expanded(
                      child: Divider(color: Color(0xFFE0D8D0))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('&',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: AppColors.warmBrown,
                            fontWeight: FontWeight.w300)),
                  ),
                  const Expanded(
                      child: Divider(color: Color(0xFFE0D8D0))),
                ]),
              ),

              // Sleep hours section
              _HabitCard(
                emoji: '😴',
                title: 'Hours of Sleep',
                unit: 'hours / night',
                value: _sleepHours,
                min: 4,
                max: 12,
                onDecrement: _sleepHours > 4
                    ? () => setState(() => _sleepHours--)
                    : null,
                onIncrement: _sleepHours < 12
                    ? () => setState(() => _sleepHours++)
                    : null,
                tip: _sleepTip(_sleepHours),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // ── Diagnostic panel ──────────────────────────────────────────────────────

  Widget _buildDiagnosticPanel() {
    final allAnswered = _diagAnswers.every((a) => a != null);
    final result = allAnswered ? _determineSkinType() : null;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.deepGreen.withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepGreen.withAlpha(12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: allAnswered
          ? _buildDiagnosticResult(result!)
          : _buildDiagnosticQuestion(),
    );
  }

  Widget _buildDiagnosticQuestion() {
    final q = _diagQuestions[_diagStep];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
              3,
              (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: i == _diagStep ? 20 : 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: i <= _diagStep
                          ? AppColors.deepGreen
                          : AppColors.deepGreen.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )),
        ),
        const SizedBox(height: 10),
        Text('Question ${_diagStep + 1} of 3',
            style: GoogleFonts.poppins(
                fontSize: Responsive.sp(context, 11),
                color: AppColors.warmBrown,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(q.$1,
            style: GoogleFonts.poppins(
                fontSize: Responsive.sp(context, 13),
                fontWeight: FontWeight.w700,
                color: AppColors.deepGreen,
                height: 1.4)),
        const SizedBox(height: 10),
        ...q.$2.asMap().entries.map((e) {
          final idx = e.key;
          final opt = e.value;
          final selected = _diagAnswers[_diagStep] == idx;
          return GestureDetector(
            onTap: () => setState(() {
              _diagAnswers[_diagStep] = idx;
              if (_diagStep < 2) {
                Future.delayed(const Duration(milliseconds: 250), () {
                  if (mounted) setState(() => _diagStep++);
                });
              }
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 7),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.deepGreen : AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? AppColors.deepGreen
                      : const Color(0xFFE0D8D0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(opt.$1,
                        style: GoogleFonts.poppins(
                            fontSize: Responsive.sp(context, 12),
                            color: selected ? Colors.white : AppColors.darkBrown,
                            fontWeight: FontWeight.w500)),
                  ),
                  if (selected)
                    const Icon(Icons.check_circle,
                        color: AppColors.accentGold, size: 18),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDiagnosticResult(String type) {
    final label = _skinTypes
        .firstWhere((t) => t.$1 == type, orElse: () => _skinTypes[2])
        .$3;
    final emoji = _skinTypes
        .firstWhere((t) => t.$1 == type, orElse: () => _skinTypes[2])
        .$2;
    final desc = _skinTypeDescriptions[type] ?? '';
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.deepGreen.withAlpha(15),
                shape: BoxShape.circle,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your skin type is likely:',
                      style: GoogleFonts.poppins(
                          fontSize: Responsive.sp(context, 11),
                          color: AppColors.warmBrown)),
                  Text('$label Skin',
                      style: GoogleFonts.poppins(
                          fontSize: Responsive.sp(context, 17),
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepGreen)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(desc,
            style: GoogleFonts.poppins(
                fontSize: Responsive.sp(context, 12),
                color: AppColors.darkBrown,
                height: 1.5)),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() {
                  _diagStep = 0;
                  _diagAnswers.fillRange(0, 3, null);
                }),
                child: Text('Redo',
                    style: GoogleFonts.poppins(
                        fontSize: Responsive.sp(context, 12))),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  _skinType = type;
                  _showDiagnostic = false;
                }),
                child: Text('Apply — $label Skin',
                    style: GoogleFonts.poppins(
                        fontSize: Responsive.sp(context, 12),
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Tip widgets ───────────────────────────────────────────────────────────

  Widget _waterTip(int glasses) {
    String msg;
    Color color;
    if (glasses < 6) {
      msg = '⚠️ Too low. Aim for 8+ glasses for healthy skin.';
      color = AppColors.errorRed;
    } else if (glasses <= 8) {
      msg = '✅ Good. Aim for 8+ glasses for optimal hydration.';
      color = AppColors.deepGreen;
    } else {
      msg = '🌟 Excellent! Well-hydrated skin glows.';
      color = AppColors.deepGreen;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(msg,
          style: GoogleFonts.poppins(
              color: color, fontSize: Responsive.sp(context, 12))),
    );
  }

  Widget _sleepTip(int hours) {
    String msg;
    Color color;
    if (hours < 6) {
      msg = '⚠️ Poor sleep accelerates skin aging and breakouts.';
      color = AppColors.errorRed;
    } else if (hours < 8) {
      msg = '✅ Decent. Aim for 7–9 hours for optimal skin repair.';
      color = AppColors.deepGreen;
    } else {
      msg = '🌟 Excellent! Your skin regenerates fully each night.';
      color = AppColors.deepGreen;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(msg,
          style: GoogleFonts.poppins(
              color: color, fontSize: Responsive.sp(context, 12))),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────────

  Widget _buildFooter(bool isTablet) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(
          isTablet ? 40 : Responsive.hp(context),
          8,
          isTablet ? 40 : Responsive.hp(context),
          24),
      child: SizedBox(
        width: double.infinity,
        height: Responsive.buttonH(context),
        child: ElevatedButton(
          onPressed: _canProceed ? _next : null,
          child: Text(
            _step == 4 ? 'Build My Routine 🌿' : 'Continue',
            style: GoogleFonts.poppins(
                fontSize: Responsive.sp(context, 15),
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _fmtDate(DateTime d) {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${m[d.month - 1]} ${d.day}, ${d.year}';
  }
}

// ── Reusable scrollable content pad ──────────────────────────────────────────

class _ScrollPad extends StatelessWidget {
  final Widget child;
  const _ScrollPad({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final hp = Responsive.hp(context);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(hp, 12, hp, 12),
      child: child,
    );
  }
}

// ── Reusable habit counter card ───────────────────────────────────────────────

class _HabitCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String unit;
  final int value;
  final int min;
  final int max;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final Widget tip;

  const _HabitCard({
    required this.emoji,
    required this.title,
    required this.unit,
    required this.value,
    required this.min,
    required this.max,
    required this.onDecrement,
    required this.onIncrement,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0D8D0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(emoji,
                  style:
                      TextStyle(fontSize: Responsive.sp(context, 22))),
              const SizedBox(width: 8),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: Responsive.sp(context, 14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBrown)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CounterBtn(
                  icon: Icons.remove_circle_outline,
                  onTap: onDecrement),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text('$value',
                      style: GoogleFonts.poppins(
                          fontSize: Responsive.sp(context, 44),
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepGreen)),
                  Text(unit,
                      style: GoogleFonts.poppins(
                          color: AppColors.warmBrown,
                          fontSize: Responsive.sp(context, 12))),
                ],
              ),
              const SizedBox(width: 20),
              _CounterBtn(icon: Icons.add_circle_outline, onTap: onIncrement),
            ],
          ),
          const SizedBox(height: 12),
          tip,
        ],
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CounterBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon,
          size: Responsive.iconSize(context, base: 32),
          color: onTap != null
              ? AppColors.deepGreen
              : AppColors.deepGreen.withAlpha(60)),
    );
  }
}
