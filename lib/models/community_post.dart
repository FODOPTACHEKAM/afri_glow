class CommunityPost {
  final String id;
  final String authorName;
  final String authorLocation;
  final String avatarEmoji;
  final String content;
  final int likes;
  final int comments;
  final DateTime postedAt;
  final List<String> tags;
  final bool isExpert;
  bool isLiked;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorLocation,
    required this.avatarEmoji,
    required this.content,
    required this.likes,
    required this.comments,
    required this.postedAt,
    required this.tags,
    required this.isExpert,
    this.isLiked = false,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(postedAt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}
