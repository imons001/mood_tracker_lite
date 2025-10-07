// mood_page.dart
// Main screen showing mood options, logs carousel, and navigation to environments.

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:intl/intl.dart';
import 'dart:ui';
import '../controllers/mood_controller.dart';
import '../models/mood_log.dart';
import '../views/mood_environment.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final MoodController moodController = MoodController();

  String? selectedMood;
  String formattedDate = '';
  List<MoodLog> moodLogs = [];

  // Mood options for selection buttons
  final moods = {
    '😄': 'Happy',
    '🙂': 'Calm',
    '😐': 'Neutral',
    '😣': 'Stressed',
    '😭': 'Sad',
    '🤩': 'Excited',
  };

  @override
  void initState() {
    super.initState();
    formattedDate = moodController.getFormattedDate(); // Get today's date
    _loadData(); // Load stored mood and logs
  }

  // Load last mood and all stored logs
  Future<void> _loadData() async {
    final lastMood = await moodController.loadLastMood();
    final logs = await moodController.loadMoodLogs(); // Returns List<MoodLog>
    setState(() {
      selectedMood = lastMood;
      moodLogs = logs.reversed.toList(); // Display newest entries first
    });
  }

  // Return a color tint based on the selected mood
  Color getMoodTint(String mood) {
    switch (mood) {
      case '😄':
        return Colors.yellowAccent.withOpacity(0.4);
      case '🙂':
        return Colors.lightBlueAccent.withOpacity(0.4);
      case '😐':
        return Colors.grey.withOpacity(0.3);
      case '😣':
        return Colors.orangeAccent.withOpacity(0.4);
      case '😭':
        return Colors.indigo.withOpacity(0.4);
      case '🤩':
        return Colors.pinkAccent.withOpacity(0.4);
      default:
        return Colors.white.withOpacity(0.2);
    }
  }

  // Create and save a new mood log
  Future<void> _selectMood(String emoji, String label) async {
    final newLog = await Navigator.push<MoodLog>(
      context,
      MaterialPageRoute(
        builder: (context) => MoodEnvironment(
          emoji: emoji,
          label: label,
        ),
      ),
    );

    // When the user returns from the environment page with a log
    if (newLog != null && mounted) {
      await moodController.addLog(newLog);
      _loadData(); // Refresh carousel
    }
  }

  // Revisit and open an existing mood log
  void _openLog(MoodLog log) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoodEnvironment(
          emoji: log.emoji,
          label: log.label,
          existingLog: log,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moodTint =
        selectedMood != null ? getMoodTint(selectedMood!) : Colors.transparent;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('assets/images/forestneutral.png', fit: BoxFit.cover),

          // Overlay color tint for selected mood
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            color: moodTint,
          ),

          // Optional blur for soft moods
          if (selectedMood == '🙂' || selectedMood == '😭')
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.transparent),
            ),

          // Main UI
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Mood Tracker Lite',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Display current mood
                    Text(
                      selectedMood == null
                          ? 'How are you feeling today?'
                          : 'You are feeling ${moods[selectedMood]!} ${selectedMood!}',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    // Display current date
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    // Emotion log carousel
                    if (moodLogs.isNotEmpty) ...[
                      const SizedBox(height: 30),
                      const Text(
                        'Emotion Log',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      slider.CarouselSlider(
                        options: slider.CarouselOptions(
                          height: 180,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.75,
                        ),
                        items: moodLogs.map((log) {
                          final tint = getMoodTint(log.emoji);
                          return GestureDetector(
                            onTap: () => _openLog(log),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white38),
                                image: DecorationImage(
                                  image: const AssetImage(
                                      'assets/images/forestneutral.png'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    tint,
                                    BlendMode.srcATop,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      log.emoji,
                                      style: const TextStyle(
                                          fontSize: 44, color: Colors.white),
                                    ),
                                    Text(
                                      moods[log.emoji] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MMM d, h:mm a')
                                          .format(log.dateTime),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 40),

                    // Mood selection buttons
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: moods.entries.map((entry) {
                        final emoji = entry.key;
                        final label = entry.value;
                        return GestureDetector(
                          onTap: () => _selectMood(emoji, label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selectedMood == emoji
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white54),
                            ),
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 36),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
