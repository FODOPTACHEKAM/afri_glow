import '../models/ingredient.dart';
import '../theme/app_colors.dart';
import '../utils/app_images.dart';

final List<Ingredient> allIngredients = [
  Ingredient(
    id: 'shea_butter',
    name: 'Shea Butter',
    scientificName: 'Vitellaria paradoxa',
    origin: 'West Africa',
    country: 'Ghana · Burkina Faso · Mali',
    emoji: '🫙',
    gradientColors: AppColors.sheaGrad,
    description:
        'Extracted from the nuts of the Shea tree, Shea Butter has been used for centuries across West Africa as the ultimate skin and hair protector. Rich in fatty acids and vitamins, it is one of the most versatile skincare ingredients on earth.',
    benefits: [
      'Deeply moisturises and softens skin',
      'Repairs and strengthens the skin barrier',
      'Anti-inflammatory — calms irritation and redness',
      'Rich in vitamins A and E for skin health',
      'Promotes wound healing and scar reduction',
      'Natural UV protection (SPF 3–4)',
    ],
    evidenceLinks: [
      'PubMed: Anti-inflammatory effects of Shea Butter (PMID 20394438)',
      'Journal of Oleo Science: Fatty acid composition and skin penetration',
    ],
    traditionalUses: [
      'Used by West African women as a full-body moisturiser for generations',
      'Applied to babies to protect and nourish their skin',
      'Used during pregnancy to prevent stretch marks',
      'Protects skin from harsh Harmattan dry season winds',
    ],
    commonProducts: [
      'Body butter', 'Face cream', 'Hair butter', 'Lip balm', 'Baby lotion',
    ],
    skinTypes: ['All skin types', 'Especially dry', 'Sensitive'],
    concerns: ['Dryness', 'Eczema', 'Psoriasis', 'Stretch marks', 'Scarring'],
    imageUrl: AppImages.forIngredient('shea_butter'),
  ),
  Ingredient(
    id: 'baobab',
    name: 'Baobab Oil',
    scientificName: 'Adansonia digitata',
    origin: 'Sub-Saharan Africa',
    country: 'Senegal · Mali · Tanzania · Zimbabwe',
    emoji: '🌳',
    gradientColors: AppColors.baobabGrad,
    description:
        'From the legendary "Tree of Life," Baobab oil is pressed from the seeds of the ancient baobab tree. With its exceptional omega fatty acid profile and vitamin content, it is one of Africa\'s most potent anti-aging ingredients.',
    benefits: [
      'Deeply nourishing — penetrates all three skin layers',
      'Boosts skin elasticity and firmness',
      'Rich in Omega 3, 6, and 9 fatty acids',
      'Powerful anti-aging properties',
      'Accelerates skin cell regeneration',
      'Vitamins A, D, E, and F complex',
    ],
    evidenceLinks: [
      'International Journal of Cosmetic Science: Baobab oil skin penetration',
      'African Journal of Biotechnology: Nutritional composition analysis',
    ],
    traditionalUses: [
      'Called "Tree of Life" — every part used for food, medicine, and beauty',
      'Fruit pulp applied as face mask in Sahel regions',
      'Leaves used as anti-inflammatory poultice',
      'Oil used to heal cracked heels and dry skin in dry season',
    ],
    commonProducts: [
      'Anti-aging serum', 'Facial oil', 'Body oil', 'Hair treatment',
    ],
    skinTypes: ['Dry', 'Mature', 'Normal', 'Combination'],
    concerns: ['Anti-aging', 'Dryness', 'Loss of elasticity', 'Fine lines'],
    imageUrl: AppImages.forIngredient('baobab'),
  ),
  Ingredient(
    id: 'aloe_vera',
    name: 'Aloe Vera',
    scientificName: 'Aloe barbadensis miller',
    origin: 'North & East Africa',
    country: 'Ethiopia · Sudan · Egypt · Kenya',
    emoji: '🌵',
    gradientColors: AppColors.aloeGrad,
    description:
        'Ancient Egyptians called Aloe Vera the "Plant of Immortality" and used it in royal beauty rituals for thousands of years. The cooling gel inside its leaves is packed with bioactive compounds that soothe, hydrate, and heal skin.',
    benefits: [
      'Instantly soothes irritated and inflamed skin',
      'Lightweight hydration — perfect for oily skin',
      'Accelerates healing of acne, burns, and wounds',
      'Contains acemannan polysaccharide — deep moisture lock',
      'Natural antioxidants fight free radical damage',
      'Reduces post-acne marks and hyperpigmentation',
    ],
    evidenceLinks: [
      'Indian Journal of Dermatology: Aloe vera in dermatology review',
      'Burns Journal: Aloe vera for burn wound healing (PMID 17499928)',
    ],
    traditionalUses: [
      'Cleopatra reportedly used Aloe Vera as part of her beauty regime',
      'Used across East Africa as after-sun and sunburn relief',
      'Applied fresh-cut leaves directly to skin irritations',
      'Ingested as a health tonic in North African traditions',
    ],
    commonProducts: [
      'Soothing gel', 'Toner', 'After-sun lotion', 'Acne treatment', 'Eye gel',
    ],
    skinTypes: ['All skin types', 'Oily', 'Sensitive', 'Acne-prone'],
    concerns: ['Acne', 'Sunburn', 'Irritation', 'Oiliness', 'Dark spots'],
    imageUrl: AppImages.forIngredient('aloe_vera'),
  ),
  Ingredient(
    id: 'moringa',
    name: 'Moringa',
    scientificName: 'Moringa oleifera',
    origin: 'Sahel & East Africa',
    country: 'Ethiopia · Kenya · Uganda · Nigeria',
    emoji: '🌿',
    gradientColors: AppColors.moringaGrad,
    description:
        'Called the "Miracle Tree," Moringa is one of the most nutrient-dense plants on earth. Used across the African Sahel for both nutrition and skincare, its oil and powder contain 46 antioxidants and a remarkable oleic acid content that makes it a premier brightening and anti-aging ingredient.',
    benefits: [
      'Contains 46 antioxidants — powerful free radical protection',
      'Brightens dull skin and evens skin tone',
      'Anti-aging: stimulates collagen production',
      'Anti-inflammatory — reduces redness and swelling',
      'Behenic acid gives a silky, smooth finish',
      'Detoxifies and purifies congested pores',
    ],
    evidenceLinks: [
      'Asian Pacific Journal of Tropical Biomedicine: Moringa antioxidant profile',
      'Journal of Food Science: Oleic acid content and skin absorption',
    ],
    traditionalUses: [
      'Leaves eaten and applied topically across the Sahel for centuries',
      'Seed oil used to cleanse and protect skin from sun damage',
      'Powder masks used to brighten complexion in Nigeria and Ethiopia',
      'Ancient Egyptians used Moringa oil to protect skin from desert heat',
    ],
    commonProducts: [
      'Brightening serum', 'Face oil', 'Powder mask', 'Eye cream', 'Toner',
    ],
    skinTypes: ['All skin types', 'Oily', 'Combination', 'Mature'],
    concerns: ['Hyperpigmentation', 'Dullness', 'Anti-aging', 'Acne', 'Dark spots'],
    imageUrl: AppImages.forIngredient('moringa'),
  ),
  Ingredient(
    id: 'black_seed',
    name: 'Black Seed Oil',
    scientificName: 'Nigella sativa',
    origin: 'North Africa',
    country: 'Egypt · Ethiopia · Tunisia · Morocco',
    emoji: '🌑',
    gradientColors: AppColors.blackSeedGrad,
    description:
        'Revered in ancient Egypt and across North Africa, Black Seed Oil (Habbatus Sauda) has been used for over 3,000 years. The Prophet Muhammad described it as "a cure for everything except death." Modern science confirms its active compound, thymoquinone, has profound anti-inflammatory and antibacterial effects on skin.',
    benefits: [
      'Thymoquinone: clinically proven anti-inflammatory',
      'Powerful antibacterial — kills acne-causing bacteria',
      'Antifungal properties — treats skin infections',
      'Reduces eczema and psoriasis symptoms',
      'Antioxidant protection against UV damage',
      'Reduces hyperpigmentation and dark spots',
    ],
    evidenceLinks: [
      'Phytotherapy Research: Nigella sativa in dermatological conditions (PMID 24338005)',
      'Journal of Dermatology: Thymoquinone anti-inflammatory mechanism',
    ],
    traditionalUses: [
      'Used in Pharaonic Egypt found in Tutankhamun\'s tomb',
      'Core medicine in North African and Islamic traditional medicine',
      'Applied for eczema, psoriasis, and skin infections across the Maghreb',
      'Used as hair treatment to strengthen and regrow hair',
    ],
    commonProducts: [
      'Acne treatment', 'Facial oil', 'Eczema cream', 'Hair oil', 'Spot treatment',
    ],
    skinTypes: ['Acne-prone', 'Sensitive', 'All skin types'],
    concerns: ['Acne', 'Eczema', 'Hyperpigmentation', 'Infection', 'Inflammation'],
    imageUrl: AppImages.forIngredient('black_seed'),
  ),
  Ingredient(
    id: 'coconut_oil',
    name: 'Coconut Oil',
    scientificName: 'Cocos nucifera',
    origin: 'Coastal Africa',
    country: 'Tanzania · Kenya · Mozambique · Ghana',
    emoji: '🥥',
    gradientColors: AppColors.coconutGrad,
    description:
        'Along Africa\'s vast coastline, coconut oil has long been a daily beauty staple. Its high lauric acid content gives it natural antimicrobial properties, making it effective for cleansing, moisturising, and hair care in tropical coastal climates.',
    benefits: [
      'Lauric acid (50%): natural antimicrobial and antibacterial',
      'Deeply moisturises and softens skin',
      'Effective makeup remover and oil cleanser',
      'Strengthens hair and reduces breakage',
      'Speeds up wound healing',
      'Rich in vitamin E — antioxidant protection',
    ],
    evidenceLinks: [
      'Journal of Dermatological Treatment: Coconut oil vs mineral oil for atopic dermatitis',
      'International Journal of Molecular Sciences: Lauric acid antimicrobial mechanism',
    ],
    traditionalUses: [
      'Used across coastal East Africa for hair oiling rituals',
      'Combined with aromatic herbs for traditional massage in Tanzania',
      'Used for baby skin care across coastal African communities',
      'Applied as a protective oil before sun exposure along the coast',
    ],
    commonProducts: [
      'Body lotion', 'Hair mask', 'Makeup remover', 'Oil cleanser', 'Lip balm',
    ],
    skinTypes: ['Dry', 'Normal', 'Hair care for all types'],
    concerns: ['Dryness', 'Hair damage', 'Makeup removal'],
    imageUrl: AppImages.forIngredient('coconut_oil'),
  ),
  Ingredient(
    id: 'hibiscus',
    name: 'Hibiscus',
    scientificName: 'Hibiscus sabdariffa',
    origin: 'Tropical & North Africa',
    country: 'Sudan · Egypt · Senegal · Nigeria',
    emoji: '🌺',
    gradientColors: AppColors.hibiscusGrad,
    description:
        'Known as "Zobo" in Nigeria and "Bissap" in Senegal, Hibiscus is enjoyed as a beloved drink and used as a beauty treatment across Africa. Its natural AHAs (alpha hydroxy acids) gently exfoliate, while its anthocyanins deliver powerful anti-aging antioxidant protection.',
    benefits: [
      'Natural AHAs: gentle chemical exfoliation for smoother skin',
      'Anthocyanins: powerful antioxidant and anti-aging',
      'Vitamin C: brightens complexion and fades dark spots',
      'Minimises and tightens enlarged pores',
      'Boosts skin elasticity — natural "Botox plant"',
      'Reduces hyperpigmentation and uneven skin tone',
    ],
    evidenceLinks: [
      'Molecules Journal: Hibiscus sabdariffa antioxidant compounds',
      'Food Chemistry: Anthocyanin content and skin benefits',
    ],
    traditionalUses: [
      'Used as face wash and toner in Sudanese beauty routines',
      'Petals soaked in water used as skin-brightening rinse in Egypt',
      'Combined with shea butter for anti-aging masks in West Africa',
      'Zobo water applied to skin as a natural toner across Nigeria',
    ],
    commonProducts: [
      'Toner', 'Exfoliating serum', 'Face wash', 'Brightening mask', 'Facial mist',
    ],
    skinTypes: ['All skin types', 'Oily', 'Combination', 'Mature'],
    concerns: ['Hyperpigmentation', 'Large pores', 'Dullness', 'Anti-aging', 'Acne'],
    imageUrl: AppImages.forIngredient('hibiscus'),
  ),
  Ingredient(
    id: 'argan_oil',
    name: 'Argan Oil',
    scientificName: 'Argania spinosa',
    origin: 'Morocco',
    country: 'Morocco (Exclusive)',
    emoji: '🫒',
    gradientColors: AppColors.arganGrad,
    description:
        'Produced exclusively from the rare argan tree found only in Morocco, Argan Oil is known as "Liquid Gold." Berber women have used it for centuries for skin, hair, and nails. Its extraordinary balance of unsaturated fatty acids and vitamin E makes it one of the world\'s most coveted skincare oils.',
    benefits: [
      '80% unsaturated fatty acids — exceptional skin penetration',
      'Vitamin E tocopherols: powerful antioxidant protection',
      'Balances sebum — effective for both dry and oily skin',
      'Reduces appearance of fine lines and wrinkles',
      'Polyphenols: deep anti-aging and brightening',
      'Repairs split ends and restores hair shine',
    ],
    evidenceLinks: [
      'Clinical, Cosmetic and Investigational Dermatology: Argan oil anti-aging study',
      'International Journal of Cosmetic Science: Tocopherol content analysis',
    ],
    traditionalUses: [
      'Berber women of Morocco have used Argan Oil for beauty for 3,500 years',
      'Applied to hair before braiding as a protective and conditioning treatment',
      'Used as a skin and nail conditioner during Moroccan beauty rituals (hammam)',
      'Added to traditional cosmetics like "amlou" (almond-argan paste)',
    ],
    commonProducts: [
      'Hair serum', 'Facial oil', 'Night cream', 'Nail treatment', 'Body oil',
    ],
    skinTypes: ['All skin types', 'Dry', 'Mature', 'Combination'],
    concerns: ['Anti-aging', 'Dryness', 'Hair damage', 'Dullness'],
    imageUrl: AppImages.forIngredient('argan_oil'),
  ),
  Ingredient(
    id: 'marula',
    name: 'Marula Oil',
    scientificName: 'Sclerocarya birrea',
    origin: 'Southern Africa',
    country: 'South Africa · Botswana · Namibia · Zimbabwe',
    emoji: '🫧',
    gradientColors: AppColors.marulaGrad,
    description:
        'Marula Oil comes from the fruit of the Marula tree, sacred to the San people of Southern Africa. Its exceptional oleic acid content (70%) gives it a fast-absorbing, non-greasy texture that deeply nourishes while being suitable for all skin types.',
    benefits: [
      'Oleic acid (70%): fast-absorbing, non-greasy deep hydration',
      'Vitamin C content 8× higher than oranges',
      'Powerful anti-aging — firms and lifts skin',
      'Exceptional antioxidant protection',
      'Absorbs rapidly without blocking pores',
      'Anti-inflammatory and antibacterial',
    ],
    evidenceLinks: [
      'South African Journal of Botany: Marula oil fatty acid composition',
      'Industrial Crops and Products: Bioactive compounds in Marula',
    ],
    traditionalUses: [
      'The San people have used Marula oil for skin and hair for thousands of years',
      'Applied to dry, cracked skin during Southern African dry season',
      'Used to preserve and soften leather and protect skin from harsh sun',
      'Fruit eaten and applied topically for nourishment in rural communities',
    ],
    commonProducts: [
      'Face oil', 'Body oil', 'Hair oil', 'Anti-aging serum', 'Lip treatment',
    ],
    skinTypes: ['All skin types', 'Mature', 'Dry', 'Normal'],
    concerns: ['Anti-aging', 'Dryness', 'Dullness', 'Fine lines'],
    imageUrl: AppImages.forIngredient('marula'),
  ),
  Ingredient(
    id: 'african_black_soap',
    name: 'African Black Soap',
    scientificName: 'Anago Soap / Ose Dudu',
    origin: 'West Africa',
    country: 'Ghana · Nigeria · Benin',
    emoji: '🧼',
    gradientColors: AppColors.blackSoapGrad,
    description:
        'African Black Soap (Ose Dudu in Yoruba, Alata Samina in Twi) is a traditional West African cleanser made from plantain ash, shea butter, and palm kernel oil. Handcrafted using methods passed down through generations of Ghanaian and Nigerian women, it is the ultimate solution for acne, hyperpigmentation, and deep cleansing of melanin-rich skin.',
    benefits: [
      'Deep cleanses without stripping natural oils',
      'Treats acne and reduces breakouts effectively',
      'Fades hyperpigmentation and dark spots',
      'Relieves eczema, psoriasis, and rosacea',
      'Plantain ash: natural exfoliant and brightener',
      'Vitamins A and E from shea butter nourish skin',
    ],
    evidenceLinks: [
      'Journal of Cosmetic Dermatology: African Black Soap antibacterial properties',
      'African Journal of Traditional Medicine: Plantain ash skincare analysis',
    ],
    traditionalUses: [
      'Traditional recipe from Yoruba women in Nigeria used for centuries',
      'Ghanaian market women have sold handmade black soap for generations',
      'Used as a full-body wash and face wash in West African households',
      'Applied as a spot treatment for skin diseases in traditional medicine',
    ],
    commonProducts: [
      'Face wash', 'Body wash', 'Spot treatment', 'Shampoo bar', 'Body scrub',
    ],
    skinTypes: ['Oily', 'Acne-prone', 'Combination'],
    concerns: ['Acne', 'Hyperpigmentation', 'Eczema', 'Oiliness', 'Body acne'],
    imageUrl: AppImages.forIngredient('african_black_soap'),
  ),
  Ingredient(
    id: 'rooibos',
    name: 'Rooibos',
    scientificName: 'Aspalathus linearis',
    origin: 'South Africa',
    country: 'South Africa (Cederberg Region — Exclusive)',
    emoji: '🍂',
    gradientColors: AppColors.rooibosGrad,
    description:
        'Rooibos (meaning "Red Bush") grows exclusively in the Cederberg Mountains of South Africa. Its unique antioxidant, aspalathin — found nowhere else on earth — gives Rooibos exceptional anti-inflammatory and anti-aging properties, making it a breakthrough ingredient for sensitive skin.',
    benefits: [
      'Aspalathin: unique antioxidant found only in Rooibos',
      'Exceptional anti-inflammatory — calms all skin conditions',
      'Zinc content regulates sebum and fights acne',
      'Natural AHAs: gentle exfoliation for brighter skin',
      'Soothes sensitive skin, eczema, and rosacea',
      'Anti-aging — reduces appearance of fine lines',
    ],
    evidenceLinks: [
      'South African Journal of Botany: Aspalathin antioxidant activity',
      'Phytochemistry: Unique polyphenol profile of Aspalathus linearis',
    ],
    traditionalUses: [
      'Indigenous Khoisan people have used Rooibos medicinally for centuries',
      'Applied as a poultice for skin conditions by South African healers',
      'Used as a face wash and toner by Cape Malay and Afrikaner women',
      'Cooled Rooibos tea used as a soothing bath for babies with skin rashes',
    ],
    commonProducts: [
      'Toner', 'Eye cream', 'Facial mist', 'Serum', 'Sensitive skin moisturiser',
    ],
    skinTypes: ['Sensitive', 'All skin types', 'Mature', 'Rosacea-prone'],
    concerns: ['Sensitivity', 'Rosacea', 'Eczema', 'Anti-aging', 'Dullness'],
    imageUrl: AppImages.forIngredient('rooibos'),
  ),
  Ingredient(
    id: 'neem',
    name: 'Neem',
    scientificName: 'Azadirachta indica',
    origin: 'East Africa',
    country: 'Uganda · Kenya · Tanzania · Ethiopia',
    emoji: '🌱',
    gradientColors: AppColors.neemGrad,
    description:
        'Known as the "Village Pharmacy" across East Africa and Asia, the Neem tree is revered for its extraordinary medicinal properties. Its oil and leaf extracts contain nimbidin and nimbin — compounds with proven antibacterial, antifungal, and anti-inflammatory effects that make it exceptionally effective for acne and problem skin.',
    benefits: [
      'Nimbidin: clinically proven antibacterial against acne bacteria',
      'Nimbin: powerful antifungal for skin infections',
      'Reduces acne severity and prevents new breakouts',
      'Fades post-acne scars and hyperpigmentation',
      'Anti-inflammatory — reduces pimple swelling fast',
      'Antioxidant protection against environmental damage',
    ],
    evidenceLinks: [
      'Asian Pacific Journal of Tropical Biomedicine: Neem antibacterial profile',
      'Journal of Ethnopharmacology: Neem in traditional African medicine',
    ],
    traditionalUses: [
      'Called "Muarubaini" in Swahili (cure for 40 diseases) in East Africa',
      'Neem twigs used as natural toothbrushes and skin cleansers across Africa',
      'Leaves boiled and used as face steam for acne in Uganda and Kenya',
      'Bark and leaf paste applied for skin diseases in traditional healing',
    ],
    commonProducts: [
      'Acne cleanser', 'Toner', 'Spot treatment', 'Body wash', 'Face mask',
    ],
    skinTypes: ['Oily', 'Acne-prone', 'Combination'],
    concerns: ['Acne', 'Body acne', 'Fungal infections', 'Oiliness', 'Scarring'],
    imageUrl: AppImages.forIngredient('neem'),
  ),
];

