// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen();
  final _authS = AuthService();

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Log out'),
          onPressed: () async {
            await _authS.logout();
            Navigator.pushAndRemoveUntil(ctx,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (_) => false);
          },
        ),
      ),
    );
  }
}
