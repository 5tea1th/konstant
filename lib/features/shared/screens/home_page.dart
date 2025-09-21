import 'package:flutter/material.dart';
import 'search_page.dart'; // Make sure this path is correct
import '../../consumers/screens/consumer_account_page.dart'; // Example for consumer
import '../../artisans/screens/artisan_account_page.dart'; // Example for artisan
import '../../consumers/screens/consumer_reels_screen.dart'; // Example for reels
import '../../consumers/screens/product_purchase_screen.dart';

class HomePage extends StatefulWidget {
  final bool isArtisan; // To determine if user is artisan or consumer

  const HomePage({super.key, this.isArtisan = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  String searchQuery = '';

  // Mock data for feed posts
  final List<Map<String, dynamic>> feedPosts = [
    {
      'artisan': {
        'name': 'Priya Sharma',
        'location': 'Jaipur, Rajasthan',
        'image':
            'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
        'verified': true,
      },
      'product': {
        'name': 'Hand-woven Bandhani Saree',
        'image':
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
        'price': '₹2,850',
        'description':
            'Beautiful hand-woven Bandhani saree crafted using traditional tie-dye techniques passed down through generations.',
      },
      'likes': 234,
      'isLiked': false,
      'timeAgo': '2 hours ago',
    },
    {
      'artisan': {
        'name': 'Ravi Kumar',
        'location': 'Kochi, Kerala',
        'image':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        'verified': true,
      },
      'product': {
        'name': 'Traditional Kathakali Mask',
        'image':
            'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=400',
        'price': '₹1,200',
        'description':
            'Authentic Kathakali mask handcrafted by skilled artisans from Kerala. Perfect for collectors and cultural enthusiasts.',
      },
      'likes': 156,
      'isLiked': true,
      'timeAgo': '4 hours ago',
    },
    {
      'artisan': {
        'name': 'Meera Arts',
        'location': 'Lucknow, UP',
        'image':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
        'verified': false,
      },
      'product': {
        'name': 'Embroidered Kurta Set',
        'image':
            'https://images.unsplash.com/photo-1583217874467-c7fe7b67c5dd?w=400',
        'price': '₹1,850',
        'description':
            'Elegant embroidered kurta set with intricate chikankari work. Perfect for festive occasions.',
      },
      'likes': 89,
      'isLiked': false,
      'timeAgo': '6 hours ago',
    },
  ];

  // Categories for quick access
  final List<Map<String, dynamic>> categories = [
    {'name': 'Textiles', 'icon': Icons.checkroom, 'count': '450+'},
    {'name': 'Jewelry', 'icon': Icons.diamond, 'count': '320+'},
    {'name': 'Pottery', 'icon': Icons.cake, 'count': '180+'},
    {'name': 'Woodwork', 'icon': Icons.carpenter, 'count': '95+'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Categories Section
                    _buildCategoriesSection(),

                    // Feed Section
                    _buildFeedSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // App Logo/Name
              Text(
                'kartisan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(),

              // Cart Icon
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search artisans, products...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onTap: () {
                // Navigate to the search page when the user taps on the search bar
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shop by Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: categories.map((category) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to category page
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          category['icon'],
                          size: 32,
                          color: Colors.orange.shade600,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          category['count'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedSection() {
    return Column(
      children: feedPosts.map((post) => _buildFeedPost(post)).toList(),
    );
  }

  Widget _buildFeedPost(Map<String, dynamic> post) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // We're using Navigator.push for this navigation so it will correctly add the new screen to the stack
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ArtisanAccountScreen(), // You may pass arguments here
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(post['artisan']['image']),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post['artisan']['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (post['artisan']['verified'])
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            post['artisan']['location'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${post['timeAgo']}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ),

          // Product Image
          GestureDetector(
            onTap: () {
              // We're using Navigator.push for this navigation so it will correctly add the new screen to the stack
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProductPurchaseScreen(), // Assumes you have this screen
                  settings: RouteSettings(arguments: post['product']),
                ),
              );
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                post['product']['image'],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          // Post Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Action Buttons
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          post['isLiked'] = !post['isLiked'];
                          if (post['isLiked']) {
                            post['likes']++;
                          } else {
                            post['likes']--;
                          }
                        });
                      },
                      child: Icon(
                        post['isLiked']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: post['isLiked'] ? Colors.red : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.share_outlined,
                      color: Colors.grey,
                      size: 24,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // We're using Navigator.push for this navigation so it will correctly add the new screen to the stack
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ProductPurchaseScreen(), // Assumes you have this screen
                            settings: RouteSettings(arguments: post['product']),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          post['product']['price'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Likes Count
                Text(
                  '${post['likes']} likes',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),

                // Product Name and Description
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                        text: post['product']['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: post['product']['description']),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // View Comments
                const Text(
                  'View all 12 comments',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index != currentIndex) {
          // Only navigate if the tapped index is different from the current one
          setState(() {
            currentIndex = index;
          });

          switch (index) {
            case 0:
              // Home - do nothing, as we are already on this page
              // You can pop to the root if you want to clear the navigation stack
              Navigator.of(context).popUntil((route) => route.isFirst);
              break;
            case 1:
              // Search
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
              break;
            case 2:
              // Reels
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConsumerReelsScreen(),
                ), // Change to your Reels page
              );
              break;
            case 3:
              // Account
              if (widget.isArtisan) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArtisanAccountScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerAccountScreen(),
                  ),
                );
              }
              break;
          }
        }
      },
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'Reels'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      ],
    );
  }
}
