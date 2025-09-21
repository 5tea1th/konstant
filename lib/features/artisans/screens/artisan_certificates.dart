import 'package:flutter/material.dart';

class ArtisanCertsPage extends StatelessWidget {
  const ArtisanCertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Artisan Certificates")),
      body: const Center(
        child: Text(
          "Certificates page coming soon 🎥",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
