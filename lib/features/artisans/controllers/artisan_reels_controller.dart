import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ArtisanReelsController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> fetchReels() async {
    final uid = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection('reels')
        .where('artisanId', isEqualTo: uid)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}