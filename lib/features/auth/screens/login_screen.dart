import 'package:flutter/material.dart';
import '../controllers/auth_controllers.dart';
import '../../artisans/screens/artisan_home.dart';
import '../../consumers/screens/consumer_home.dart';
import '../../admin/screens/admin_home.dart';

class LoginScreen extends StatefulWidget {
  final String role; // artisan / consumer / admin
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _auth = AuthController();

  bool otpSent = false;

  Future<void> _sendOtp() async {
    try {
      await _auth.sendOtp(_phoneController.text.trim(), widget.role);
      setState(() => otpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _verifyOtp() async {
    try {
      final user = await _auth.verifyOtp(_otpController.text.trim());
      if (user != null) {
        final role = await _auth.fetchUserRole(user.uid);
        if (role == "artisan") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const ArtisanHome()));
        } else if (role == "consumer") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const ConsumerHome()));
        } else if (role == "admin") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const AdminHome()));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP verification failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login as ${widget.role}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Phone (+91...)",
              ),
            ),
            if (otpSent)
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: "Enter OTP"),
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