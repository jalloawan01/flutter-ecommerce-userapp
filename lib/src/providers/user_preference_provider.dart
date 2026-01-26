import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesProvider with ChangeNotifier {
  static const String _themeKey = 'isDarkTheme';

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  UserPreferencesProvider() {
    _loadPreferences();
  }

  /// Toggle theme and save preference
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _savePreferences();
    notifyListeners();
  }

  /// Load theme preference from SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }

  /// Save theme preference to SharedPreferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkTheme);
  }
}
