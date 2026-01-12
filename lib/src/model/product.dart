class Product {
  final String id;
  final String name;
  final String category;
  final String? categoryId;
  final double price;
  final String image;
  final String? description;
  bool isLiked;
  bool isSelected;

  Product({
    required this.id,
    required this.name,
    required this.category,
    this.categoryId,
    required this.price,
    required this.image,
    this.description,
    this.isLiked = false,
    this.isSelected = false,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toString() ?? '', 
      name: map['name'] ?? '',
      category: (map['category'] ?? map['category_name'] ?? '').toString(),
      categoryId: map['category_id']?.toString(),
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      // Standardize to use image_url consistently
      image: map['image_url'] ?? map['image'] ?? '',
      description: map['description'] ?? '',
      isLiked: map['is_liked'] ?? false, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'category_id': categoryId,
      'price': price,
      'image_url': image, // Fixed: key matches fromMap
      'description': description,
      'is_liked': isLiked,
    };
  }
}
