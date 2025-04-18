import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;

  Future<User?> register(String email, String pwd, String first, String last, String role) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: pwd);
    final uid = cred.user!.uid;
    await _db.collection('users').doc(uid).set({
      'firstName': first,
      'lastName': last,
      'role': role,
      'registeredAt': FieldValue.serverTimestamp(),
    });
    return cred.user;
  }

  Future<User?> login(String email, String pwd) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: pwd);
    return cred.user;
  }

  Future<void> logout() => _auth.signOut();

}