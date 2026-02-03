import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login_page.dart';
import 'views/mood_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes/routes.dart';

Future<void> main() async {
  //begin flutter
  WidgetsFlutterBinding.ensureInitialized(); //start flutter engine
  await dotenv.load(fileName: ".env"); //loads .env file
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCQm7cMLsBrfdSrasrsQ3pvsazQQLi8o3I",
      authDomain: "moodtrackerlite-4fcb3.firebaseapp.com",
      projectId: "moodtrackerlite-4fcb3",
      storageBucket: "moodtrackerlite-4fcb3.firebasestorage.com",
      messagingSenderId: "155739832311",
      appId: "1:155739832311:web:e1d83f9e8ae2c937b338f2",
    ),
  ); // Initialize Firebase
  runApp(const MoodTrackerApp()); //launches widget tree
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    //title, theme and launches home:
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //route add all pages
      routes: Routes.routes,
      title: 'Mood Tracker Lite',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: const LoginPage(), // changes page to launch
    );
  }
}

/// Auto-login logic
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          // user already logged in
          return const MoodPage();
        } else {
          // no user logged in
          return const LoginPage();
        }
      },
    );
  }
}
