import 'package:flutter/material.dart';
import '../views/auth/login_page.dart';
import '../views/auth/register_page.dart';
import '../views/cart.dart';
import '../views/category.dart';
import '../views/detail.dart';
import '../views/favorite.dart';
import '../views/home.dart';
import '../views/main_page.dart';
import '../views/profile.dart';
import '../views/splash.dart';

class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';
  static const String home = '/home';
  static const String category = '/category';
  static const String cart = '/cart';
  static const String favorite = '/favorite';
  static const String profile = '/profile';
  static const String detail = '/detail';
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashPage(),
    main: (context) => const MainPage(),
    home: (context) => const HomePage(),
    category: (context) => const CategoryPage(),
    cart: (context) => const CartPage(),
    favorite: (context) => const FavoritePage(),
    profile: (context) => const ProfilePage(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    detail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, String>) {
        return DetailPage(product: args);
      }
      return const DetailPage();
    },
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == detail) {
      final args = settings.arguments;
      final product = (args is Map<String, String>) ? args : <String, String>{};
      return MaterialPageRoute(
        builder: (context) => DetailPage(product: product),
        settings: settings,
      );
    }
    return null;
  }
}
