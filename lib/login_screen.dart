import 'package:flutter/material.dart';
import 'authentication.dart';
import 'board_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen();
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _authS = AuthService();
  final _form  = GlobalKey<FormState>();
  String email='', pwd='', first='', last='', role='user';

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(children: [
            TextFormField(decoration: const InputDecoration(labelText: 'First Name'),
              onChanged: (v)=>first=v),
            TextFormField(decoration: const InputDecoration(labelText: 'Last Name'),
              onChanged: (v)=>last=v),
            TextFormField(decoration: const InputDecoration(labelText: 'Role'),
              onChanged: (v)=>role=v),
            TextFormField(decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (v)=>email=v),
            TextFormField(decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true, onChanged: (v)=>pwd=v),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Register'),
              onPressed: () async {
                if (_form.currentState!.validate()) {
                  final user = await _authS.register(email, pwd, first, last, role);
                  if (user!=null) {
                    Navigator.pushReplacement(ctx,
                      MaterialPageRoute(builder: (_) => const BoardListScreen()));
                  }
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
