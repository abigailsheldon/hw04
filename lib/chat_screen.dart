import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String boardName;
  const ChatScreen({required this.boardName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _db   = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    // Reference the sub‑collection for this board, ordered newest first
    final coll = _db
      .collection('boards')
      .doc(widget.boardName)
      .collection('messages')
      .orderBy('sentAt', descending: true);

    return Scaffold(
      appBar: AppBar(title: Text(widget.boardName)),
      body: Column(children: [
        // Message list
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: coll.snapshots(),
            builder: (ctx, snap) {
              if (!snap.hasData) 
                return const Center(child: CircularProgressIndicator());

              final docs = snap.data!.docs;
              return ListView.builder(
                reverse: true,
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final d  = docs[i];
                  final txt = d['text'];
                  final user= d['senderName'];
                  final dt  = (d['sentAt'] as Timestamp).toDate();

                  return ListTile(
                    title: Text(user),        // Sender’s name
                    subtitle: Text(txt),      // Message text
                    trailing: Text(           // HH:MM timestamp
                      '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}',
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Input bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:8),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                decoration: const InputDecoration(hintText: 'Type a message'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                final u = _auth.currentUser!;
                
                final prof = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(u.uid)
                  .get();
                final senderName = '${prof['firstName']} ${prof['lastName']}';

                // Add new message doc
                await coll.add({
                  'text': _ctrl.text,
                  'sentAt': FieldValue.serverTimestamp(),
                  'senderName': senderName,
                });

                _ctrl.clear();
              },
            ),
          ]),
        ),
      ]),
    );
  }
}
