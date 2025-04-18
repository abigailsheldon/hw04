// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'register_screen.dart';
import 'board_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authS = AuthService();
  String email='', pwd='';

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(decoration: const InputDecoration(labelText: 'Email'),
            onChanged: (v)=>email=v),
          TextField(decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true, onChanged: (v)=>pwd=v),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Login'),
            onPressed: () async {
              final user = await _authS.login(email, pwd);
              if (user!=null) {
                Navigator.pushReplacement(ctx,
                  MaterialPageRoute(builder: (_) => const BoardListScreen()));
              }
            },
          ),
          TextButton(
            child: const Text('No account? Register'),
            onPressed: () => Navigator.push(ctx,
              MaterialPageRoute(builder: (_) => const RegisterScreen())),
          )
        ]),
      ),
    );
  }
}
