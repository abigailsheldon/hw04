import 'package:flutter/material.dart';
import 'authentication.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class BoardListScreen extends StatelessWidget {
  const BoardListScreen();

  // Hard-coded for now
  final _boards = const [
    {'name':'General','icon':Icons.chat},
    {'name':'Sports','icon':Icons.sports_soccer},
    {'name':'Music','icon':Icons.music_note},
    {'name':'Tech','icon':Icons.computer},
  ];

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Message Boards')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            
            // Board page
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Message Boards'),
              onTap: ()=>Navigator.pop(ctx),
            ),
            
            // Profile
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: ()=>Navigator.push(ctx,
                MaterialPageRoute(builder: (_) => const ProfileScreen())),
            ),
            
            // Settings
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: ()=>Navigator.push(ctx,
                MaterialPageRoute(builder: (_) => SettingsScreen())),
            ),
          ],
        ),
      ),
      
      // Show each board in a list view
      body: ListView.builder(
        itemCount: _boards.length,
        itemBuilder: (_, i) {
          final b = _boards[i];
          return ListTile(
            leading: Icon(b['icon'] as IconData),
            title: Text(b['name'] as String),
            onTap: () => Navigator.push(ctx,
              MaterialPageRoute(builder: (_) =>
                ChatScreen(boardName: b['name'] as String))),
          );
        },
      ),
    );
  }
}
