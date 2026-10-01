import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentBanner = 0;
  bool isLoading = true;
  String? errorMessage;

  List<BannerModel> apiBanners = [];
  List<CategoryModel> categories = [];
  List<Product> products = [];
  int? selectedCategoryId; // null = all

  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  final List<String> fallbackBanners = [

  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        ApiService.getBanners().catchError((_) => <BannerModel>[]),
        ApiService.getCategories().catchError((_) => <CategoryModel>[]),
        ApiService.getProducts(
          categoryId: selectedCategoryId,
          search: searchController.text.trim().isNotEmpty ? searchController.text.trim() : null,
        ),
      ]);

      if (!mounted) return;

      setState(() {
        apiBanners = results[0] as List<BannerModel>;
        categories = results[1] as List<CategoryModel>;
        final prodResp = results[2] as PaginatedProductsResponse;
        products = prodResp.items;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Could not connect to API server (${AppConfig.baseUrl}):\n$e';
      });
    }
  }

  Future<void> _filterByCategory(int? categoryId) async {
    setState(() {
      selectedCategoryId = categoryId;
      isLoading = true;
    });

    try {
      final prodResp = await ApiService.getProducts(
        categoryId: selectedCategoryId,
        search: searchController.text.trim().isNotEmpty ? searchController.text.trim() : null,
      );
      if (!mounted) return;
      setState(() {
        products = prodResp.items;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load products for this category';
      });
    }
  }

  Future<void> _onSearchSubmit(String query) async {
    setState(() {
      isLoading = true;
    });
    try {
      final prodResp = await ApiService.getProducts(
        categoryId: selectedCategoryId,
        search: query.trim().isNotEmpty ? query.trim() : null,
      );
      if (!mounted) return;
      setState(() {
        products = prodResp.items;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int bannerCount = apiBanners.isNotEmpty ? apiBanners.length : fallbackBanners.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        toolbarHeight: 70,
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search products in API...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _onSearchSubmit,
              )
            : ValueListenableBuilder<UserModel?>(
                valueListenable: AuthService.instance.userNotifier,
                builder: (context, user, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user != null ? 'Welcome back,' : 'Hello,',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        user?.name ?? 'Guest User',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
        actions: [
          Container(
            width: 42,
            height: 42,
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (isSearching) {
                    isSearching = false;
                    searchController.clear();
                    _loadData();
                  } else {
                    isSearching = true;
                  }
                });
              },
              icon: Icon(
                isSearching ? Icons.close : Icons.search,
                size: 22,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: Colors.red,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= BANNER =================
                  SizedBox(
                    height: 170,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView.builder(
                          itemCount: bannerCount,
                          onPageChanged: (index) {
                            setState(() {
                              currentBanner = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            if (apiBanners.isNotEmpty) {
                              final banner = apiBanners[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  banner.displayImage,
                                  width: double.infinity,
                                  height: 170,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildBannerPlaceholder(banner.title);
                                  },
                                ),
                              );
                            }

                            // Fallback local asset banner
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                fallbackBanners[index],
                                width: double.infinity,
                                height: 170,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildBannerPlaceholder('Special Offer');
                                },
                              ),
                            );
                          },
                        ),

                        // Dots
                        Positioned(
                          bottom: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              bannerCount,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: currentBanner == index ? 18 : 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: currentBanner == index
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= CATEGORIES HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.category);
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ================= CATEGORY PILLS =================
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // "All" Pill
                        _buildCategoryPill(
                          id: null,
                          title: 'All',
                          isSelected: selectedCategoryId == null,
                        ),
                        // Dynamic categories from API
                        ...categories.map(
                          (cat) => _buildCategoryPill(
                            id: cat.id,
                            title: cat.name,
                            isSelected: selectedCategoryId == cat.id,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ================= PRODUCTS HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedCategoryId == null
                            ? 'Popular Products'
                            : 'Products (${categories.firstWhere((c) => c.id == selectedCategoryId, orElse: () => CategoryModel(id: 0, name: 'Filtered', slug: '')).name})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${products.length} items',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ================= PRODUCTS CONTENT =================
                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                    )
                  else if (errorMessage != null)
                    _buildErrorView()
                  else if (products.isEmpty)
                    _buildEmptyView()
                  else
                    _buildProductsHorizontalList(products),

                  const SizedBox(height: 24),

                  // ================= ALL / NEW PRODUCTS =================
                  if (!isLoading && errorMessage == null && products.isNotEmpty) ...[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New Arrivals',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Latest',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildProductsHorizontalList(products.reversed.toList()),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPill({
    required int? id,
    required String title,
    required bool isSelected,
    }) {
    return GestureDetector(
      onTap: () => _filterByCategory(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.red.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildProductsHorizontalList(List<Product> list) {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 4, bottom: 8, left: 2),
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final product = list[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.detail,
                arguments: product.toMap(),
              );
            },
            child: Container(
              width: 175,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          color: const Color(0xFFF8F8F8),
                          alignment: Alignment.center,
                          child: product.displayImage.isNotEmpty
                              ? Image.network(
                                  product.displayImage,
                                  width: double.infinity,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.inventory_2_outlined,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.inventory_2_outlined,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Information
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.displayType,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Price',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black38,
                                    ),
                                  ),
                                  Text(
                                    product.formattedPrice,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerPlaceholder(String title) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFFF7043)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'NEW SEASON',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Explore top tech and catalog items',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 54, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'No products found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Text(
            'Try selecting another category or clear search.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(
            errorMessage ?? 'Connection error',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry Connection'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
