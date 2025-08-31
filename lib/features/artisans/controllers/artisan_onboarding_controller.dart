import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ArtisanOnboardingController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

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

    // Update artisan doc
    await _firestore.collection('artisans').doc(uid).set({
      'artisanId': uid,
      'displayName': displayName,
      'bio': null,
      'address': {
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'state': state,
        'country': country,
      },
      'location': {
        'lat': lat,
        'lng': lng,
      },
      'profilePhotoUrl': null,
      'introVideoUrl': null,
      'tags': [],
      'isVerified': false,
      'certId': '',
      'kycStatus': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // KYC submission
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
      'reviewedAt': null,
      'reviewedBy': null,
    });

    // Update users collection
    await _firestore.collection('users').doc(uid).update({
      'displayName': displayName,
      'region': city,
    });
  }
}