import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> data = [
      {
        "name": "Coca Cola",
        "type": "Soft drink",
        "size": "330ml",
        "price": "\$1.00",
        "image":
        "https://walmartsv.vtexassets.com/arquivos/ids/372484/Gaseosa-Coca-Cola-Regular-Lata-354-ml-2-3689.jpg?v=638392773683200000",
      },
      {
        "name": "Pepsi",
        "type": "Soft drink",
        "size": "330ml",
        "price": "\$1.00",
        "image":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5CeoIMm5WBDjvrc2Rotm-NwKSPSr7rLIeo3F8Nb26CQ&s=10",
      },
      {
        "name": "Cambodia Water",
        "type": "Drinking water",
        "size": "500ml",
        "price": "\$0.25",
        "image":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6AogxhrIvEiIqy0f_IcseLsPhCcmHwkljavDDdxO07SBD_SnxNwSfvm4&s=10",
      },
      {
        "name": "Coca Cola",
        "type": "Soft drink",
        "size": "330ml",
        "price": "\$1.00",
        "image":
        "https://walmartsv.vtexassets.com/arquivos/ids/372484/Gaseosa-Coca-Cola-Regular-Lata-354-ml-2-3689.jpg?v=638392773683200000",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        toolbarHeight: 70,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Favorite',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 25,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= TITLE =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Favorite Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  Text(
                    '${data.length} Items',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ================= PRODUCT GRID =================
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                padding: const EdgeInsets.only(
                  top: 4,
                  bottom: 8,
                ),

                itemCount: data.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 products per row
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.64,
                ),

                itemBuilder: (context, index) {
                  final product = data[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detail,
                        arguments: product,
                      );
                    },
                    child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ================= IMAGE =================
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 145,

                              decoration: const BoxDecoration(
                                color: Color(0xFFF8F8F8),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                              ),

                              alignment: Alignment.center,

                              child: Image.network(
                                product['image']!,
                                width: 105,
                                height: 105,
                                fit: BoxFit.contain,

                                errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                    ) {
                                  return const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 50,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),

                            // ================= FAVORITE =================
                            Positioned(
                              top: 10,
                              right: 10,

                              child: Container(
                                width: 34,
                                height: 34,

                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  shape: BoxShape.circle,

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),

                                child: const Icon(
                                  Icons.favorite,
                                  size: 19,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ================= INFORMATION =================
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // Product Name
                                Text(
                                  product['name']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                // Product Type
                                Text(
                                  product['type']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black45,
                                  ),
                                ),

                                const Spacer(),

                                // ================= PRICE + CART =================
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    // Price
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
                                          product['price']!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // ================= CART BUTTON =================
                                    Container(
                                      width: 40,
                                      height: 40,

                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),

                                      child: const Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Colors.white,
                                        size: 21,
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
            ],
          ),
        ),
      ),
      ),
    );
  }
}
