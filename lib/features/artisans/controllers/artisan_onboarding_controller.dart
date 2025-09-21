import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ArtisanOnboardingController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instanceFor(bucket: "artisan-app-media");

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
    Uint8List? aadhaarBytes, // Add for web compatibility
    Uint8List? panBytes, // Add for web compatibility
    Uint8List? selfieBytes, // Add for web compatibility
    double? lat,
    double? lng,
  }) async {
    final uid = _auth.currentUser!.uid;

    // Upload Aadhaar
    final aadhaarRef = _storage.ref('artisans/$uid/aadhaar.jpg');
    if (aadhaarBytes != null) {
      // Web upload using bytes
      await aadhaarRef.putData(aadhaarBytes);
    } else {
      // Mobile upload using File
      await aadhaarRef.putFile(aadhaarFile);
    }
    final aadhaarUrl = await aadhaarRef.getDownloadURL();

    // Upload PAN
    final panRef = _storage.ref('artisans/$uid/pan.jpg');
    if (panBytes != null) {
      // Web upload using bytes
      await panRef.putData(panBytes);
    } else {
      // Mobile upload using File
      await panRef.putFile(panFile);
    }
    final panUrl = await panRef.getDownloadURL();

    // Upload Selfie
    final selfieRef = _storage.ref('artisans/$uid/selfie.jpg');
    if (selfieBytes != null) {
      // Web upload using bytes
      await selfieRef.putData(selfieBytes);
    } else {
      // Mobile upload using File
      await selfieRef.putFile(selfieFile);
    }
    final selfieUrl = await selfieRef.getDownloadURL();

    // Update artisan doc (merge to keep existing fields)
    await _firestore.collection('artisans').doc(uid).set({
      'displayName': displayName,
      'address': {
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'city': city,
        'state': state,
        'country': country,
      },
      'location': {'lat': lat, 'lng': lng},
      'kycStatus': 'pending',
    }, SetOptions(merge: true));

    // Add KYC submission
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

    // Update users collection safely (merge)
    await _firestore.collection('users').doc(uid).set({
      'displayName': displayName,
      'region': city,
    }, SetOptions(merge: true));
  }
}
