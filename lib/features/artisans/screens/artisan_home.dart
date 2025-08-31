import 'package:flutter/material.dart';

class ArtisanHome extends StatelessWidget {
  const ArtisanHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Artisan Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome Artisan!", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to upload product screen
              },
              child: const Text("Upload Product"),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to certificate screen
              },
              child: const Text("View Certificate"),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to reels
              },
              child: const Text("My Reels"),
            ),
          ],
        ),
      ),
    );
  }
}