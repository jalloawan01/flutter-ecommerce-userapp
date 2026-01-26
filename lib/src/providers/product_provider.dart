import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/models.dart';
import 'package:flutter_ecommerce_app/src/utils/error_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  // Master list that holds everything from Supabase
  List<Product> _allProducts = []; 
  // List that actually gets shown in the UI
  List<Product> _filteredProducts = [];

  bool _isLoading = false;
  String? _error;
  String _selectedCategoryName = "All";
  String? _selectedCategoryId;

  String get selectedCategoryName => _selectedCategoryName;
  String? get selectedCategoryId => _selectedCategoryId;
  List<Product> get products => _filteredProducts; // UI listens to this
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 1. Handle Category Filtering
  void updateFilter({required String categoryName, String? categoryId}) {
    _selectedCategoryName = categoryName;
    _selectedCategoryId = categoryId;
    _applyFilters(); // Apply filters whenever category changes
    notifyListeners();
  }

  /// 2. Handle Text Search
  void searchProducts(String query) {
    if (query.isEmpty) {
      _applyFilters(); // Reset to category filter if search is cleared
    } else {
      _filteredProducts = _allProducts.where((p) {
        final matchesName = p.name.toLowerCase().contains(query.toLowerCase());
        final selectedName = _selectedCategoryName.trim().toLowerCase();
        final selectedId = _selectedCategoryId?.trim();
        final matchesCategory = selectedName == "all" ||
            p.category.trim().toLowerCase() == selectedName ||
            (selectedId != null && selectedId.isNotEmpty && p.categoryId?.trim() == selectedId);
        return matchesName && matchesCategory;
      }).toList();
    }
    notifyListeners();
  }

  /// Internal Helper to combine logic
  void _applyFilters() {
    final selectedName = _selectedCategoryName.trim().toLowerCase();
    final selectedId = _selectedCategoryId?.trim();

    _filteredProducts = _allProducts.where((p) {
      if (selectedName == "all") return true;
      final productCat = p.category.trim().toLowerCase();
      final productCatId = p.categoryId?.trim();
      final matchById = selectedId != null && selectedId.isNotEmpty && productCatId == selectedId;
      final matchByName = productCat == selectedName;
      return matchById || matchByName;
    }).toList();
  }

  Product? get selectedProduct {
    try {
      return _allProducts.firstWhere((p) => p.isSelected);
    } catch (e) {
      return _allProducts.isNotEmpty ? _allProducts.first : null;
    }
  }

  void selectProduct(Product product) {
    for (var item in _allProducts) {
      item.isSelected = false;
    }
    final index = _allProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _allProducts[index].isSelected = true;
    }
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final List<dynamic> response = await _supabase
          .from('products')
          .select()
          .order('id', ascending: false);

      _allProducts = response.map((item) => Product.fromMap(item)).toList();
      _applyFilters(); // Initial display setup
    } catch (e) {
      _error = AppErrorHandler.handle(e);
      debugPrint("Supabase Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleLike(Product product) {
    product.isLiked = !product.isLiked;
    notifyListeners();
  }
}
