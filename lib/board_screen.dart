import 'package:flutter/material.dart';
import 'authentication.dart';
import '/chat_screen.dart';
import '/profile_screen.dart';
import '/settings_screen.dart';

class BoardListScreen extends StatelessWidget {
  const BoardListScreen();
  final _boards = const [
    {'name':'General','icon':Icons.chat},
    {'name':'Sports','icon':Icons.sports_soccer},
    {'name':'Music','icon':Icons.music_note},
    {'name':'Tech','icon':Icons.computer},
  ];

  @override
  Widget build(BuildContext ctx) {

  }

}