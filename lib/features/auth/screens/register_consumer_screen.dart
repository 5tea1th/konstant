import 'package:flutter/material.dart';
import '../controllers/auth_controllers.dart';
import '../../consumers/screens/consumer_home.dart';

class RegisterConsumerScreen extends StatefulWidget {
  const RegisterConsumerScreen({super.key});

  @override
  State<RegisterConsumerScreen> createState() => _RegisterConsumerScreenState();
}

class _RegisterConsumerScreenState extends State<RegisterConsumerScreen> {
  final _phone = TextEditingController();
  final _name = TextEditingController();
  final _auth = AuthController();

  bool otpSent = false;
  final _otpController = TextEditingController();

  Future<void> _sendOtp() async {
    await _auth.sendOtp(
      _phone.text.trim(),
      "consumer",
      extraData: {"displayName": _name.text},
    );
    setState(() => otpSent = true);
  }

  Future<void> _verifyOtp() async {
    final user = await _auth.verifyOtp(_otpController.text.trim());
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConsumerHome()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Consumer")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _phone, decoration: const InputDecoration(labelText: "Phone (+91...)")),
            TextField(controller: _name, decoration: const InputDecoration(labelText: "Full Name")),
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
    );
  }
}