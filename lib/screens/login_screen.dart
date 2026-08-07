import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = TextEditingController();
  final _storage = StorageService();

  void _login() async {
    if (_controller.text.trim().isEmpty) return;
    await _storage.saveUsername(_controller.text.trim());
    if(mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding( // <-- Wrap with Padding instead
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'PoultryNow',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controller, 
                decoration: const InputDecoration(
                  labelText: 'Enter Username', 
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login, 
                child: const Text('Login')
              )
            ],
          ),
        ),
      ),
    );
  }
}
