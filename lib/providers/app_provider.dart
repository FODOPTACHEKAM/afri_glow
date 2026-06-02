import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/skin_analysis.dart';
import '../models/chat_message.dart';
import '../models/product.dart';
import '../data/products_data.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  UserProfile? _userProfile;
  SkinAnalysis? _latestAnalysis;
  bool _isOnboarded = false;
  final List<ChatMessage> _messages = [];
  int _navIndex = 0;
  final Set<String> _favoriteProductIds = {};
  final Map<String, bool> _routineChecks = {};
  int _waterGlasses = 0;
  int _routineStreak = 0;
  final List<double> _skinScoreHistory = [68, 71, 70, 74, 75, 73, 77];
  String? _profileImagePath;

  // — Getters —
  ThemeMode get themeMode => _themeMode;
  UserProfile? get userProfile => _userProfile;
  SkinAnalysis? get latestAnalysis => _latestAnalysis;
  bool get isOnboarded => _isOnboarded;
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  int get navIndex => _navIndex;
  int get waterGlasses => _waterGlasses;
  int get routineStreak => _routineStreak;
  List<double> get skinScoreHistory => List.unmodifiable(_skinScoreHistory);
  String? get profileImagePath => _profileImagePath;

  List<Product> get favoriteProducts => allProducts
      .where((p) => _favoriteProductIds.contains(p.id))
      .toList();

  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);

  bool isRoutineStepDone(String stepId) => _routineChecks[stepId] ?? false;

  int get completedStepsToday {
    return _routineChecks.values.where((v) => v).length;
  }

  // — Mutators —
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    _isOnboarded = true;
    _routineStreak = 1;
    notifyListeners();
  }

  void setProfileImagePath(String? path) {
    _profileImagePath = path;
    notifyListeners();
  }

  void setNavIndex(int index) {
    _navIndex = index;
    notifyListeners();
  }

  void setAnalysis(SkinAnalysis analysis) {
    _latestAnalysis = analysis;
    _skinScoreHistory.add(analysis.skinScore);
    if (_skinScoreHistory.length > 14) _skinScoreHistory.removeAt(0);
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }

  void toggleRoutineStep(String stepId) {
    _routineChecks[stepId] = !(_routineChecks[stepId] ?? false);
    notifyListeners();
  }

  void resetRoutineChecks() {
    _routineChecks.clear();
    notifyListeners();
  }

  void incrementWater() {
    if (_waterGlasses < 12) {
      _waterGlasses++;
      notifyListeners();
    }
  }

  void decrementWater() {
    if (_waterGlasses > 0) {
      _waterGlasses--;
      notifyListeners();
    }
  }

  void sendUserMessage(String text) {
    _messages.add(ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 800), () {
      _messages.add(ChatMessage(
        text: _generateResponse(text),
        isUser: false,
        timestamp: DateTime.now(),
        quickReplies: _generateQuickReplies(text),
      ));
      notifyListeners();
    });
  }

  String _generateResponse(String query) {
    final q = query.toLowerCase();

    if (q.contains('dark spot') || q.contains('hyperpigment') || q.contains('dark patch')) {
      return 'For dark spots and hyperpigmentation, the most effective African ingredients are:\n\n🌺 Hibiscus — natural AHAs gently exfoliate pigmented cells\n🌿 Moringa — 46 antioxidants fade discolouration\n🌑 Black Seed Oil — reduces post-inflammatory hyperpigmentation\n\nKey tip: Always use SPF 30+ daily — without sun protection, dark spots will keep returning even with treatment. Expect visible results in 6–8 weeks of consistent use.';
    } else if (q.contains('oily') || q.contains('shine') || q.contains('greasy')) {
      return 'For oily skin, these African ingredients are your best allies:\n\n🧼 African Black Soap — deep cleanses without stripping\n🌺 Hibiscus — minimises pores with natural AHAs\n🌵 Aloe Vera — lightweight hydration, no added shine\n🌱 Neem — antibacterial control of oil-causing bacteria\n\nAvoid heavy oils like Coconut Oil on your face if you are oily. Aloe Vera gel is your perfect moisturiser.';
    } else if (q.contains('dry') || q.contains('flaky') || q.contains('tight')) {
      return 'Dry skin thrives with Africa\'s richest natural emollients:\n\n🫙 Shea Butter — the ultimate barrier repair and deep moisturiser\n🌳 Baobab Oil — Omega 3, 6, 9 penetrate all three skin layers\n🫧 Marula Oil — 70% oleic acid, fast-absorbing and non-greasy\n\nLayer these: serum first (Baobab), then moisturiser (Shea Butter), then oil (Marula) to seal. During Harmattan, switch to richer formulas.';
    } else if (q.contains('acne') || q.contains('pimple') || q.contains('breakout')) {
      return 'For acne, African ingredients with proven antibacterial and anti-inflammatory effects:\n\n🧼 African Black Soap — the gold standard cleanser for acne skin\n🌑 Black Seed Oil — thymoquinone is clinically proven anti-inflammatory\n🌱 Neem — nimbidin kills acne-causing P. acnes bacteria\n🌵 Aloe Vera — soothes inflammation and promotes healing\n\nConsistency is everything with acne treatment. Give your routine at least 6 weeks.';
    } else if (q.contains('sensitive') || q.contains('irritat') || q.contains('redness') || q.contains('rosacea')) {
      return 'Sensitive skin needs the gentlest African botanicals:\n\n🍂 Rooibos — unique aspalathin antioxidant, exceptional anti-inflammatory\n🌵 Aloe Vera — instant soothing relief for reactive skin\n🫙 Unscented Shea Butter — barrier repair without irritants\n\nPatch test everything before applying to your full face. Avoid fragranced products, alcohol-based toners, and physical scrubs.';
    } else if (q.contains('dry season') || q.contains('harmattan') || q.contains('winter')) {
      return 'During dry season / Harmattan, your skin needs extra protection:\n\n🛡️ Upgrade from lotion → cream → butter\n🌳 Add Baobab serum under your moisturiser\n🫧 Seal with Marula or Argan oil as the final step\n💧 Drink at least 2L of water daily\n\nHarmattan winds can rob your skin of 40% more moisture than usual. Your routine should be richer, and you can apply a thin layer of Shea Butter before going outside.';
    } else if (q.contains('humid') || q.contains('rainy') || q.contains('summer')) {
      return 'In humid climates like coastal Cameroon or the Congo Basin:\n\n💧 Switch to lighter formulas — gels and serums instead of creams\n🌵 Aloe Vera gel is perfect as a moisturiser\n🌺 Hibiscus toner helps control excess oil from humidity\n🧼 African Black Soap cleanses away sweat and bacteria\n\nHumidity adds moisture to your skin, so you need LESS product, not more. Focus on lightweight hydration and consistent SPF.';
    } else if (q.contains('aging') || q.contains('wrinkle') || q.contains('fine line')) {
      return 'For anti-aging, Africa\'s most powerful ingredients:\n\n🌳 Baobab Oil — Omega fatty acids boost elasticity and collagen\n🫒 Argan Oil — polyphenols and vitamin E reduce fine lines\n🫧 Marula Oil — vitamin C content 8× higher than oranges\n🌺 Hibiscus — anthocyanins fight free radicals that cause aging\n\nSPF is the most important anti-aging product. UV damage causes up to 80% of visible skin aging.';
    } else if (q.contains('hello') || q.contains('hi ') || q.startsWith('hi') || q.contains('hey')) {
      return 'Hello! 👋🏾 I\'m AfriGlow AI, your personal African skincare assistant.\n\nI can help you with:\n• Understanding your skin concerns\n• Recommending African ingredients\n• Adapting your routine to your climate\n• Explaining the science behind ingredients\n\nWhat skin concern can I help you with today?';
    } else if (q.contains('ingredient') || q.contains('what should')) {
      return 'The AfriGlow ingredient library has 12 powerful African skincare ingredients, each with detailed scientific evidence and traditional uses. Tap "Ingredients" in the bottom navigation to explore them all.\n\nMy top 3 recommendations for every skin type:\n🫙 Shea Butter — moisturises and protects all skin types\n🌵 Aloe Vera — soothes and hydrates all skin types\n☀️ SPF 30+ — protects against UV-induced damage daily';
    } else {
      return 'Great question! 🌿 Based on African skincare wisdom and modern science, I recommend exploring our ingredient library for personalised guidance.\n\nFor the most personalised advice, try our AI Skin Scanner (tap the camera icon) to get a detailed analysis of your skin and tailored ingredient recommendations.\n\nYou can also ask me about specific concerns like "dark spots," "oily skin," "dry season skincare," or "acne."';
    }
  }

  List<String> _generateQuickReplies(String query) {
    final q = query.toLowerCase();
    if (q.contains('acne') || q.contains('oily')) {
      return ['Best African cleanser?', 'Spot treatment tips', 'Diet and acne'];
    } else if (q.contains('dry') || q.contains('harmattan')) {
      return ['Best body moisturiser?', 'Dry season routine', 'Face oil guide'];
    } else if (q.contains('dark spot') || q.contains('hyperpigment')) {
      return ['How long for results?', 'SPF recommendations', 'Brightening routine'];
    }
    return ['Dark spots help', 'Oily skin tips', 'Dry season routine', 'Best ingredients'];
  }

  // ── Firebase integration ───────────────────────────────────────────────────

  /// Populate local state from a Firestore user document map.
  void loadFromMap(Map<String, dynamic> data) {
    _userProfile = UserProfile(
      name: data['name'] ?? '',
      dateOfBirth: data['dateOfBirth'] != null
          ? DateTime.parse(data['dateOfBirth'] as String)
          : DateTime(2000, 1, 1),
      skinType: data['skinType'] ?? 'combination',
      skinConcerns: List<String>.from(data['skinConcerns'] ?? []),
      location: data['location'] ?? '',
      climate: data['climate'] ?? 'tropical',
      waterIntake: (data['waterIntake'] as num?)?.toInt() ?? 6,
      sleepHours: (data['sleepHours'] as num?)?.toInt() ?? 7,
    );
    _isOnboarded = data['isOnboarded'] == true;
    _favoriteProductIds
      ..clear()
      ..addAll(List<String>.from(data['favorites'] ?? <String>[]));

    notifyListeners();
  }

  /// Clear all user data when signing out.
  void resetForSignOut() {
    _userProfile = null;
    _isOnboarded = false;
    _latestAnalysis = null;
    _messages.clear();
    _favoriteProductIds.clear();
    _routineChecks.clear();
    _waterGlasses = 0;
    _routineStreak = 0;
    _skinScoreHistory
      ..clear()
      ..addAll([68, 71, 70, 74, 75, 73, 77]);
    _profileImagePath = null;
    _navIndex = 0;
    notifyListeners();
  }
}
