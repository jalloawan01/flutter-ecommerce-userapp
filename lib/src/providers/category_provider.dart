import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = []; 
  List<Category> get categories => _categories;

  Category? _selectedCategory;
  Category? get selectedCategory => _selectedCategory;

  void selectCategory(Category category) {
    for (var c in _categories) {
      c.isSelected = false;
    }
    category.isSelected = true;
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    try {
      final data = await Supabase.instance.client
          .from('categories')
          .select()
          .order('name', ascending: true);
          
      _categories = (data as List).map((json) => Category.fromMap(json)).toList();
      
      if (_categories.isNotEmpty) {
        // Try to find the "All" category from your DB screenshot
        final allIndex = _categories.indexWhere((c) => c.name.toLowerCase() == 'all');
        if (allIndex != -1) {
          _categories[allIndex].isSelected = true;
          _selectedCategory = _categories[allIndex];
        } else {
          _categories.first.isSelected = true;
          _selectedCategory = _categories.first;
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Category fetch error: $e");
    }
  }
}
