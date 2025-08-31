import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Register new user
  Future<User?> registerUser({
    required String email,
    required String password,
    required String role, // "artisan" | "consumer" | "admin"
    Map<String, dynamic>? extraData,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = cred.user!.uid;

    // --- initialize users/{uid} doc with all fields ---
    await _firestore.collection("users").doc(uid).set({
      "uid": uid,
      "email": email,
      "phone": extraData?["phone"] ?? null,
      "displayName": extraData?["displayName"] ?? null,
      "photoURL": extraData?["photoURL"] ?? null,
      "role": role,
      "region": extraData?["region"] ?? null,
      "isVerified": false,
      "createdAt": FieldValue.serverTimestamp(),
      "lastSeen": FieldValue.serverTimestamp(),
    });

    // --- if artisan, also create artisans/{uid} doc ---
    if (role == "artisan") {
      await _firestore.collection("artisans").doc(uid).set({
        "artisanId": uid,
        "displayName": extraData?["displayName"] ?? null,
        "bio": extraData?["bio"] ?? null,
        "address": {
          "city": extraData?["city"] ?? null,
          "state": extraData?["state"] ?? null,
          "country": extraData?["country"] ?? null,
        },
        "location": {
          "lat": extraData?["lat"] ?? null,
          "lng": extraData?["lng"] ?? null,
        },
        "profilePhotoUrl": null,
        "introVideoUrl": null,
        "tags": [],
        "isVerified": false,
        "certId": null,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // --- also create empty KYC submission doc ---
      final kycId = _firestore.collection("artisans").doc(uid).collection("kycSubmissions").doc().id;
      await _firestore
          .collection("artisans")
          .doc(uid)
          .collection("kycSubmissions")
          .doc(kycId)
          .set({
        "aadharURL": null,
        "panURL": null,
        "selfieURL": null,
        "status": "pending",
        "submittedAt": FieldValue.serverTimestamp(),
        "reviewedAt": null,
        "reviewedBy": null,
      });
    }

    return cred.user;
  }

  // Login existing user
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // Fetch role from Firestore
  Future<String?> fetchUserRole(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    if (doc.exists) {
      return doc.data()?["role"] as String?;
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}