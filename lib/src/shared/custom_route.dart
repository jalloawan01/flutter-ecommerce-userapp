import 'package:flutter/material.dart';

/// A custom page route with fade transition for all routes
/// except the initial route ('/').
class CustomRoute<T> extends MaterialPageRoute<T> {
  /// Constructor for the CustomRoute.
  /// 
  /// [builder] is required to build the page widget.
  CustomRoute({
    required super.builder,
    super.settings, // nullable in constructor is fine
  });

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // ✅ Use settings.name directly, it's non-nullable
    if (settings.name == '/') {
      return child; // No transition for the initial route
    }

    // Fade transition for all other routes
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
