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

  // Keep a CollectionReference for writes (adding messages)
  late final CollectionReference _messagesRef;

  @override
  void initState() {
    super.initState();
    // Point at the messages subcollection for this board
    _messagesRef = _db
      .collection('boards')
      .doc(widget.boardName)
      .collection('messages');
  }

  @override
  Widget build(BuildContext ctx) {
    // Create a Query on that collection for ordering / reading
    final Query orderedMessages = _messagesRef
      .orderBy('sentAt', descending: true);

    return Scaffold(
      appBar: AppBar(title: Text(widget.boardName)),
      body: Column(children: [

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: orderedMessages.snapshots(),
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
                    title: Text(user),
                    subtitle: Text(txt),
                    trailing: Text(
                      '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}',
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Input and send
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                
                // Fetch display name
                final prof = await _db.collection('users').doc(u.uid).get();
                final senderName = '${prof['firstName']} ${prof['lastName']}';

                // Use the CollectionReference to add a new message
                await _messagesRef.add({
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
