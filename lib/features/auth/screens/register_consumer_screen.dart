import 'package:flutter/material.dart';
import '../controllers/auth_controllers.dart';
import '../widgets/input_field.dart';
import '../../consumers/screens/consumer_home.dart';

class RegisterConsumerScreen extends StatefulWidget {
  const RegisterConsumerScreen({super.key});

  @override
  State<RegisterConsumerScreen> createState() => _RegisterConsumerScreenState();
}

class _RegisterConsumerScreenState extends State<RegisterConsumerScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _auth = AuthController();

  Future<void> _register() async {
    try {
      final user = await _auth.registerUser(
        email: _email.text,
        password: _password.text,
        role: "consumer",
        extraData: {
          "displayName": _name.text,
        },
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ConsumerHome()),
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
      appBar: AppBar(title: const Text("Register Consumer")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InputField(controller: _email, label: "Email"),
            InputField(controller: _password, label: "Password", obscure: true),
            InputField(controller: _name, label: "Full Name"),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text("Register")),
          ],
        ),
      ),
    );
  }
}