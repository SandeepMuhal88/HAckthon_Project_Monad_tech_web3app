import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _login(BuildContext context) {
    // Wallet login mocked for MVP
    Navigator.pushReplacementNamed(context, AppRoutes.events);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, size: 80),
              const SizedBox(height: 16),
              const Text(
                'Proof of Culture',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _login(context),
                child: const Text('Connect Wallet'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
