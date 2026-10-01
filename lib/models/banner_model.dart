import '../config/app_config.dart';

class BannerModel {
  final int id;
  final String title;
  final String imageUrl;
  final String? linkUrl;
  final int sortOrder;
  final bool isActive;

  const BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.linkUrl,
    this.sortOrder = 0,
    this.isActive = true,
  });

  String get displayImage {
    if (imageUrl.trim().isEmpty) return '';
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    final clean = imageUrl.startsWith('/') ? imageUrl : '/$imageUrl';
    return '${AppConfig.baseUrl}$clean';
  }

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      title: json['title'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      linkUrl: json['link_url'] as String?,
      sortOrder: json['sort_order'] is int ? json['sort_order'] as int : 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'link_url': linkUrl,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }
}
