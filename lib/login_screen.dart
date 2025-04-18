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
  
  }
}