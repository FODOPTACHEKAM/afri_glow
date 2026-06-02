class RoutineStep {
  final int stepNumber;
  final String title;
  final String ingredient;
  final String product;
  final String instructions;
  final String duration;
  final String emoji;

  const RoutineStep({
    required this.stepNumber,
    required this.title,
    required this.ingredient,
    required this.product,
    required this.instructions,
    required this.duration,
    required this.emoji,
  });
}

class Routine {
  final String id;
  final String name;
  final String type; // morning | evening | weekly
  final String skinType;
  final String description;
  final List<RoutineStep> steps;

  const Routine({
    required this.id,
    required this.name,
    required this.type,
    required this.skinType,
    required this.description,
    required this.steps,
  });
}
