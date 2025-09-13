import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ArtisanOnboardingController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instanceFor(
    bucket: "artisan-app-media",
  );

  Future<void> submitOnboarding({
    required String displayName,
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String state,
    required String country,
    required File aadhaarFile,
    required File panFile,
    required File selfieFile,
    double? lat,
    double? lng,
  }) async {
    final uid = _auth.currentUser!.uid;

    // Upload files
    final aadhaarRef = _storage.ref('artisans/$uid/aadhaar.jpg');
    await aadhaarRef.putFile(aadhaarFile);
    final aadhaarUrl = await aadhaarRef.getDownloadURL();

    final panRef = _storage.ref('artisans/$uid/pan.jpg');
    await panRef.putFile(panFile);
    final panUrl = await panRef.getDownloadURL();

    final selfieRef = _storage.ref('artisans/$uid/selfie.jpg');
    await selfieRef.putFile(selfieFile);
    final selfieUrl = await selfieRef.getDownloadURL();

    // ✅ Update artisan doc (merge to keep existing fields)
    await _firestore.collection('artisans').doc(uid).set({
      'displayName': displayName,
      'address': {
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'city': city,
        'state': state,
        'country': country,
      },
      'location': {
        'lat': lat,
        'lng': lng,
      },
      'kycStatus': 'pending',
    }, SetOptions(merge: true));

    // ✅ Add KYC submission
    await _firestore
        .collection('artisans')
        .doc(uid)
        .collection('kycSubmissions')
        .doc('main')
        .set({
      'aadhaarUrl': aadhaarUrl,
      'panUrl': panUrl,
      'selfieUrl': selfieUrl,
      'status': 'pending',
      'submittedAt': FieldValue.serverTimestamp(),
    });

    // ✅ Update users collection safely (merge)
    await _firestore.collection('users').doc(uid).set({
      'displayName': displayName,
      'region': city,
    }, SetOptions(merge: true));
  }
}