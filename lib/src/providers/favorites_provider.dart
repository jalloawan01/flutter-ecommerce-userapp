import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Product> _favoriteItems = [];
  List<Product> get favoriteItems => _favoriteItems;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _favoriteItems.map((item) => item.toMap()).toList(),
    );
    await prefs.setString('user_favorites', encodedData);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString('user_favorites');
    
    if (favoritesString != null) {
      final List<dynamic> decodedData = jsonDecode(favoritesString);
      _favoriteItems = decodedData.map((item) => Product.fromMap(item)).toList();
      notifyListeners();
    }
  }

  void toggleFavorite(Product product) {
    final index = _favoriteItems.indexWhere((item) => item.id == product.id);
    
    if (index >= 0) {
      _favoriteItems.removeAt(index);
    } else {
      _favoriteItems.add(product);
    }
    _saveFavorites(); 
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favoriteItems.any((item) => item.id == productId);
  }
}
