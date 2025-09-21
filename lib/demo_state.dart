// import 'package:flutter/material.dart';

// class DemoState extends ChangeNotifier {
//   // Lists to store our products and reels
//   List<String> products = [];
//   List<String> reels = [];

//   // Helper to check if user has added first product
//   bool get hasProducts => products.isNotEmpty;
//   bool get hasReels => reels.isNotEmpty;

//   // Method to add a product
//   void addProduct(String productName) {
//     products.add(productName);
//     notifyListeners(); // This tells the UI to update
//   }

//   // Method to add a reel
//   void addReel(String reelName) {
//     reels.add(reelName);
//     notifyListeners(); // This tells the UI to update
//   }

//   // Method to clear everything (for demo reset)
//   void clearAll() {
//     products.clear();
//     reels.clear();
//     notifyListeners();
//   }

//   // For debugging - let's see what we have
//   void printState() {
//     print("Products: $products");
//     print("Reels: $reels");
//   }
// }

import 'package:flutter/material.dart';

class DemoState extends ChangeNotifier {
  // Store detailed product information
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> reels = [];

  bool get hasProducts => products.isNotEmpty;
  bool get hasReels => reels.isNotEmpty;

  // Updated method to store product with image
  void addProduct(String title, {String? imageUrl}) {
    products.add({
      'title': title,
      'imageUrl': imageUrl,
      'timestamp': DateTime.now(),
    });
    notifyListeners();
  }

  // Updated method to store reel with video path
  void addReel(String title, String storagePath) {
    reels.add({
      'title': title,
      'storagePath': storagePath,
      'timestamp': DateTime.now(),
    });
    notifyListeners();
  }

  void clearAll() {
    products.clear();
    reels.clear();
    notifyListeners();
  }
}
