import 'package:flutter/material.dart';

class CustomerAccountScreen extends StatefulWidget {
  const CustomerAccountScreen({super.key});

  @override
  State<CustomerAccountScreen> createState() => _CustomerAccountScreenState();
}

class _CustomerAccountScreenState extends State<CustomerAccountScreen> {
  // Mock customer data
  final Map<String, dynamic> customerData = {
    'name': 'Anita Patel',
    'email': 'anita.patel@email.com',
    'phone': '+91 98765 12345',
    'location': 'Mumbai, Maharashtra',
    'profileImage':
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
    'following': 27,
    'orders': 12,
    'wishlist': 45,
    'memberSince': 'March 2023',
  };

  // Mock recent orders with fixed image URLs
  final List<Map<String, dynamic>> recentOrders = [
    {
      'id': '#ORD001',
      'artisan': 'Priya Sharma',
      'product': 'Bandhani Saree',
      'amount': '₹2,850',
      'status': 'Delivered',
      'date': 'Dec 15, 2024',
      'image':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=200',
    },
    {
      'id': '#ORD002',
      'artisan': 'Ravi Kumar',
      'product': 'Kathakali Mask',
      'amount': '₹1,200',
      'status': 'Shipped',
      'date': 'Dec 10, 2024',
      'image':
          'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=200',
    },
    {
      'id': '#ORD003',
      'artisan': 'Meera Arts',
      'product': 'Embroidered Kurta',
      'amount': '₹1,850',
      'status': 'Processing',
      'date': 'Dec 8, 2024',
      'image':
          'https://images.unsplash.com/photo-1583217874467-c7fe7b67c5df?w=200',
    },
  ];

  // Mock wishlist items with fixed image URLs
  final List<Map<String, dynamic>> wishlistItems = [
    {
      'id': 1,
      'name': 'Embroidered Kurta',
      'artisan': 'Meera Arts',
      'price': '₹1,850',
      'image':
          'https://images.unsplash.com/photo-1583217874467-c7fe7b67c5df?w=200',
    },
    {
      'id': 2,
      'name': 'Silver Jewelry Set',
      'artisan': 'Rajesh Crafts',
      'price': '₹3,200',
      'image':
          'https://images.unsplash.com/photo-1594736797933-d0501ba2fe65?w=200',
    },
    {
      'id': 3,
      'name': 'Handwoven Scarf',
      'artisan': 'Traditional Weavers',
      'price': '₹1,450',
      'image':
          'https://images.unsplash.com/photo-1582639590854-5fdf60c2cb0c?w=200',
    },
    {
      'id': 4,
      'name': 'Pottery Set',
      'artisan': 'Clay Artists',
      'price': '₹2,100',
      'image':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=200',
    },
  ];

  // Menu items organized by sections
  final List<Map<String, dynamic>> menuSections = [
    {
      'title': 'Account',
      'items': [
        {
          'icon': Icons.person,
          'title': 'My Account',
          'subtitle': 'Edit profile information',
          'route': '/edit-profile',
        },
        {
          'icon': Icons.shopping_bag,
          'title': 'My Orders',
          'subtitle': 'Track and manage orders',
          'badge': 12,
          'route': '/my-orders',
        },
        {
          'icon': Icons.favorite,
          'title': 'My Wishlist',
          'subtitle': 'Saved products',
          'badge': 45,
          'route': '/wishlist',
        },
        {
          'icon': Icons.star,
          'title': 'My Reviews',
          'subtitle': 'Reviews and ratings',
          'route': '/my-reviews',
        },
      ],
    },
    {
      'title': 'Support',
      'items': [
        {
          'icon': Icons.help_center,
          'title': 'Help Center',
          'subtitle': 'FAQs and guides',
          'route': '/help-center',
        },
        {
          'icon': Icons.chat,
          'title': 'Customer Service',
          'subtitle': 'Chat with support',
          'route': '/customer-service',
        },
        {
          'icon': Icons.refresh,
          'title': 'Return Policy',
          'subtitle': 'Return and refund info',
          'route': '/return-policy',
        },
        {
          'icon': Icons.local_shipping,
          'title': 'Shipping & Delivery',
          'subtitle': 'Delivery information',
          'route': '/shipping-info',
        },
      ],
    },
    {
      'title': 'App',
      'items': [
        {
          'icon': Icons.settings,
          'title': 'Settings',
          'subtitle': 'App preferences',
          'route': '/settings',
        },
        {
          'icon': Icons.privacy_tip,
          'title': 'Privacy Policy',
          'subtitle': 'Data and privacy',
          'route': '/privacy-policy',
        },
        {
          'icon': Icons.info,
          'title': 'About Kartisan',
          'subtitle': 'App information',
          'route': '/about',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 8),
            _buildQuickActionsSection(),
            const SizedBox(height: 8),
            _buildRecentOrdersSection(),
            const SizedBox(height: 8),
            _buildWishlistSection(),
            const SizedBox(height: 8),
            _buildMenuSections(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Image with error handling
              CircleAvatar(
                radius: 32,
                child: ClipOval(
                  child: Image.network(
                    customerData['profileImage'],
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 64,
                        height: 64,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.person,
                          size: 32,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Profile Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerData['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          customerData['location'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Stats Row
                    Row(
                      children: [
                        _buildStatItem(
                          '${customerData['following']}',
                          'Following',
                        ),
                        const SizedBox(width: 16),
                        _buildStatItem('${customerData['orders']}', 'Orders'),
                        const SizedBox(width: 16),
                        _buildStatItem(
                          '${customerData['wishlist']}',
                          'Wishlist',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit Button
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                icon: const Icon(Icons.edit, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Member Since
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Member since ${customerData['memberSince']}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.shopping_cart,
                  title: 'Cart',
                  subtitle: '3 items',
                  color: Colors.orange,
                  onTap: () => Navigator.pushNamed(context, '/cart'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.favorite,
                  title: 'Wishlist',
                  subtitle: '${customerData['wishlist']} saved',
                  color: Colors.pink,
                  onTap: () => Navigator.pushNamed(context, '/wishlist'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.9),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: color.withOpacity(0.7)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrdersSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Orders',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/my-orders'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Orders List
          ...recentOrders
              .take(2)
              .map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildOrderCard(order),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    Color statusColor = _getStatusColor(order['status']);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Product Image with error handling
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              order['image'],
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 48,
                  height: 48,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // Order Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['product'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'by ${order['artisan']}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  order['date'],
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          // Amount and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                order['amount'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Wishlist',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/wishlist'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Wishlist Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: wishlistItems.take(4).length,
            itemBuilder: (context, index) {
              var item = wishlistItems[index];
              return _buildWishlistCard(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with heart icon and error handling
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  item['image'],
                  width: double.infinity,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.pink,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          // Product Details
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item['artisan'],
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                const SizedBox(height: 4),
                Text(
                  item['price'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSections() {
    return Column(
      children: menuSections
          .map((section) => _buildMenuSection(section))
          .toList(),
    );
  }

  Widget _buildMenuSection(Map<String, dynamic> section) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey.shade50,
            child: Text(
              section['title'].toString().toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Menu Items
          ...section['items']
              .map<Widget>((item) => _buildMenuItem(item))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, item['route']);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(item['icon'], color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      if (item['badge'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${item['badge']}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (item['subtitle'] != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item['subtitle'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
