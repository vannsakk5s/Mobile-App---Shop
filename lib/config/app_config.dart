import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Flutter Learning';
  static const Color primaryColor = Colors.red;
  static const Color backgroundColor = Color(0xFFF7F7F7);

  /// Allows manually overriding IP when testing on physical mobile devices
  /// e.g. 'http://192.168.1.50:8000'
  static String? customBaseUrl;

  /// Automatically picks 10.0.2.2:8000 when running on Android emulator,
  /// and 127.0.0.1:8000 when running on Windows desktop, macOS, Linux, Web, or iOS simulator.
  static String get baseUrl {
    if (customBaseUrl != null && customBaseUrl!.isNotEmpty) {
      return customBaseUrl!;
    }
    if (!kIsWeb) {
      try {
        if (Platform.isAndroid) {
          // Android Emulator host loopback
          return 'http://10.0.2.2:8000';
        }
      } catch (_) {}
    }
    return 'http://127.0.0.1:8000';
  }

  // Endpoints
  static String get bannersEndpoint => '$baseUrl/api/v1/banners';
  static String get categoriesEndpoint => '$baseUrl/api/v1/categories';
  static String get productsEndpoint => '$baseUrl/api/v1/products';
  static String get authLoginEndpoint => '$baseUrl/api/v1/auth/login';
  static String get authRegisterEndpoint => '$baseUrl/api/v1/auth/register';
  static String get authMeEndpoint => '$baseUrl/api/v1/auth/me';
}
