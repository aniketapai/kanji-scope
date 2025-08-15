import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/services/convex_bottom_bar.dart';
import 'package:kanji_app/screens/google_login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.white,)),
          );
        }
        // User is logged in
        if (snapshot.hasData) {
          return const ConvexBottomBar(); // Go to app's main screen
        }
        // User is not logged in
        return const GoogleLoginPage();
      },
    );
  }
}
