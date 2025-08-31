import 'package:flutter/material.dart';
import 'package:konstant/features/artisans/screens/artisan_onboarding_page.dart';
import 'package:konstant/main.dart';
import '../controllers/auth_controllers.dart';
import '../../artisans/screens/artisan_home.dart';

class RegisterArtisanScreen extends StatefulWidget {
  const RegisterArtisanScreen({super.key});

  @override
  State<RegisterArtisanScreen> createState() => _RegisterArtisanScreenState();
}

class _RegisterArtisanScreenState extends State<RegisterArtisanScreen> {
  final _phone = TextEditingController();
  final _auth = AuthController();

  bool otpSent = false;
  final _otpController = TextEditingController();

  Future<void> _sendOtp() async {
    if (_phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a phone number")),
      );
      return;
    }

    await _auth.sendOtp(
      _phone.text.trim(),
      "artisan",
    );
    setState(() => otpSent = true);
  }

  Future<void> _verifyOtp() async {
    final user = await _auth.verifyOtp(_otpController.text.trim());
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ArtisanOnboardingPage())
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Artisan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phone,
              decoration: const InputDecoration(
                  labelText: "Phone (eg +911234567890)"),
              keyboardType: TextInputType.phone,
            ),
            if (otpSent)
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: "Enter OTP"),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: otpSent ? _verifyOtp : _sendOtp,
              child: Text(otpSent ? "Verify OTP" : "Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}