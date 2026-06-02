import '../models/community_post.dart';

List<CommunityPost> get communityPosts => [
      CommunityPost(
        id: 'c01',
        authorName: 'Dr. Amara Osei',
        authorLocation: 'Accra, Ghana',
        avatarEmoji: '👩‍⚕️',
        content:
            '🧵 THREAD: Why African skin needs African ingredients.\n\nMelanin-rich skin has higher levels of lipids in the dermis, larger oil glands, and unique moisture-retention properties. Western formulas are often designed for lower-melanin skin types. African botanical oils like Baobab, Marula and Shea Butter match the natural lipid profile of African skin PERFECTLY. This is why they work so much better for us. 1/5',
        likes: 1284,
        comments: 89,
        postedAt: DateTime.now().subtract(const Duration(hours: 3)),
        tags: ['Expert', 'Science', 'Education'],
        isExpert: true,
      ),
      CommunityPost(
        id: 'c02',
        authorName: 'Fatima Njoku',
        authorLocation: 'Lagos, Nigeria',
        avatarEmoji: '👩🏾',
        content:
            'Week 8 hyperpigmentation update! 🙌🏾 I switched from a Western bleaching cream to Hibiscus toner + Moringa serum + SPF every single day. The dark spots from my last breakout are 70% lighter. No harsh chemicals. Just African plants doing their thing. Before/after in comments 👇🏾 #NaturalGlow #AfricaHeals',
        likes: 834,
        comments: 156,
        postedAt: DateTime.now().subtract(const Duration(hours: 7)),
        tags: ['Progress', 'Hyperpigmentation', 'Natural'],
        isExpert: false,
      ),
      CommunityPost(
        id: 'c03',
        authorName: 'GlowChallenge',
        authorLocation: 'AfriGlow Community',
        avatarEmoji: '🏆',
        content:
            '🌟 30-DAY AFRICAN HYDRATION CHALLENGE 🌟\n\nJoin thousands of AfriGlow members in our month-long challenge:\n✅ Shea Butter every morning and night\n✅ Aloe Vera toner after cleansing\n✅ 2L water daily\n✅ SPF every single day\n\nPost your Day 1 selfie with #AfriGlowChallenge to join!',
        likes: 2156,
        comments: 478,
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['Challenge', 'Community', 'Glow'],
        isExpert: false,
      ),
      CommunityPost(
        id: 'c04',
        authorName: 'Kemi Adeyemi',
        authorLocation: 'Ibadan, Nigeria',
        avatarEmoji: '👩🏿',
        content:
            'Okay I need to talk about African Black Soap! 🧼 I\'ve been dealing with chest and back acne for YEARS. Tried everything from Benzoyl peroxide to expensive Korean skincare. Started washing with authentic Ghanaian black soap 3 weeks ago and my back is clearing up so fast. Why did nobody tell me about this earlier?! 😭',
        likes: 567,
        comments: 93,
        postedAt: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['Acne', 'Back acne', 'Black Soap'],
        isExpert: false,
      ),
      CommunityPost(
        id: 'c05',
        authorName: 'Dr. Moussa Diallo',
        authorLocation: 'Dakar, Senegal',
        avatarEmoji: '👨🏾‍⚕️',
        content:
            'Dry season skincare reminder for my West African followers! 🌵 The Harmattan is here which means INCREASE your moisturiser. Switch from a lotion to a cream or butter. Layer Baobab serum under your Shea Butter. Add a face oil as your final step. Your skin loses up to 40% more moisture during Harmattan winds. Protect your barrier! 🛡️',
        likes: 921,
        comments: 44,
        postedAt: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['Expert', 'Harmattan', 'Dry Season'],
        isExpert: true,
      ),
      CommunityPost(
        id: 'c06',
        authorName: 'Amina Hassan',
        authorLocation: 'Nairobi, Kenya',
        avatarEmoji: '👩🏾‍🦱',
        content:
            'Sharing my minimalist routine that cleared my acne in 30 days ✨\n\n☀️ AM: Black Soap → Aloe Vera gel → SPF\n🌙 PM: Black Soap → Neem spot treatment → Aloe Vera gel\n\nThat\'s it. Less is more, especially for acne-prone skin. Consistency beats complexity every time! What\'s your minimalist routine?',
        likes: 1432,
        comments: 267,
        postedAt: DateTime.now().subtract(const Duration(days: 3)),
        tags: ['Acne', 'Routine', 'Minimalist'],
        isExpert: false,
      ),
      CommunityPost(
        id: 'c07',
        authorName: 'Ngo Bi Claude',
        authorLocation: 'Yaoundé, Cameroon',
        avatarEmoji: '🧑🏾',
        content:
            'Men\'s skincare is valid! 💪🏾 I used to think skincare was "not for men." Now I have a 3-step routine: wash with Black Soap, moisturise with Shea Butter, SPF. My skin improved dramatically in 6 weeks. Real men protect their skin. Share this with the men in your life!',
        likes: 743,
        comments: 118,
        postedAt: DateTime.now().subtract(const Duration(days: 4)),
        tags: ['Men', 'Skincare', 'Simple Routine'],
        isExpert: false,
      ),
    ];

final List<String> communityTags = [
  'All',
  'Expert',
  'Progress',
  'Challenge',
  'Acne',
  'Hyperpigmentation',
  'Natural',
];
