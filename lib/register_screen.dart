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
  
  }

}