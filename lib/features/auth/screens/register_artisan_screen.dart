import 'package:flutter/material.dart';

import '../controllers/auth_controllers.dart';
import '../widgets/input_field.dart';
import '../../artisans/screens/artisan_home.dart';

class RegisterArtisanScreen extends StatefulWidget {
  const RegisterArtisanScreen({super.key});

  @override
  State<RegisterArtisanScreen> createState() => _RegisterArtisanScreenState();
}

class _RegisterArtisanScreenState extends State<RegisterArtisanScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _bio = TextEditingController();
  final _auth = AuthController();

  Future<void> _register() async {
    try {
      final user = await _auth.registerUser(
        email: _email.text,
        password: _password.text,
        role: "artisan",
        extraData: {
          "displayName": _name.text,
          "bio": _bio.text,
          "isVerified": false,
        },
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ArtisanHome()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
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
              InputField(controller: _email, label: "Email"),
              InputField(controller: _password, label: "Password", obscure: true),
              InputField(controller: _name, label: "Full Name"),
              InputField(controller: _bio, label: "Short Bio"),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _register, child: const Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}