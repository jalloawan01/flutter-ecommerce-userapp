class Category {
  String id;
  String name;
  String image;
  bool isSelected;

  Category({
    required this.id,
    required this.name,
    required this.image,
    this.isSelected = false,
  });

  // ADD THIS FACTORY TO FIX THE ERROR
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'] ?? '',
      // If you don't have images in Supabase yet, use a default asset
      image: map['image_url'] ?? 'assets/shoe_thumb_1.png', 
    );
  }
}