import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/model/models.dart';
import 'package:flutter_ecommerce_app/src/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _items = [];
  List<Product> get cartItems => _items;
  bool get isEmpty => _items.isEmpty;
  final _supabase = Supabase.instance.client;

  CartProvider() {
    _loadCart();
  }

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  // --- LOCAL STORAGE ---
  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_items.map((item) => item.toMap()).toList());
    await prefs.setString('cart_data', encodedData);
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartString = prefs.getString('cart_data');
    
    if (cartString != null) {
      try {
        final List<dynamic> decodedData = jsonDecode(cartString);
        _items = decodedData.map((item) => Product.fromMap(item)).toList();
        notifyListeners();
      } catch (e) {
        debugPrint("Local Load Error: $e");
      }
    }
    _syncFromSupabase();
  }

  // --- SUPABASE SYNC ---
  Future<void> _syncFromSupabase() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // The fix: select() returns PostgrestList, which is never null
      final data = await _supabase.from('cart').select().eq('user_id', user.id);

      // Avoid wiping local cache when remote table is empty
      if (data.isNotEmpty) {
        _items = data.map((item) => Product(
          id: item['product_id']?.toString() ?? '',
          name: item['name'] ?? "Product",
          price: (item['price'] as num?)?.toDouble() ?? 0,
          image: item['image'] ?? "", 
          category: item['category']?.toString() ?? '',
          isSelected: false,
        )).toList();

        await _saveLocal();
        notifyListeners();
      }
    } catch (e) {
      AppErrorHandler.handle(e);
    }
  }

  // --- ACTIONS ---
  Future<void> addToCart(Product product) async {
    if (!_items.any((item) => item.id == product.id)) {
      _items.add(product);
      notifyListeners();
      await _saveLocal();

      final user = _supabase.auth.currentUser;
      if (user != null) {
        try {
          final productIdInt = int.tryParse(product.id);
          if (productIdInt == null) {
            debugPrint("Cart sync skipped: product_id '${product.id}' is non-numeric; stored locally only.");
            return;
          }
          await _supabase.from('cart').upsert({
            'user_id': user.id,
            'product_id': productIdInt,
            'name': product.name,
            'price': product.price,
            'image': product.image,
          });
          debugPrint("Added to Supabase");
        } catch (e) {
          AppErrorHandler.handle(e);
        }
      }
    }
  }

  Future<void> removeFromCart(Product product) async {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
    await _saveLocal();

    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        final productIdInt = int.tryParse(product.id);
        if (productIdInt == null) {
          debugPrint("Cart removal skipped in Supabase: product_id '${product.id}' is non-numeric.");
          return;
        }
        await _supabase.from('cart').delete().match({
          'user_id': user.id, 
          'product_id': productIdInt
        });
      } catch (e) {
        AppErrorHandler.handle(e);
      }
    }
  }

  Future<void> checkout(BuildContext context) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('orders').insert({
        'user_id': user.id,
        'total': totalPrice,
        'status': 'Pending',
      });

      _items.clear();
      notifyListeners();
      await _saveLocal();
      await _supabase.from('cart').delete().eq('user_id', user.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order placed successfully!")),
        );
      }
    } catch (e) {
      AppErrorHandler.handle(e, context: context);
    }
  }
}
