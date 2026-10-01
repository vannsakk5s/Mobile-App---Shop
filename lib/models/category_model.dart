import '../config/app_config.dart';

class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? imageUrl;
  final bool isActive;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.imageUrl,
    this.isActive = true,
  });

  String get displayImage {
    if (imageUrl == null || imageUrl!.trim().isEmpty) return '';
    if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
      return imageUrl!;
    }
    final clean = imageUrl!.startsWith('/') ? imageUrl! : '/$imageUrl';
    return '${AppConfig.baseUrl}$clean';
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'image_url': imageUrl,
      'is_active': isActive,
    };
  }
}
