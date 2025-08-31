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
        "email": null,
        "displayName": _pendingExtraData?["displayName"] ?? null,
        "photoURL": null,
        "role": _pendingRole,
        "region": _pendingExtraData?["region"] ?? null,
        "isVerified": false,
        "createdAt": FieldValue.serverTimestamp(),
        "lastSeen": FieldValue.serverTimestamp(),
      });

      if (_pendingRole == "artisan") {
        await _firestore.collection("artisans").doc(user.uid).set({
          "artisanId": user.uid,
          "displayName": _pendingExtraData?["displayName"] ?? null,
          "bio": _pendingExtraData?["bio"] ?? null,
          "address": {
            "city": _pendingExtraData?["city"] ?? null,
            "state": _pendingExtraData?["state"] ?? null,
            "country": _pendingExtraData?["country"] ?? null,
          },
          "location": {
            "lat": _pendingExtraData?["lat"] ?? null,
            "lng": _pendingExtraData?["lng"] ?? null,
          },
          "profilePhotoUrl": null,
          "introVideoUrl": null,
          "tags": [],
          "isVerified": false,
          "certId": null,
          "email": null,
          "createdAt": FieldValue.serverTimestamp(),
        });

        // Init empty KYC
        final kycId = _firestore
            .collection("artisans")
            .doc(user.uid)
            .collection("kycSubmissions")
            .doc()
            .id;
        await _firestore
            .collection("artisans")
            .doc(user.uid)
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
    }

    return user;
  }
  //Fetch role
  Future<String?> fetchUserRole(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data();
    return data?["role"]?.toString();
  }
}