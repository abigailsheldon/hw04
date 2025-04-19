import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen();
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _db      = FirebaseFirestore.instance;
  final _auth    = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String _first = '', _last = '', _role = '';
  DateTime? _dob;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = _auth.currentUser!.uid;
    final doc = await _db.collection('users').doc(uid).get();

    setState(() {
      _first = doc.data()?['firstName'] ?? '';
      _last  = doc.data()?['lastName']  ?? '';
      _role  = doc.data()?['role']      ?? '';
      if (doc.data()?.containsKey('dob') ?? false) {
        _dob = (doc['dob'] as Timestamp).toDate();
      }
    });
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  @override
  Widget build(BuildContext ctx) {
    final dobText = _dob == null
      ? 'Tap to select your DOB'
      : DateFormat.yMMMd().format(_dob!);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [

            TextFormField(
              initialValue: _first,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (v) => v != null && v.isNotEmpty ? null : 'Required',
              onChanged: (v) => _first = v,
            ),

            const SizedBox(height: 12),

            TextFormField(
              initialValue: _last,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (v) => v != null && v.isNotEmpty ? null : 'Required',
              onChanged: (v) => _last = v,
            ),

            const SizedBox(height: 12),

            TextFormField(
              initialValue: _role,
              decoration: const InputDecoration(labelText: 'Role'),
              onChanged: (v) => _role = v,
            ),

            const SizedBox(height: 20),

            ListTile(
              title: const Text('Date of Birth'),
              subtitle: Text(dobText),
              trailing: const Icon(Icons.calendar_month),
              onTap: _pickDob,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              child: const Text('Save Profile'),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                final uid = _auth.currentUser!.uid;

                final Map<String, dynamic> data = {
                  'firstName': _first,
                  'lastName':  _last,
                  'role':      _role,
                };

                if (_dob != null) {
                  data['dob'] = Timestamp.fromDate(_dob!);
                }

                // Use set with merge so that doc is created if missing
                await _db
                  .collection('users')
                  .doc(uid)
                  .set(data, SetOptions(merge: true));

                if (!mounted) return;
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Profile updated')),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
