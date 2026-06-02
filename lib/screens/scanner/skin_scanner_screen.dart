import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../models/skin_analysis.dart';
import '../../providers/app_provider.dart';
import 'skin_result_screen.dart';

class SkinScannerScreen extends StatefulWidget {
  const SkinScannerScreen({super.key});

  @override
  State<SkinScannerScreen> createState() => _SkinScannerScreenState();
}

class _SkinScannerScreenState extends State<SkinScannerScreen> {
  File? _image;
  bool _analyzing = false;
  final _picker = ImagePicker();

  Future<void> _pick(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
      );
      if (picked != null) {
        setState(() => _image = File(picked.path));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not access camera/gallery')),
        );
      }
    }
  }

  Future<void> _analyze() async {
    if (_image == null) return;
    setState(() => _analyzing = true);

    final provider = context.read<AppProvider>();
    final skinType = provider.userProfile?.skinType ?? 'combination';

    await Future.delayed(const Duration(seconds: 3));

    // Mock AI analysis based on skin type
    final analysisMap = {
      'oily': SkinAnalysis(
        skinScore: 68,
        concerns: {
          'Oiliness': 0.72,
          'Acne': 0.48,
          'Large Pores': 0.55,
          'Hyperpigmentation': 0.3,
          'Dryness': 0.08,
        },
        skinTone: 'Medium-Deep',
        recommendations: [
          'Use African Black Soap cleanser twice daily',
          'Apply Hibiscus toner to minimise pores',
          'Spot treat with Black Seed Oil on breakouts',
          'Moisturise with Aloe Vera gel — no heavy creams',
          'Always finish with SPF 30+',
        ],
        suggestedIngredients: [
          'african_black_soap', 'hibiscus', 'black_seed', 'aloe_vera', 'neem',
        ],
        analyzedAt: DateTime.now(),
      ),
      'dry': SkinAnalysis(
        skinScore: 72,
        concerns: {
          'Dryness': 0.78,
          'Tightness': 0.65,
          'Fine Lines': 0.4,
          'Dullness': 0.45,
          'Acne': 0.1,
        },
        skinTone: 'Deep',
        recommendations: [
          'Double-layer with Baobab serum + Shea Butter daily',
          'Seal with Marula oil as the last step',
          'Use gentle milk cleanser — never foaming',
          'Apply Rooibos mist throughout the day',
          'Increase water intake to 8+ glasses daily',
        ],
        suggestedIngredients: [
          'shea_butter', 'baobab', 'marula', 'rooibos', 'coconut_oil',
        ],
        analyzedAt: DateTime.now(),
      ),
      'combination': SkinAnalysis(
        skinScore: 75,
        concerns: {
          'T-Zone Oiliness': 0.6,
          'Dry Patches': 0.4,
          'Hyperpigmentation': 0.35,
          'Large Pores': 0.42,
          'Acne': 0.28,
        },
        skinTone: 'Medium',
        recommendations: [
          'Multi-mask: clay mask on T-zone, Shea on cheeks',
          'Use Hibiscus toner across the whole face',
          'Apply lightweight moisturiser overall',
          'Moringa serum for brightening and balance',
          'SPF 30+ daily — non-negotiable',
        ],
        suggestedIngredients: [
          'hibiscus', 'moringa', 'aloe_vera', 'african_black_soap', 'baobab',
        ],
        analyzedAt: DateTime.now(),
      ),
      'sensitive': SkinAnalysis(
        skinScore: 71,
        concerns: {
          'Redness': 0.62,
          'Irritation': 0.55,
          'Dryness': 0.45,
          'Sensitivity': 0.7,
          'Acne': 0.15,
        },
        skinTone: 'Light-Medium',
        recommendations: [
          'Patch test every new ingredient before full use',
          'Rooibos toner is your safest, most calming option',
          'Fragrance-free Shea Butter for moisture barrier',
          'Avoid physical scrubs — Rooibos AHAs only',
          'Mineral SPF (zinc oxide) — no chemical sunscreens',
        ],
        suggestedIngredients: [
          'rooibos', 'aloe_vera', 'shea_butter', 'baobab', 'marula',
        ],
        analyzedAt: DateTime.now(),
      ),
    };

    final analysis = analysisMap[skinType] ??
        SkinAnalysis(
          skinScore: 75,
          concerns: {
            'Hyperpigmentation': 0.38,
            'Dullness': 0.42,
            'Fine Lines': 0.25,
            'Dryness': 0.3,
            'Acne': 0.18,
          },
          skinTone: 'Medium-Deep',
          recommendations: [
            'Build a consistent routine — consistency beats perfection',
            'Start with Shea Butter + Aloe Vera as your base',
            'Add SPF 30+ every single day without fail',
            'Moringa serum for brightening and antioxidant protection',
            'Stay hydrated — 8 glasses of water daily',
          ],
          suggestedIngredients: [
            'shea_butter', 'aloe_vera', 'moringa', 'hibiscus', 'baobab',
          ],
          analyzedAt: DateTime.now(),
        );

    provider.setAnalysis(analysis);

    if (!mounted) return;
    setState(() => _analyzing = false);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => SkinResultScreen(analysis: analysis)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Scanner',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text('AI Skin Analysis',
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            Text(
              'Take a clear selfie in good lighting for the most accurate analysis.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: AppColors.warmBrown, height: 1.5),
            ),
            const SizedBox(height: 28),

            // Image preview
            GestureDetector(
              onTap: () => _pick(ImageSource.gallery),
              child: Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cream,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.deepGreen.withAlpha(60),
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.deepGreen.withAlpha(15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.face_retouching_natural,
                                color: AppColors.deepGreen, size: 40),
                          ),
                          const SizedBox(height: 16),
                          Text('Tap to upload photo',
                              style: GoogleFonts.poppins(
                                  color: AppColors.deepGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                          const SizedBox(height: 6),
                          Text('or use the buttons below',
                              style: GoogleFonts.poppins(
                                  color: AppColors.warmBrown, fontSize: 13)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Camera / Gallery buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: Text('Camera',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text('Gallery',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gold.withAlpha(15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gold.withAlpha(60)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📸 Tips for best results',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkBrown,
                          fontSize: 13)),
                  const SizedBox(height: 8),
                  ...[
                    'Use natural daylight — avoid harsh artificial light',
                    'Face the camera directly, no angle',
                    'Remove makeup for accurate skin analysis',
                    'Ensure your full face is visible in frame',
                  ].map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Text('✓ ',
                                style: TextStyle(
                                    color: AppColors.deepGreen, fontSize: 12)),
                            Expanded(
                              child: Text(t,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.darkBrown)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Analyse button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed:
                    _image != null && !_analyzing ? _analyze : null,
                child: _analyzing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          Text('Analysing skin...',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ],
                      )
                    : Text('🔬 Analyse My Skin',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
