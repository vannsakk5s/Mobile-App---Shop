import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_pro/services/api_service.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = null;
  });

  test('Test Live FastAPI Connection', () async {
    print('--- Testing Live FastAPI Connection ---');
    final categories = await ApiService.getCategories();
    expect(categories.isNotEmpty, true);
    print('Categories count: ${categories.length}');
    for (var cat in categories) {
      print('  Category: id=${cat.id}, name=${cat.name}');
    }

    final productResp = await ApiService.getProducts();
    expect(productResp.items.isNotEmpty, true);
    print('Products total: ${productResp.total}');
    for (var prod in productResp.items) {
      print('  Product: id=${prod.id}, name=${prod.name}, price=${prod.formattedPrice}');
    }

    final banners = await ApiService.getBanners();
    print('Banners count: ${banners.length}');
    print('SUCCESS: All endpoints connected to FastAPI backend!');
  });
}
