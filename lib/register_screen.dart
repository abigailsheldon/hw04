import 'package:flutter/material.dart';
import 'authentication.dart';
import 'board_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen();
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authS   = AuthService();

  String first='', last='', role='', email='', pwd='';

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onChanged: (v) => first = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onChanged: (v) => last = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Role'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                onChanged: (v) => role = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v!=null && v.contains('@') ? null : 'Enter valid email',
                onChanged: (v) => email = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v!=null && v.length>=6 ? null : 'Min 6 chars',
                onChanged: (v) => pwd = v,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                child: const Text('Register'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  try {
                    print(' registering $email');
                    final user = await _authS.register(email, pwd, first, last, role);
                    print(' got user: $user');
                    if (user != null) {
                      Navigator.pushReplacement(ctx,
                        MaterialPageRoute(builder: (_) => const BoardListScreen()));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text('Registration failed: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
