import '../config/app_config.dart';
import 'category_model.dart';

class Product {
  final int id;
  final String name;
  final String slug;
  final int categoryId;
  final String price;
  final int stock;
  final String image;
  final String? description;
  final String type;
  final String size;
  final bool isActive;
  final CategoryModel? category;

  const Product({
    this.id = 0,
    required this.name,
    this.slug = '',
    this.categoryId = 0,
    required this.price,
    this.stock = 0,
    required this.image,
    this.description,
    this.type = 'Product',
    this.size = 'Standard',
    this.isActive = true,
    this.category,
  });

  /// Formats price with dollar sign if needed (e.g. "99.99" -> "$99.99")
  String get formattedPrice {
    if (price.startsWith('\$')) return price;
    final parsed = double.tryParse(price);
    if (parsed != null) {
      return '\$${parsed.toStringAsFixed(2)}';
    }
    return '\$$price';
  }

  /// Display category name
  String get displayType => category?.name ?? (type.isNotEmpty ? type : 'General');

  /// Safe image URL that converts relative /uploads/... to absolute URL using AppConfig.baseUrl
  String get displayImage {
    if (image.trim().isEmpty) return '';
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }
    final clean = image.startsWith('/') ? image : '/$image';
    return '${AppConfig.baseUrl}$clean';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    CategoryModel? cat;
    if (json['category'] != null && json['category'] is Map<String, dynamic>) {
      cat = CategoryModel.fromJson(json['category'] as Map<String, dynamic>);
    }

    final priceRaw = json['price'];
    final priceStr = priceRaw != null ? priceRaw.toString() : '0.00';

    return Product(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      categoryId: json['category_id'] is int ? json['category_id'] as int : 0,
      price: priceStr,
      stock: json['stock'] is int ? json['stock'] as int : int.tryParse('${json['stock']}') ?? 0,
      image: json['image_url'] as String? ?? '',
      description: json['description'] as String?,
      type: cat?.name ?? '',
      size: 'Standard',
      isActive: json['is_active'] as bool? ?? true,
      category: cat,
    );
  }

  factory Product.fromMap(Map<String, String> map) {
    return Product(
      id: int.tryParse(map['id'] ?? '0') ?? 0,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      size: map['size'] ?? 'Standard',
      price: map['price'] ?? '0.00',
      image: map['image'] ?? '',
      description: map['description'],
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id.toString(),
      'name': name,
      'type': displayType,
      'size': size,
      'price': formattedPrice,
      'image': displayImage,
      'description': description ?? '',
    };
  }
}

class PaginatedProductsResponse {
  final List<Product> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  const PaginatedProductsResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginatedProductsResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List<dynamic>?)
            ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return PaginatedProductsResponse(
      items: list,
      total: json['total'] is int ? json['total'] as int : list.length,
      page: json['page'] is int ? json['page'] as int : 1,
      pageSize: json['page_size'] is int ? json['page_size'] as int : 10,
      totalPages: json['total_pages'] is int ? json['total_pages'] as int : 1,
    );
  }
}
