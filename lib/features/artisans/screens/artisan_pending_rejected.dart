import 'package:flutter/material.dart';

class ArtisanPendingPage extends StatelessWidget {
  const ArtisanPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Your profile is under review 🚀",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class ArtisanRejectedPage extends StatelessWidget {
  const ArtisanRejectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Your profile has been rejected ❌\nPlease resubmit your documents.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}