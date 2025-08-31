import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_artisan_screen.dart';
import 'register_consumer_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _navigate(BuildContext context, String role, bool isRegister) {
    if (isRegister) {
      if (role == "artisan") {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const RegisterArtisanScreen()));
      } else if (role == "consumer") {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const RegisterConsumerScreen()));
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(role: role),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Role")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Who are you?", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            _roleButtons(context, "Artisan"),
            _roleButtons(context, "Consumer"),
            _roleButtons(context, "Admin", loginOnly: true),
          ],
        ),
      ),
    );
  }

  Widget _roleButtons(BuildContext context, String role, {bool loginOnly = false}) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _navigate(context, role.toLowerCase(), false),
          child: Text("Login as $role"),
        ),
        if (!loginOnly)
          TextButton(
            onPressed: () => _navigate(context, role.toLowerCase(), true),
            child: Text("Register as $role"),
          ),
        const SizedBox(height: 15),
      ],
    );
  }
}