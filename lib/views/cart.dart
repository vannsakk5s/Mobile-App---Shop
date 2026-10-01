import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> cartProducts = [
      {
        'name': 'Nike Air Max',
        'type': 'Shoes',
        'price': '\$89.99',
        'qty': '1',
        'image':
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      },
      {
        'name': 'Wireless Headphone',
        'type': 'Electronics',
        'price': '\$45.00',
        'qty': '2',
        'image':
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
      },
      {
        'name': 'Smart Watch',
        'type': 'Accessories',
        'price': '\$75.99',
        'qty': '1',
        'image':
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
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
              'My Card',
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
                Icons.favorite_border,
                size: 25,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ================= ITEMS COUNT =================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cart Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    '${cartProducts.length} Items',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // ================= CART PRODUCTS =================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                itemCount: cartProducts.length,

                itemBuilder: (context, index) {
                  final product = cartProducts[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        // ================= IMAGE =================
                        Container(
                          width: 95,
                          height: 95,

                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.network(
                              product['image']!,
                              fit: BoxFit.contain,

                              errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
                                return const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // ================= INFORMATION =================
                        Expanded(
                          child: SizedBox(
                            height: 95,

                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [
                                // Name + Delete
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product['name']!,
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,

                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {},

                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.grey.shade500,
                                        size: 21,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  product['type']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),

                                const Spacer(),

                                // ================= PRICE + QUANTITY =================
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text(
                                      product['price']!,

                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // Quantity
                                    Container(
                                      height: 34,

                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),

                                      child: Row(
                                        children: [
                                          // Minus
                                          SizedBox(
                                            width: 32,

                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {},

                                              icon: const Icon(
                                                Icons.remove,
                                                size: 17,
                                              ),
                                            ),
                                          ),

                                          Text(
                                            product['qty']!,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight.w600,
                                            ),
                                          ),

                                          // Plus
                                          SizedBox(
                                            width: 32,

                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {},

                                              icon: const Icon(
                                                Icons.add,
                                                size: 17,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // ================= ORDER SUMMARY =================
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const Text(
                      '\$255.98',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Shipping
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shipping',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const Text(
                      '\$5.00',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(height: 1),
                ),

                // Total
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$260.98',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ================= CHECKOUT BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
