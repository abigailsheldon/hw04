import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen();
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _db   = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _form = GlobalKey<FormState>();
  String first='', last='', role='';

  @override
  void initState() {
    super.initState();
    _load();
  }
  Future<void> _load() async {
    final u = _auth.currentUser!;
    final doc = await _db.collection('users').doc(u.uid).get();
    setState(() {
      first = doc['firstName'];
      last  = doc['lastName'];
      role  = doc['role'];
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(children: [
            TextFormField(
              initialValue: first,
              decoration: const InputDecoration(labelText: 'First Name'),
              onChanged:(v)=>first=v),
            TextFormField(
              initialValue: last,
              decoration: const InputDecoration(labelText: 'Last Name'),
              onChanged:(v)=>last=v),
            TextFormField(
              initialValue: role,
              decoration: const InputDecoration(labelText: 'Role'),
              onChanged:(v)=>role=v),
            const SizedBox(height:20),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                final u = _auth.currentUser!;
                await _db.collection('users').doc(u.uid)
                  .update({'firstName': first, 'lastName': last, 'role': role});
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Profile updated')));
              },
            )
          ]),
        ),
      ),
    );
  }
}
