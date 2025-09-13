import 'package:flutter/material.dart';
import '../controllers/artisan_products_controller.dart';
import 'artisan_add_product.dart';


class ArtisanProductsPage extends StatefulWidget {
  const ArtisanProductsPage({super.key});

  @override
  State<ArtisanProductsPage> createState() => _ArtisanProductsPageState();
}

class _ArtisanProductsPageState extends State<ArtisanProductsPage> {
  final _controller = ArtisanProductsController();
  late Future<List<Map<String, dynamic>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = _controller.fetchProducts();
    });
  }

  Future<void> _openAddProduct() async {
    final added = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ArtisanAddProductPage()),
    );
    if (added == true) {
      _loadProducts(); // refresh list after new product
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(
              child: Text(
                "No products yet.\nAdd your first product!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final title = product['title'] ?? "Unnamed";
              final price = product['priceINR']?.toString() ?? "N/A";
              final photos = product['photos'] as List?;
              final imageUrl = (photos != null && photos.isNotEmpty) ? photos[0] : null;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: imageUrl != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.image_not_supported, size: 40),
                  title: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("Price: ₹$price"),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}