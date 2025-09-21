import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'artisan_add_product.dart';
import '../../../demo_state.dart';

class ArtisanProductsPage extends StatefulWidget {
  const ArtisanProductsPage({super.key});

  @override
  State<ArtisanProductsPage> createState() => _ArtisanProductsPageState();
}

class _ArtisanProductsPageState extends State<ArtisanProductsPage> {
  Future<void> _openAddProduct() async {
    final added = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ArtisanAddProductPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Products")),
      body: Consumer<DemoState>(
        builder: (context, demoState, child) {
          if (demoState.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
                  Text(
                    "Add your first product to get started!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: demoState.products.length,
            itemBuilder: (context, index) {
              // Access the product map at the current index
              final product = demoState.products[index];
              final productTitle =
                  product['title'] as String? ?? 'Unnamed Product';
              final productImageUrl =
                  (product['photos'] as List<String>?)?.isNotEmpty == true
                  ? (product['photos'] as List<String>).first
                  : null;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: productImageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            productImageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                          ),
                        )
                      : const Icon(
                          Icons.inventory,
                          size: 40,
                          color: Colors.orange,
                        ),
                  title: Text(
                    productTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    product['category'] as String? ?? 'No category',
                  ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