final List<String> ingredientCategories = [
  'All',
  'Moisturising',
  'Brightening',
  'Anti-Acne',
  'Anti-Aging',
  'Soothing',
];

List<Ingredient> filterIngredients(String category, String query) {
  var result = allIngredients;

  if (query.isNotEmpty) {
    final q = query.toLowerCase();
    result = result
        .where((i) =>
            i.name.toLowerCase().contains(q) ||
            i.origin.toLowerCase().contains(q) ||
            i.benefits.any((b) => b.toLowerCase().contains(q)) ||
            i.concerns.any((c) => c.toLowerCase().contains(q)))
        .toList();
  }

  if (category == 'All') return result;

  final Map<String, List<String>> categoryMap = {
    'Moisturising': ['Dryness', 'Dry', 'Eczema'],
    'Brightening': ['Hyperpigmentation', 'Dullness', 'Dark spots'],
    'Anti-Acne': ['Acne', 'Oiliness', 'Body acne'],
    'Anti-Aging': ['Anti-aging', 'Fine lines', 'Loss of elasticity'],
    'Soothing': ['Sensitivity', 'Irritation', 'Rosacea', 'Inflammation'],
  };

  final keywords = categoryMap[category] ?? [];
  return result
      .where((i) => i.concerns.any(
          (c) => keywords.any((k) => c.toLowerCase().contains(k.toLowerCase()))))
      .toList();
}
