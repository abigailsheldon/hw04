import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen();
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _auth        = FirebaseAuth.instance;
  final _emailKey    = GlobalKey<FormState>();
  final _passKey     = GlobalKey<FormState>();
  String _newEmail   = '';
  String _newPassword= '';

  Future<void> _updateEmail() async {
    if (!_emailKey.currentState!.validate()) return;
    try {
      await _auth.currentUser!.verifyBeforeUpdateEmail(_newEmail);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email update initiated. Please verify your new address.'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email update failed: $e'))
      );
    }
  }

  Future<void> _updatePassword() async {
    if (!_passKey.currentState!.validate()) return;
    try {
      await _auth.currentUser!.updatePassword(_newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password update failed: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext ctx) {
    final user = _auth.currentUser!;
    final textTheme = Theme.of(ctx).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            // Change Email
            Text(
              'Change Email',
              style: textTheme.titleMedium,
            ),
            Form(
              key: _emailKey,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    initialValue: user.email,
                    decoration: const InputDecoration(labelText: 'New Email'),
                    validator: (v) => v!=null && v.contains('@')
                      ? null
                      : 'Enter valid email',
                    onChanged: (v) => _newEmail = v,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _updateEmail,
                ),
              ]),
            ),

            const SizedBox(height: 24),

            // Change Password
            Text(
              'Change Password',
              style: textTheme.titleMedium, 
            ),
            Form(
              key: _passKey,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'New Password'),
                    validator: (v) => v!=null && v.length>=6
                      ? null
                      : 'Min 6 chars',
                    onChanged: (v) => _newPassword = v,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _updatePassword,
                ),
              ]),
            ),

            const SizedBox(height: 24),

            // Logout
            ElevatedButton.icon(
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () async {
                await _auth.signOut();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  ctx, '/login', (r) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
