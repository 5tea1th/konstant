import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'artisan_dashboard.dart';
import 'artisan_pending_rejected.dart';

class ArtisanHome extends StatelessWidget {
  const ArtisanHome({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final artisanDoc = FirebaseFirestore.instance.collection('artisans').doc(uid);

    return StreamBuilder<DocumentSnapshot>(
      stream: artisanDoc.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        final kycStatus = data['kycStatus'] ?? 'pending';

        if (kycStatus == 'pending') {
          return const ArtisanPendingPage();
        } else if (kycStatus == 'rejected') {
          return const ArtisanRejectedPage();
        } else if (kycStatus == 'accepted') {
          return const ArtisanDashboard();
        }

        return const Scaffold(body: Center(child: Text('Unknown status')));
      },
    );
  }
}

