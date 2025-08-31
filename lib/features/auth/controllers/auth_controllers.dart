import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String? _verificationId;
  String? _pendingRole; // store role before OTP
  Map<String, dynamic>? _pendingExtraData;

  // Send OTP for registration/login
  Future<void> sendOtp(String phoneNumber, String role,
      {Map<String, dynamic>? extraData}) async {
    _pendingRole = role;
    _pendingExtraData = extraData;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verification (Android only)
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // Verify OTP and handle registration or login
  Future<User?> verifyOtp(String smsCode) async {
    if (_verificationId == null) return null;

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user == null) return null;

    final doc = await _firestore.collection("users").doc(user.uid).get();
    if (!doc.exists) {
      // New user → create Firestore doc
      await _firestore.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "phone": user.phoneNumber,
        "role": _pendingRole,
        "displayName": null, // can be updated later
        "email": null, // can update later
        "photoURL": null, // can update later
        "region": null, // can update later
        "isVerified": false,
        "createdAt": FieldValue.serverTimestamp(),
        "lastSeen": FieldValue.serverTimestamp(),
      });

      if (_pendingRole == "artisan") {
        // Create artisan profile doc
        await _firestore.collection("artisans").doc(user.uid).set({
          "artisanId": user.uid,
          "displayName": null,
          "bio": null,
          "address": {
            "address_line_1" : null,
            "address_line_2" : null,
            "city": null,
            "state": null,
            "country": null,
          },
          "location": {
            "lat": null,
            "lng": null,
          },
          "profilePhotoUrl": null,
          "introVideoUrl": null,
          "tags": [],
          "isVerified": false,
          "certId": null,
          "createdAt": FieldValue.serverTimestamp(),
        });

        // Init KYC status
        await _firestore
            .collection("artisans")
            .doc(user.uid)
            .collection("kycSubmissions")
            .doc("main") // single doc for simplicity
            .set({
          "aadharURL": null,
          "panURL": null,
          "selfieURL": null,
          "status": "not_submitted", // default
          "submittedAt": null,
          "reviewedAt": null,
          "reviewedBy": null,
        });
      }
    }

    return user;
  }

  // Fetch user role
  Future<String?> fetchUserRole(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    if (!doc.exists) return null;
    return doc.data()?["role"]?.toString();
  }
}