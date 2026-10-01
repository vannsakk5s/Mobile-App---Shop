import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyUserData = 'auth_user_data';

  String? _accessToken;
  String? _refreshToken;
  UserModel? _currentUser;

  final ValueNotifier<UserModel?> userNotifier = ValueNotifier<UserModel?>(null);

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _accessToken != null && _currentUser != null;

  /// Initialize and load saved session
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString(_keyAccessToken);
      _refreshToken = prefs.getString(_keyRefreshToken);

      final userJsonStr = prefs.getString(_keyUserData);
      if (userJsonStr != null && userJsonStr.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userJsonStr);
        _currentUser = UserModel.fromJson(userMap);
        userNotifier.value = _currentUser;
      }

      // Optionally refresh user profile in background if token exists
      if (_accessToken != null) {
        refreshUserProfile().catchError((_) => null);
      }
    } catch (e) {
      debugPrint('AuthService init error: $e');
    }
  }

  /// Authenticate with email & password and store session
  Future<AuthResponse> login(String email, String password) async {
    final response = await ApiService.authLogin(email, password);

    _accessToken = response.accessToken;
    _refreshToken = response.refreshToken;
    _currentUser = response.user;
    userNotifier.value = _currentUser;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, response.accessToken);
    await prefs.setString(_keyRefreshToken, response.refreshToken);
    await prefs.setString(_keyUserData, jsonEncode(response.user.toJson()));

    return response;
  }

  /// Register a new account
  Future<UserModel> register(String name, String email, String password) async {
    return await ApiService.authRegister(name, email, password);
  }

  /// Refresh user profile from backend
  Future<UserModel?> refreshUserProfile() async {
    if (_accessToken == null) return null;
    try {
      final user = await ApiService.getProfile(_accessToken!);
      _currentUser = user;
      userNotifier.value = user;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserData, jsonEncode(user.toJson()));
      return user;
    } catch (e) {
      debugPrint('Error refreshing user profile: $e');
      return null;
    }
  }

  /// Logout and clear stored session
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _currentUser = null;
    userNotifier.value = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserData);
  }
}
