import 'package:flutter/material.dart';
import 'google_auth.dart';

class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({super.key});

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  bool isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => isLoading = true);

    bool success = await FirebaseServices().signInWithGoogle();

    setState(() => isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Google sign-in failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
                child: const Icon(
                  Icons.translate,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),

              // App name
              const Text(
                "KanjiScope",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              Text(
                "Master kanji effortlessly.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 60),

              // Divider + text
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey.shade700, thickness: 1),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Sign in with Google",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.shade700, thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Google Sign-in button
              InkWell(
                onTap: isLoading ? null : _handleGoogleSignIn,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 64,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/google.jpg", height: 28),
                              const SizedBox(width: 12),
                              const Text(
                                "Continue with Google",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 80),

              // Footer
              Text(
                "By continuing, you agree to our Terms & Privacy Policy.",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
