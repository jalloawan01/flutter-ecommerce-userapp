import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/src/pages/auth/login_page.dart';
import 'package:flutter_ecommerce_app/src/pages/auth/signup_page.dart';
import 'package:flutter_ecommerce_app/src/pages/product_detail_page.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/login': (_) => const LoginPage(),
      '/signup': (_) => const SignUpPage(),
      '/detail': (_) => const ProductDetailPage(),
    };
  }
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') return child;
    return FadeTransition(opacity: animation, child: child);
  }
}