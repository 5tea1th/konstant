import 'package:flutter/material.dart';
import '../controllers/auth_controllers.dart';
import '../../artisans/screens/artisan_home.dart';

class RegisterArtisanScreen extends StatefulWidget {
  const RegisterArtisanScreen({super.key});

  @override
  State<RegisterArtisanScreen> createState() => _RegisterArtisanScreenState();
}

class _RegisterArtisanScreenState extends State<RegisterArtisanScreen> {
  final _phone = TextEditingController();
  final _name = TextEditingController();
  final _bio = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _country = TextEditingController();
  final _auth = AuthController();

  bool otpSent = false;
  final _otpController = TextEditingController();

  Future<void> _sendOtp() async {
    await _auth.sendOtp(
      _phone.text.trim(),
      "artisan",
      extraData: {
        "displayName": _name.text,
        "bio": _bio.text,
        "city": _city.text,
        "state": _state.text,
        "country": _country.text,
      },
    );
    setState(() => otpSent = true);
  }

  Future<void> _verifyOtp() async {
    final user = await _auth.verifyOtp(_otpController.text.trim());
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ArtisanHome()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Artisan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _phone, decoration: const InputDecoration(labelText: "Phone (+91...)")),
              TextField(controller: _name, decoration: const InputDecoration(labelText: "Full Name")),
              TextField(controller: _bio, decoration: const InputDecoration(labelText: "Bio")),
              TextField(controller: _city, decoration: const InputDecoration(labelText: "City")),
              TextField(controller: _state, decoration: const InputDecoration(labelText: "State")),
              TextField(controller: _country, decoration: const InputDecoration(labelText: "Country")),
              if (otpSent)
                TextField(controller: _otpController, decoration: const InputDecoration(labelText: "Enter OTP")),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: otpSent ? _verifyOtp : _sendOtp,
                child: Text(otpSent ? "Verify OTP" : "Send OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}