import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String boardName;
  const ChatScreen({required this.boardName});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}