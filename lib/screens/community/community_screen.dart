import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../data/community_data.dart';
import '../../models/community_post.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<CommunityPost> _posts = communityPosts;
  String _tag = 'All';

  List<CommunityPost> get _filtered {
    if (_tag == 'All') return _posts;
    return _posts.where((p) => p.tags.contains(_tag)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Create post — coming soon!',
                    style: GoogleFonts.poppins()),
                backgroundColor: AppColors.deepGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Challenge banner
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.deepGreen, AppColors.medGreen],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('30-Day Glow Challenge',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15)),
                      Text('2,156 members joined · Day 12',
                          style: GoogleFonts.poppins(
                              color: Colors.white.withAlpha(200),
                              fontSize: 12)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Join'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tag filter
          SizedBox(
            height: 38,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: communityTags.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final t = communityTags[i];
                final selected = t == _tag;
                return GestureDetector(
                  onTap: () => setState(() => _tag = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.deepGreen
                          : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.deepGreen
                            : const Color(0xFFE0D8D0),
                      ),
                    ),
                    child: Text(t,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? Colors.white
                                : AppColors.warmBrown)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Posts
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) =>
                  _PostCard(post: _filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final CommunityPost post;
  const _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late bool _liked;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _liked = widget.post.isLiked;
    _likes = widget.post.likes;
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E0D8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.deepGreen.withAlpha(15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(post.avatarEmoji,
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(post.authorName,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        if (post.isExpert) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withAlpha(25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('Expert',
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ],
                    ),
                    Text('${post.authorLocation} · ${post.timeAgo}',
                        style: GoogleFonts.poppins(
                            color: AppColors.warmBrown,
                            fontSize: 11)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz,
                    color: AppColors.warmBrown),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Content
          Text(post.content,
              style: GoogleFonts.poppins(fontSize: 14, height: 1.6)),
          const SizedBox(height: 10),

          // Tags
          Wrap(
            spacing: 6,
            children: post.tags.map((t) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.deepGreen.withAlpha(12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('#$t',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.deepGreen,
                        fontWeight: FontWeight.w600)),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _liked = !_liked;
                    _likes += _liked ? 1 : -1;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      _liked ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: _liked
                          ? AppColors.errorRed
                          : AppColors.warmBrown,
                    ),
                    const SizedBox(width: 4),
                    Text('$_likes',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.warmBrown,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Icon(Icons.chat_bubble_outline,
                      size: 18, color: AppColors.warmBrown),
                  const SizedBox(width: 4),
                  Text('${post.comments}',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.warmBrown,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.share_outlined,
                  size: 18, color: AppColors.warmBrown),
            ],
          ),
        ],
      ),
    );
  }
}
