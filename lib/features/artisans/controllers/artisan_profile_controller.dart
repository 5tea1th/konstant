import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ArtisanProfileController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instanceFor(
    bucket: "artisan-app-media",
  );
  final _auth = FirebaseAuth.instance;

  Future<void> updateProfile({
    required String name,
    required String bio,
    File? profilePhoto,
    List<File>? shopPhotos,
    File? introVideo,
  }) async {
    final uid = _auth.currentUser!.uid;
    final docRef = _firestore.collection('artisans').doc(uid);

    String? profileUrl;
    if (profilePhoto != null) {
      final ref = _storage.ref('artisans/$uid/profile.jpg');
      await ref.putFile(profilePhoto);
      profileUrl = await ref.getDownloadURL();
    }

    List<String> shopUrls = [];
    if (shopPhotos != null) {
      for (int i = 0; i < shopPhotos.length; i++) {
        final ref = _storage.ref('artisans/$uid/shop_$i.jpg');
        await ref.putFile(shopPhotos[i]);
        shopUrls.add(await ref.getDownloadURL());
      }
    }

    String? videoUrl;
    if (introVideo != null) {
      final ref = _storage.ref('artisans/$uid/intro.mp4');
      await ref.putFile(introVideo);
      videoUrl = await ref.getDownloadURL();
    }

    await docRef.set({
      'displayName': name,
      'bio': bio,
      'profilePhoto': profileUrl,
      'shopPhotos': shopUrls,
      'introVideo': videoUrl,
    }, SetOptions(merge: true));
  }
}