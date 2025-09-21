import 'package:flutter/material.dart';

class ProductPurchaseScreen extends StatefulWidget {
  final String? productId; // Optional direct parameter

  const ProductPurchaseScreen({super.key, this.productId});

  @override
  State<ProductPurchaseScreen> createState() => _ProductPurchaseScreenState();
}

class _ProductPurchaseScreenState extends State<ProductPurchaseScreen> {
  int quantity = 1;
  String selectedSize = 'M';
  bool saved = false;
  Map<String, dynamic>? productData;

  // Default product data (if no data is passed)
  final Map<String, dynamic> defaultProduct = {
    'id': '1',
    'imageUrl':
        'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
    'artisan': 'Priya Sharma',
    'location': 'Rajasthan',
    'name': 'Hand-woven Bandhani Saree',
    'price': '₹2,850',
    'originalPrice': '₹3,200',
    'rating': 4.8,
    'reviewCount': 45,
    'description':
        'Beautiful hand-woven Bandhani saree crafted using traditional tie-dye techniques passed down through generations. Each piece is unique and tells a story of Rajasthani heritage.',
    'sizes': ['S', 'M', 'L', 'XL'],
    'inStock': true,
    'deliveryTime': '7-10 days',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get data passed via Navigator arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      productData = args;
    } else {
      productData = defaultProduct; // Use default if no data passed
    }
  }

  void adjustQuantity(int change) {
    setState(() {
      quantity = (quantity + change).clamp(1, 999);
    });
  }

  void handleSave() {
    setState(() {
      saved = !saved;
    });

    // Show snackbar feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(saved ? 'Added to wishlist!' : 'Removed from wishlist'),
        duration: const Duration(seconds: 2),
        backgroundColor: saved ? Colors.green : Colors.grey,
      ),
    );
  }

  void addToCart() {
    // Handle add to cart logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  int calculateDiscount() {
    if (productData == null) return 0;
    final price = int.parse(
      productData!['price'].toString().replaceAll(RegExp(r'[₹,]'), ''),
    );
    final originalPrice = int.parse(
      productData!['originalPrice'].toString().replaceAll(RegExp(r'[₹,]'), ''),
    );
    return ((1 - price / originalPrice) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    if (productData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      image: DecorationImage(
                        image: NetworkImage(productData!['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Info Section
                        _buildProductInfo(),
                        const SizedBox(height: 24),

                        // Description Section
                        _buildDescription(),
                        const SizedBox(height: 24),

                        // Size Selection (if multiple sizes available)
                        if (productData!['sizes'].length > 1) ...[
                          _buildSizeSelection(),
                          const SizedBox(height: 24),
                        ],

                        // Quantity Section
                        _buildQuantitySelection(),
                        const SizedBox(height: 24),

                        // Delivery Info
                        _buildDeliveryInfo(),
                        const SizedBox(height: 24),

                        // Reviews Section
                        _buildReviewsSection(),
                        const SizedBox(height: 24),

                        // Artisan Info Section
                        _buildArtisanInfo(),
                        const SizedBox(height: 24),

                        // Authenticity Certificate
                        _buildAuthenticityBadge(),
                        const SizedBox(height: 100), // Space for bottom button
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Actions
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          productData!['name'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // Price and Discount
        Row(
          children: [
            Text(
              productData!['price'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              productData!['originalPrice'],
              style: const TextStyle(
                fontSize: 18,
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${calculateDiscount()}% OFF',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Rating and Stock Status
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              '${productData!['rating']}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Text(
              '(${productData!['reviewCount']} reviews)',
              style: const TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: productData!['inStock']
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                productData!['inStock'] ? 'In Stock' : 'Out of Stock',
                style: TextStyle(
                  fontSize: 12,
                  color: productData!['inStock']
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          productData!['description'],
          style: const TextStyle(color: Colors.grey, height: 1.5, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSizeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: productData!['sizes'].map<Widget>((size) {
            return ChoiceChip(
              label: Text(size),
              selected: selectedSize == size,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedSize = size;
                  });
                }
              },
              selectedColor: Colors.orange.shade100,
              backgroundColor: Colors.grey.shade100,
              labelStyle: TextStyle(
                color: selectedSize == size
                    ? Colors.orange.shade700
                    : Colors.grey.shade700,
                fontWeight: selectedSize == size
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
              side: BorderSide(
                color: selectedSize == size
                    ? Colors.orange.shade500
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildQuantityButton(
              icon: Icons.remove,
              onPressed: () => adjustQuantity(-1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildQuantityButton(
              icon: Icons.add,
              onPressed: () => adjustQuantity(1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.local_shipping, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 8),
          Text(
            'Estimated Delivery: ${productData!['deliveryTime']}',
            style: TextStyle(
              color: Colors.blue.shade800,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews (${productData!['reviewCount']})',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // Sample Review 1
        _buildReviewCard(
          rating: 5,
          title: 'Excellent quality!',
          review:
              'Beautiful craftsmanship and authentic design. Highly recommended!',
          reviewer: 'Verified Customer',
        ),
        const SizedBox(height: 12),

        // Sample Review 2
        _buildReviewCard(
          rating: 4,
          title: 'Great value for money',
          review: 'Love the traditional patterns. Fast delivery too!',
          reviewer: 'Verified Customer',
        ),
        const SizedBox(height: 8),

        TextButton(
          onPressed: () {
            // Navigate to all reviews screen
          },
          child: const Text(
            'View all reviews →',
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required int rating,
    required String title,
    required String review,
    required String reviewer,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  color: index < rating ? Colors.amber : Colors.grey.shade300,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            review,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '- $reviewer',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildArtisanInfo() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meet the Artisan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.pink],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productData!['artisan'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      productData!['location'],
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const Text(
                      'Master craftsperson • 15+ years experience',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to artisan profile
                  Navigator.pushNamed(
                    context,
                    '/artisan-account',
                    arguments: {'artisanId': 'artisan_123'},
                  );
                },
                child: const Text(
                  'Follow',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticityBadge() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Authenticity Guaranteed',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'This product comes with an NFT certificate of authenticity.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Save/Bookmark Button
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: saved ? Colors.yellow.shade700 : Colors.grey.shade300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: handleSave,
                icon: Icon(
                  saved ? Icons.bookmark : Icons.bookmark_border,
                  color: saved ? Colors.yellow.shade700 : Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Add to Cart Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: productData!['inStock'] ? addToCart : null,
                icon: const Icon(Icons.shopping_cart),
                label: Text(
                  'Add to Cart • ${productData!['price']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
