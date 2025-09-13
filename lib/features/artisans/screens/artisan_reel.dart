import 'package:flutter/material.dart';

class ArtisanReelsPage extends StatelessWidget {
  const ArtisanReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artisan Reels"),
      ),
      body: const Center(
        child: Text(
          "Reels page coming soon 🎥",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}