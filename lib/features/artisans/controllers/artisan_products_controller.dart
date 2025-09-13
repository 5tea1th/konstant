import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ArtisanProductsController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instanceFor(bucket: "gs://artisan-app-media");

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
  Future<void> addProduct({
    required String title,
    required String description,
    required String category,
    required int priceINR,
    required int stock,
    required List<File> photos,
  }) async {
    final uid = _auth.currentUser!.uid;

    // Generate a new document reference with Firestore's auto-ID
    final docRef = _firestore.collection('products').doc();

    // Upload photos
    List<String> photoUrls = [];
    for (int i = 0; i < photos.length; i++) {
      final ref = _storage.ref('artisans/$uid/products/${docRef.id}/photo_$i.jpg');
      await ref.putFile(photos[i]);
      photoUrls.add(await ref.getDownloadURL());
    }

    // Save product with auto-generated ID
    await docRef.set({
      'productId': docRef.id, // store the Firestore ID inside the document
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
  }

  /// Delete a product
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }
}