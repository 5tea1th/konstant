import 'package:flutter/material.dart';

import '../../admin/screens/admin_home.dart';
import '../../artisans/screens/artisan_home.dart';
import '../../consumers/screens/consumer_home.dart';

import '../controllers/auth_controllers.dart';
import '../widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  final String role; // artisan / consumer / admin
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = AuthController();

  Future<void> _login() async {
    try {
      final user = await _auth.loginUser(
        email: _email.text,
        password: _password.text,
      );
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login as ${widget.role}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(controller: _email, label: "Email"),
            InputField(controller: _password, label: "Password", obscure: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}