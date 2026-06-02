/// Centralised image URL registry.
///
/// Ingredient images → Wikimedia Commons (stable, CC-licensed).
/// Hero / onboarding images → Unsplash (free for apps).
///
/// To swap any image, update the URL here — nothing else needs to change.
class AppImages {
  AppImages._();

  // ── Onboarding hero images ───────────────────────────────────────────────
  static const String onboarding1 =
      'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=800&q=80';
  static const String onboarding2 =
      'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80';
  static const String onboarding3 =
      'https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=800&q=80';

  // ── Home screen banner ───────────────────────────────────────────────────
  static const String homeBanner =
      'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=800&q=80';

  // ── Quiz step backgrounds ─────────────────────────────────────────────────
  static const String quizStep1 =
      'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=800&q=80'; // joyful African woman
  static const String quizStep2 =
      'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=800&q=80'; // skincare mirror
  static const String quizStep3 =
      'https://images.unsplash.com/photo-1573461160327-f450ece34bde?w=800&q=80'; // glowing skin closeup
  static const String quizStep4 =
      'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?w=800&q=80'; // African landscape
  static const String quizStep5 =
      'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800&q=80'; // wellness spa

  // ── African skincare lifestyle ────────────────────────────────────────────
  static const String womanSkincare1 =
      'https://images.unsplash.com/photo-1590005354167-6da97870c757?w=600&q=80';
  static const String womanSkincare2 =
      'https://images.unsplash.com/photo-1529245856630-f4853233d2ea?w=600&q=80';

  // ── Ingredient images (Unsplash CDN — verified African natural photos) ──
  static const String _usp = 'https://images.unsplash.com';

  static const Map<String, String> ingredients = {
    // Shea tree / nuts — West Africa
    'shea_butter':
        '$_usp/photo-1631727078481-802486fcf010?w=600&fit=crop&q=80',
    // Avenue of the Baobabs — Madagascar / East Africa
    'baobab':
        '$_usp/photo-1564198729838-cb82ee0c733c?w=600&fit=crop&q=80',
    // Aloe vera growing wild — Wikimedia (confirmed working)
    'aloe_vera':
        'https://commons.wikimedia.org/wiki/Special:FilePath/Aloe_vera_flower_inset.png?width=400',
    // Moringa oleifera leaves close-up
    'moringa':
        '$_usp/photo-1771643033515-0028fd03b708?w=600&fit=crop&q=80',
    // Nigella sativa (black seed) — Wikimedia (confirmed working)
    'black_seed':
        'https://commons.wikimedia.org/wiki/Special:FilePath/Nigella_sativa_seeds.jpg?width=400',
    // Coconut palm on Mozambique coast — East Africa
    'coconut_oil':
        '$_usp/photo-1544298903-35eee5a95b4d?w=600&fit=crop&q=80',
    // Hibiscus sabdariffa flowers — Wikimedia (confirmed working)
    'hibiscus':
        'https://commons.wikimedia.org/wiki/Special:FilePath/Hibiscus_sabdariffa_flowers.jpg?width=400',
    // Goats on argan tree — Morocco
    'argan_oil':
        '$_usp/photo-1556761308-15bad2570387?w=600&fit=crop&q=80',
    // African savanna tree — Southern Africa (marula habitat)
    'marula':
        '$_usp/photo-1445294211564-3ca59d999abd?w=600&fit=crop&q=80',
    // Natural handmade soap — artisan / African
    'african_black_soap':
        '$_usp/photo-1674469771422-9f01a8345c63?w=600&fit=crop&q=80',
    // South African fynbos landscape — rooibos growing region
    'rooibos':
        '$_usp/photo-1625578905595-b5b9ac27eada?w=600&fit=crop&q=80',
    // Neem (Azadirachta indica) leaves — East/West Africa
    'neem':
        '$_usp/photo-1687945906634-25c66199d941?w=600&fit=crop&q=80',
  };

  static String? forIngredient(String id) => ingredients[id];
}
