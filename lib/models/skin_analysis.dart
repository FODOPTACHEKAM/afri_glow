class SkinAnalysis {
  final double skinScore;
  final Map<String, double> concerns;
  final String skinTone;
  final List<String> recommendations;
  final List<String> suggestedIngredients;
  final DateTime analyzedAt;

  const SkinAnalysis({
    required this.skinScore,
    required this.concerns,
    required this.skinTone,
    required this.recommendations,
    required this.suggestedIngredients,
    required this.analyzedAt,
  });

  String get scoreLabel {
    if (skinScore >= 80) return 'Excellent';
    if (skinScore >= 65) return 'Good';
    if (skinScore >= 50) return 'Fair';
    return 'Needs Care';
  }
}
