import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class ArtisanProductsController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instanceFor(
    bucket: "gs://artisan-app-media",
  );

  /// Fetch all products belonging to the currently logged-in artisan
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final uid = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection('products')
        .where('artisanId', isEqualTo: uid)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Add a new product with up to 5 photos
  Future<Map<String, dynamic>> addProduct({
    required String title,
    required String description,
    required String category,
    required int priceINR,
    required int stock,
    required List<File> photos,
    List<Uint8List>? photoBytes, // Add this parameter for web
  }) async {
    final uid = _auth.currentUser!.uid;
    final docRef = _firestore.collection('products').doc();

    // Upload photos
    List<String> photoUrls = [];
    for (int i = 0; i < photos.length; i++) {
      final ref = _storage.ref(
        'artisans/$uid/products/${docRef.id}/photo_$i.jpg',
      );

      // Check if we're on web (using photoBytes) or mobile (using File)
      if (photoBytes != null && photoBytes.length > i) {
        // Web upload using bytes
        await ref.putData(photoBytes[i]);
      } else {
        // Mobile upload using File
        await ref.putFile(photos[i]);
      }
      photoUrls.add(await ref.getDownloadURL());
    }

    // Save product
    await docRef.set({
      'productId': docRef.id,
      'artisanId': uid,
      'title': title,
      'description': description,
      'category': category,
      'priceINR': priceINR,
      'stock': stock,
      'photos': photoUrls,
      'soldCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return {
      'productId': docRef.id,
      'firstImageUrl': photoUrls.isNotEmpty ? photoUrls[0] : null,
    };
  }

  /// Delete a product
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }
}
