import 'package:flutter/material.dart';
import 'artisan_product.dart';
import 'artisan_profile.dart';
import 'artisan_reel.dart';


class ArtisanDashboard extends StatelessWidget {
  const ArtisanDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Artisan Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ArtisanProfile()),
              ),
              child: const Text("Profile"),
            ),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Certificate feature coming soon")),
              ),
              child: const Text("View Certificate"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ArtisanReelsPage()),
              ),
              child: const Text("Reels"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ArtisanProductsPage()),
              ),
              child: const Text("Add Products"),
            ),
          ],
        ),
      ),
    );
  }
}