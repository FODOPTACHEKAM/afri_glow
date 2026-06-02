class Product {
  final String id;
  final String name;
  final String brand;
  final String description;
  final List<String> keyIngredients;
  final List<String> skinTypes;
  final double price;
  final String currency;
  final double rating;
  final int reviewCount;
  final String category;
  final String origin;
  final String emoji;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.keyIngredients,
    required this.skinTypes,
    required this.price,
    required this.currency,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.origin,
    required this.emoji,
    this.isFavorite = false,
  });

  String get formattedPrice => '$currency ${price.toStringAsFixed(0)}';
}
