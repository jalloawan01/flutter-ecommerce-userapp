import 'package:flutter_ecommerce_app/src/model/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final _supabase = Supabase.instance.client;

  // --- FETCH ALL PRODUCTS ---
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .order('id', ascending: true);
      
      final List data = response as List;
      return data.map((map) => Product.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // --- FETCH CATEGORIES ---
  // Assuming you have a 'categories' table with 'name' and 'image_url'
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // --- TOGGLE FAVORITE (Update isLiked in DB) ---
  Future<void> toggleLike(int productId, bool currentState) async {
    try {
      await _supabase
          .from('products')
          .update({'is_liked': !currentState})
          .eq('id', productId);
    } catch (e) {
      print('Error updating favorite: $e');
    }
  }
}