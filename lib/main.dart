import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme.dart';

import 'screens/welcome_screen.dart';
import 'screens/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(const KrishnaChatApp());
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0B0C10), // Solid dark navy
      body: SizedBox.expand(),
    );
  }
}

class KrishnaChatApp extends StatelessWidget {
  const KrishnaChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat with Krishna',
      theme: krishnaDarkTheme, // <-- use your global theme
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); // Use the solid color splash screen
          }
          if (snapshot.hasData) {
            return const KrishnaChatPage();
          }
          return const WelcomeScreen();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
