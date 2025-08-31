import 'package:flutter/material.dart';

class ConsumerHome extends StatelessWidget {
  const ConsumerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consumer Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome Consumer!", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to reels feed
              },
              child: const Text("Browse Reels"),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to saved items
              },
              child: const Text("Saved Products"),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to purchases
              },
              child: const Text("My Purchases"),
            ),
          ],
        ),
      ),
    );
  }
}