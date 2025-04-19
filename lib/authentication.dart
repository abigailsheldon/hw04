import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db   = FirebaseFirestore.instance;

  // Register a new user
  Future<User?> register(String email, String pwd, String first,
                         String last,  String role) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email, password: pwd,
    );
    final uid = cred.user!.uid;
    await _db.collection('users').doc(uid).set({
      'firstName':   first,
      'lastName':    last,
      'role':        role,
      'registeredAt': FieldValue.serverTimestamp(),
    });
    return cred.user;
  }

  // Sign in an existing user
  Future<User?> login(String email, String pwd) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email, password: pwd,
    );
    return cred.user;
  }

  // Sign out the current user
  Future<void> logout() async {
    await _auth.signOut();
  }
}
