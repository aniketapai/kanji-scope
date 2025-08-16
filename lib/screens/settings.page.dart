import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/google_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("S E T T I N G S", style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.black54,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Profile Image
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.black54,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage("assets/default_avatar.png")
                        as ImageProvider,
            ),
            const SizedBox(height: 12),
            // Name
            Text(
              user?.displayName ?? "Guest User",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              user?.email ?? "",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await FirebaseServices().googleSignOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Colors.grey, thickness: 1),
            const SizedBox(height: 16),

            // Collections
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box('collections').listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text('No collections yet'));
                  }
                  return ListView(
                    children: [
                      ExpansionTile(
                        title: const Text(
                          "My Collections",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: box.values.map<Widget>((item) {
                          final data = Map<String, dynamic>.from(item);
                          return ListTile(
                            title: Text(
                              data['kanji'] ?? '',
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Text(
                              (data['meanings'] as List?)?.join(', ') ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                final key = box.keyAt(
                                  box.values.toList().indexOf(item),
                                );
                                box.delete(key);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
