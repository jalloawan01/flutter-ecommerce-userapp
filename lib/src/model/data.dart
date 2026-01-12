import 'package:flutter_ecommerce_app/src/model/category.dart';
import 'package:flutter_ecommerce_app/src/model/product.dart';

class AppData {
  static List<Product> productList = [
    Product(
      id: '1', // FIXED: Added quotes
      name: 'Nike Air Max 200',
      category: "Trending Now",
      price: 240.00,
      image: 'assets/shoe_tilt_1.png',
      isLiked: false,
      isSelected: true,
    ),
    Product(
      id: '2', // FIXED: Added quotes
      name: 'Nike Air Max 97',
      category: "Trending Now",
      price: 220.00,
      image: 'assets/shoe_tilt_2.png',
      isLiked: false,
    ),
  ];

  static List<Product> cartList = [
    Product(
      id: '1', // FIXED: Added quotes
      name: 'Nike Air Max 200',
      category: "Trending Now",
      price: 240.00,
      image: 'assets/small_tilt_shoe_1.png',
      isLiked: false,
      isSelected: true,
    ),
    Product(
      id: '2', // FIXED: Added quotes
      name: 'Nike Air Max 97',
      category: "Trending Now",
      price: 190.00,
      image: 'assets/small_tilt_shoe_2.png',
      isLiked: false,
    ),
    Product(
      id: '3', // FIXED: Added quotes
      name: 'Nike Air Max 92607',
      category: "Trending Now",
      price: 220.00,
      image: 'assets/small_tilt_shoe_3.png',
      isLiked: false,
    ),
    Product(
      id: '4', // FIXED: Added quotes
      name: 'Nike Air Max 200',
      category: "Trending Now",
      price: 240.00,
      image: 'assets/small_tilt_shoe_1.png',
      isLiked: false,
      isSelected: true,
    ),
  ];

  static List<Category> categoryList = [
    Category(id: '0', name: "All", image: 'assets/shoe_thumb_1.png'), // FIXED: Added quotes
    Category(
      id: '1', // FIXED: Added quotes
      name: "Sneakers",
      image: 'assets/shoe_thumb_2.png',
      isSelected: true,
    ),
    Category(id: '2', name: "Jacket", image: 'assets/jacket.png'), // FIXED: Added quotes
    Category(id: '3', name: "Watch", image: 'assets/watch.png'), // FIXED: Added quotes
    Category(id: '4', name: "Hat", image: 'assets/jacket.png'), // FIXED: Added quotes
  ];

  static List<String> showThumbnailList = [
    "assets/shoe_thumb_5.png",
    "assets/shoe_thumb_1.png",
    "assets/shoe_thumb_4.png",
    "assets/shoe_thumb_3.png",
  ];

  static String description =
      "Clean lines, versatile and timeless - the people shoe returns with the Nike Air Max 90. "
      "Featuring the same iconic Waffle sole, stitched overlays and classic TPU accents you come to love, "
      "it lets you walk among the pantheon of Air. Nothing as fly, nothing as comfortable, nothing as proven.";
}