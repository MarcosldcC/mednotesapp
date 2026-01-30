class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final int acquiredCount;
  final String category;
  final String? imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.acquiredCount,
    required this.category,
    this.imageUrl,
  });
}
