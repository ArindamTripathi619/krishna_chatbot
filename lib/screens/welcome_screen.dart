import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<bool> _isOffline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return true;
    }
    // Try to lookup google.com to check for real internet access
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (_) {
      return true;
    }
  }

  void _showOfflineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF181C22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: const BorderSide(color: Color(0xFF00C9A7), width: 2),
            ),
            title: Row(
              children: [
                Image.asset('assets/flute.webp', height: 36),
                const SizedBox(width: 14),
                Text(
                  "O Wanderer!",
                  style: GoogleFonts.yatraOne(
                    color: Colors.tealAccent.shade100,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.tealAccent.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF232946), Color(0xFF00C9A7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.tealAccent.withOpacity(0.08),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    "Even the swiftest chariot cannot cross the desert of disconnection, dear one.",
                    style: GoogleFonts.greatVibes(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 6,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Text(
                  "Please restore your connection to continue your journey with Krishna.",
                  style: GoogleFonts.caveat(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  "Reflect & Retry",
                  style: GoogleFonts.poppins(
                    color: Colors.tealAccent.shade100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  Future<void> _handleAuthNavigation(
    BuildContext context,
    Widget screen,
  ) async {
    if (await _isOffline()) {
      _showOfflineDialog(context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0C10), Color(0xFF181C22)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _AnimatedGlowFlute(),
                const SizedBox(height: 24),
                Text(
                  "Welcome to Chat with Krishna",
                  style: GoogleFonts.yatraOne(
                    fontSize: 28,
                    color: Colors.tealAccent.shade100,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Connect your heart with Krishna's wisdom.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 8,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.person_add_alt_1),
                          label: const Text("Sign Up"),
                          onPressed:
                              () => _handleAuthNavigation(
                                context,
                                const RegisterScreen(),
                              ),
                        ),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          icon: const Icon(Icons.login),
                          label: const Text("Already have an account? Log In"),
                          onPressed:
                              () => _handleAuthNavigation(
                                context,
                                const LoginScreen(),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedGlowFlute extends StatefulWidget {
  @override
  State<_AnimatedGlowFlute> createState() => _AnimatedGlowFluteState();
}

class _AnimatedGlowFluteState extends State<_AnimatedGlowFlute>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.18,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: _scale.value,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.18),
                      blurRadius: 32,
                      spreadRadius: 8,
                    ),
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.14),
                      blurRadius: 48,
                      spreadRadius: 16,
                    ),
                    BoxShadow(
                      color: Colors.amberAccent.withOpacity(0.12),
                      blurRadius: 64,
                      spreadRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: ClipOval(
                child: Image.asset('assets/flute.webp', fit: BoxFit.contain),
              ),
            ),
          ],
        );
      },
    );
  }
}
