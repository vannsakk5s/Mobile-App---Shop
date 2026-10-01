import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await AuthService.instance.logout();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        toolbarHeight: 70,

        title: const Text(
          'My Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 21,
                ),
              ),
            ),
          ),
        ],

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 5),
              // ================= PROFILE =================
              ValueListenableBuilder<UserModel?>(
                valueListenable: AuthService.instance.userNotifier,
                builder: (context, user, _) {
                  final bool isLoggedIn = user != null;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Profile Image or Avatar
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.red,
                          child: CircleAvatar(
                            radius: 27,
                            backgroundColor: isLoggedIn ? Colors.red.shade100 : Colors.grey.shade200,
                            backgroundImage: isLoggedIn
                                ? const AssetImage('assets/images/profile.jpg')
                                : null,
                            child: !isLoggedIn
                                ? const Icon(Icons.person_outline_rounded, size: 30, color: Colors.grey)
                                : null,
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Name + Email or Guest Prompt
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      isLoggedIn ? user.name : 'Welcome, Guest',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (isLoggedIn) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.red.shade200, width: 0.8),
                                      ),
                                      child: Text(
                                        user.role,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isLoggedIn ? user.email : 'Sign in to access your orders & profile',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Action Icon (Edit if logged in, or Sign In button if guest)
                        if (isLoggedIn)
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.edit_outlined,
                              color: Colors.red,
                              size: 19,
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.login);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 5),

              // ================= ORDER STATUS =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 12,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      // Pending
                      Column(
                        children: [
                          Container(
                            width: 45,
                            height: 45,

                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.orange,
                            ),
                          ),

                          const SizedBox(height: 7),

                          const Text(
                            'Pending',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Shipping
                      Column(
                        children: [
                          Container(
                            width: 45,
                            height: 45,

                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.blue,
                            ),
                          ),

                          const SizedBox(height: 7),

                          const Text(
                            'Shipping',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Delivered
                      Column(
                        children: [
                          Container(
                            width: 45,
                            height: 45,

                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            ),
                          ),

                          const SizedBox(height: 7),

                          const Text(
                            'Delivered',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Cancelled
                      Column(
                        children: [
                          Container(
                            width: 45,
                            height: 45,

                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                          ),

                          const SizedBox(height: 7),

                          const Text(
                            'Cancelled',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= MENU =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Column(
                    children: [

                      // My Orders
                      ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,

                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.red,
                          ),
                        ),

                        title: const Text(
                          'My Orders',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        subtitle: const Text(
                          'View your order history',
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                      ),

                      const Divider(
                        height: 1,
                        indent: 70,
                      ),

                      // Address
                      ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,

                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: const Icon(
                            Icons.location_on_outlined,
                            color: Colors.blue,
                          ),
                        ),

                        title: const Text(
                          'Shipping Address',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        subtitle: const Text(
                          'Manage your addresses',
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                      ),

                      const Divider(
                        height: 1,
                        indent: 70,
                      ),

                      // Payment
                      ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,

                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: const Icon(
                            Icons.credit_card_outlined,
                            color: Colors.purple,
                          ),
                        ),

                        title: const Text(
                          'Payment Method',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        subtitle: const Text(
                          'Manage payment methods',
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                      ),

                      const Divider(
                        height: 1,
                        indent: 70,
                      ),

                      // Favorite
                      ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,

                          decoration: BoxDecoration(
                            color: Colors.pink.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: const Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.pink,
                          ),
                        ),

                        title: const Text(
                          'Favorites',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        subtitle: const Text(
                          'Your favorite products',
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= MORE MENU =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Column(
                    children: [

                      // Help
                      ListTile(
                        leading: const Icon(
                          Icons.help_outline_rounded,
                          color: Colors.black54,
                        ),

                        title: const Text(
                          'Help & Support',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                      ),

                      const Divider(height: 1),

                      // About
                      ListTile(
                        leading: const Icon(
                          Icons.info_outline_rounded,
                          color: Colors.black54,
                        ),

                        title: const Text(
                          'About App',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= LOGOUT / LOGIN =================
              ValueListenableBuilder<UserModel?>(
                valueListenable: AuthService.instance.userNotifier,
                builder: (context, user, _) {
                  final bool isLoggedIn = user != null;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: isLoggedIn
                          ? ElevatedButton.icon(
                              onPressed: () => _showLogoutDialog(context),
                              icon: const Icon(Icons.logout_rounded),
                              label: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.red,
                                backgroundColor: Colors.white,
                                elevation: 0,
                                side: BorderSide(color: Colors.red.shade200),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.login);
                              },
                              icon: const Icon(Icons.login_rounded),
                              label: const Text(
                                'Sign In / Register',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// Backward compatibility alias
typedef AccountPage = ProfilePage;
