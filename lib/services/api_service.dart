import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiService {
  static const Duration timeoutDuration = Duration(seconds: 8);

  // Common headers
  static Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static String _extractErrorMessage(String body, String defaultMsg) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded.containsKey('detail')) {
        final detail = decoded['detail'];
        if (detail is String) return detail;
        if (detail is List) {
          return detail.map((e) {
            if (e is Map && e.containsKey('msg')) {
              return e['msg'].toString();
            }
            return e.toString();
          }).join('\n');
        }
      }
    } catch (_) {}
    return defaultMsg;
  }

  /// Fetch active banners
  static Future<List<BannerModel>> getBanners() async {
    try {
      final uri = Uri.parse(AppConfig.bannersEndpoint);
      developer.log('GET $uri', name: 'ApiService');

      final response = await http.get(uri, headers: _defaultHeaders).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw ApiException('Failed to load banners (${response.statusCode})', response.statusCode);
      }
    } catch (e) {
      developer.log('Error in getBanners: $e', name: 'ApiService');
      rethrow;
    }
  }

  /// Fetch active categories
  static Future<List<CategoryModel>> getCategories() async {
    try {
      final uri = Uri.parse(AppConfig.categoriesEndpoint);
      developer.log('GET $uri', name: 'ApiService');

      final response = await http.get(uri, headers: _defaultHeaders).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw ApiException('Failed to load categories (${response.statusCode})', response.statusCode);
      }
    } catch (e) {
      developer.log('Error in getCategories: $e', name: 'ApiService');
      rethrow;
    }
  }

  /// Fetch products with optional category, search, and pagination
  static Future<PaginatedProductsResponse> getProducts({
    int? categoryId,
    String? search,
    int page = 1,
    int pageSize = 10,
    }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final uri = Uri.parse(AppConfig.productsEndpoint).replace(queryParameters: queryParams);
      developer.log('GET $uri', name: 'ApiService');

      final response = await http.get(uri, headers: _defaultHeaders).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return PaginatedProductsResponse.fromJson(data);
      } else {
        throw ApiException('Failed to load products (${response.statusCode})', response.statusCode);
      }
    } catch (e) {
      developer.log('Error in getProducts: $e', name: 'ApiService');
      rethrow;
    }
  }

  /// Fetch single product detail by ID
  static Future<Product> getProductById(int productId) async {
    try {
      final uri = Uri.parse('${AppConfig.productsEndpoint}/$productId');
      developer.log('GET $uri', name: 'ApiService');

      final response = await http.get(uri, headers: _defaultHeaders).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Product.fromJson(data);
      } else {
        throw ApiException('Failed to load product detail (${response.statusCode})', response.statusCode);
      }
    } catch (e) {
      developer.log('Error in getProductById: $e', name: 'ApiService');
      rethrow;
    }
  }

  /// Authenticate user and receive token
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final uri = Uri.parse(AppConfig.authLoginEndpoint);
      final body = jsonEncode({'email': email, 'password': password});

      final response = await http
          .post(uri, headers: _defaultHeaders, body: body)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final msg = _extractErrorMessage(response.body, 'Login failed (${response.statusCode})');
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      developer.log('Error in login: $e', name: 'ApiService');
      rethrow;
    }
  }

  /// Authenticate user and receive typed AuthResponse
  static Future<AuthResponse> authLogin(String email, String password) async {
    final data = await login(email, password);
    return AuthResponse.fromJson(data);
  }

  /// Register a new account
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final uri = Uri.parse(AppConfig.authRegisterEndpoint);
      final body = jsonEncode({'name': name, 'email': email, 'password': password});

      final response = await http
          .post(uri, headers: _defaultHeaders, body: body)
          .timeout(timeoutDuration);

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final msg = _extractErrorMessage(response.body, 'Registration failed (${response.statusCode})');
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      developer.log('Error in register: $e', name: 'ApiService');
      rethrow;
    }
  }

  /// Register a new account and receive typed UserModel
  static Future<UserModel> authRegister(String name, String email, String password) async {
    final data = await register(name, email, password);
    return UserModel.fromJson(data);
  }

  /// Get current user profile with access token
  static Future<UserModel> getProfile(String accessToken) async {
    try {
      final uri = Uri.parse(AppConfig.authMeEndpoint);
      developer.log('GET $uri', name: 'ApiService');

      final headers = {
        ..._defaultHeaders,
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(uri, headers: headers).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        final msg = _extractErrorMessage(response.body, 'Failed to fetch profile (${response.statusCode})');
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      developer.log('Error in getProfile: $e', name: 'ApiService');
      rethrow;
    }
  }

  /// Refresh token
  static Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final uri = Uri.parse(baseUrlAuthRefresh);
      final body = jsonEncode({'refresh_token': refreshToken});

      final response = await http
          .post(uri, headers: _defaultHeaders, body: body)
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final msg = _extractErrorMessage(response.body, 'Failed to refresh token');
        throw ApiException(msg, response.statusCode);
      }
    } catch (e) {
      developer.log('Error in refreshToken: $e', name: 'ApiService');
      rethrow;
    }
  }

  static String get baseUrlAuthRefresh => '${AppConfig.baseUrl}/api/v1/auth/refresh';
}
