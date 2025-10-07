// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/mood_page.dart';

Future<void> main() async {
  //begin flutter
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); //loads .env file
  runApp(const MoodTrackerApp()); //launches widget tree
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    //title, theme and launches home:
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Tracker Lite',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: const MoodPage(), // ✅ launches main mood page
    );
  }
}
