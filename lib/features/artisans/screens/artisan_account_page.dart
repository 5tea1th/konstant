import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../demo_state.dart';

class ArtisanAccountScreen extends StatefulWidget {
  final String? artisanId;
  final bool isOwner;

  const ArtisanAccountScreen({super.key, this.artisanId, this.isOwner = false});

  @override
  State<ArtisanAccountScreen> createState() => _ArtisanAccountScreenState();
}

class _ArtisanAccountScreenState extends State<ArtisanAccountScreen> {
  String activeTab = 'products';
  bool following = false;
  bool isOwner = false;
  Map<String, dynamic>? artisanData;

  // Mock artisan data
  final Map<String, dynamic> mockArtisan = {
    'name': 'Priya Sharma',
    'username': '@priyacrafts',
    'location': 'Jaipur, Rajasthan',
    'bio':
        'Master craftsperson specializing in traditional Bandhani and block printing techniques. Preserving heritage through handmade art.',
    'profileImage':
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
    'followers': 2847,
    'likes': 15623,
    'orders': 342,
    'phone': '+91 98765 43210',
    'email': 'priya.crafts@email.com',
    'rating': 4.9,
    'experience': '15+ years',
    'verified': true,
  };

  @override
  void initState() {
    super.initState();
    _determineViewType();
    artisanData = mockArtisan;
  }

  void _determineViewType() {
    if (widget.isOwner) {
      isOwner = true;
    } else if (widget.artisanId != null) {
      String currentUserId = 'current_user_123';
      isOwner = (widget.artisanId == currentUserId);
    } else {
      isOwner = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            if (isOwner) _buildOrdersSection(),
            _buildTabSection(),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(
        isOwner ? 'My Account' : artisanData!['name'],
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (isOwner)
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(artisanData!['profileImage']),
                  ),
                  if (artisanData!['verified'])
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artisanData!['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      artisanData!['username'],
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
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
                          artisanData!['location'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (isOwner) ...[
                          _buildStatItem('${artisanData!['orders']}', 'Orders'),
                          const SizedBox(width: 16),
                        ],
                        _buildStatItem(
                          '${artisanData!['followers']}',
                          'Followers',
                        ),
                        const SizedBox(width: 16),
                        _buildStatItem('${artisanData!['likes']}', 'Likes'),
                      ],
                    ),
                  ],
                ),
              ),
              if (isOwner)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: Colors.grey),
                )
              else
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _handleFollow,
                      icon: Icon(
                        following ? Icons.person_remove : Icons.person_add,
                      ),
                      label: Text(following ? 'Following' : 'Follow'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: following
                            ? Colors.grey.shade300
                            : Colors.orange,
                        foregroundColor: following
                            ? Colors.black
                            : Colors.white,
                        minimumSize: const Size(100, 36),
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 36),
                      ),
                      child: const Icon(Icons.message),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            artisanData!['bio'],
            style: const TextStyle(color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              if (isOwner) ...[
                _buildContactRow(Icons.phone, artisanData!['phone']),
                _buildContactRow(Icons.email, artisanData!['email']),
              ],
              _buildContactRow(
                Icons.star,
                '${artisanData!['rating']} Rating • ${artisanData!['experience']}',
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

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildOrdersSection() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.shopping_bag, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Recent Orders',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 12),
          _buildOrderCard(
            '#ORD001',
            'Anita Patel',
            '₹2,850',
            'Delivered',
            '2 days ago',
          ),
          const SizedBox(height: 8),
          _buildOrderCard(
            '#ORD002',
            'Rajesh Kumar',
            '₹1,200',
            'Shipped',
            '5 days ago',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    String orderId,
    String customer,
    String amount,
    String status,
    String date,
  ) {
    Color statusColor = status == 'Delivered'
        ? Colors.green
        : status == 'Shipped'
        ? Colors.blue
        : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderId,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                customer,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
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

  Widget _buildTabSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTab('Products', 'products', Icons.grid_3x3),
          const SizedBox(width: 24),
          _buildTab('Reels', 'reels', Icons.play_arrow),
        ],
      ),
    );
  }

  Widget _buildTab(String label, String tabKey, IconData icon) {
    bool isActive = activeTab == tabKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = tabKey;
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? Colors.orange : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.orange : Colors.grey,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 60,
            color: isActive ? Colors.orange : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      color: Colors.white,
      child: activeTab == 'products' ? _buildProductsGrid() : _buildReelsGrid(),
    );
  }

  Widget _buildProductsGrid() {
    return Consumer<DemoState>(
      builder: (context, demoState, child) {
        if (!demoState.hasProducts) {
          return Container(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No products yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  if (isOwner)
                    Text(
                      "Add your first product to get started!",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: demoState.products.length,
          itemBuilder: (context, index) {
            final product = demoState.products[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Product image
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: product['imageUrl'] != null
                          ? Image.network(
                              product['imageUrl'],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.inventory,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    // Product info overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          product['title'] ?? 'Product',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReelsGrid() {
    return Consumer<DemoState>(
      builder: (context, demoState, child) {
        if (!demoState.hasReels) {
          return Container(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.video_library_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No reels yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Add products to automatically generate reels!",
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: demoState.reels.length,
          itemBuilder: (context, index) {
            final reel = demoState.reels[index];
            // Find corresponding product for thumbnail
            final correspondingProduct = demoState.products.firstWhere(
              (product) =>
                  reel['title']?.contains(product['title'] ?? '') ?? false,
              orElse: () => <String, dynamic>{},
            );

            return GestureDetector(
              onTap: () => _playReel(context, reel['storagePath']),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Use product image as thumbnail if available
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: correspondingProduct['imageUrl'] != null
                            ? Image.network(
                                correspondingProduct['imageUrl'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.purple.shade300,
                                          Colors.blue.shade300,
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.purple.shade300,
                                      Colors.blue.shade300,
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                    // Dark overlay for better visibility of icons
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    // Play icon
                    Center(
                      child: Icon(
                        Icons.play_circle_filled,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    // Reel title
                    Positioned(
                      bottom: 4,
                      left: 4,
                      right: 4,
                      child: Text(
                        reel['title'] ?? 'Reel',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _playReel(BuildContext context, String storagePath) async {
    try {
      // Convert gs:// URL to download URL
      final ref = FirebaseStorage.instance.refFromURL(storagePath);
      final downloadUrl = await ref.getDownloadURL();

      // Show reel player dialog
      showDialog(
        context: context,
        builder: (context) => ReelPlayerDialog(videoUrl: downloadUrl),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading reel: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleFollow() {
    setState(() {
      following = !following;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(following ? 'Following artisan!' : 'Unfollowed artisan'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Reel Player Dialog
class ReelPlayerDialog extends StatefulWidget {
  final String videoUrl;

  const ReelPlayerDialog({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<ReelPlayerDialog> createState() => _ReelPlayerDialogState();
}

class _ReelPlayerDialogState extends State<ReelPlayerDialog> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Stack(
          children: [
            if (_isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),

            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),

            // Play/pause overlay
            if (_isInitialized)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
