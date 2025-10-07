import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../services/openai_service.dart';
import '../models/mood_log.dart'; // make sure this import exists!

class MoodEnvironment extends StatefulWidget {
  final String emoji;
  final String label;
  final MoodLog? existingLog; // might be null and that’s OKAY

  const MoodEnvironment({
    super.key,
    required this.emoji,
    required this.label,
    this.existingLog,
  });

  @override
  State<MoodEnvironment> createState() => _MoodEnvironmentState();
}

class _MoodEnvironmentState extends State<MoodEnvironment> {
  final TextEditingController _journalController = TextEditingController();
  final openAI = OpenAIService();

  String? aiResponse;
  bool isLoading = false;

  bool get isRevisit => widget.existingLog != null;

  @override
  void initState() {
    super.initState();
    // if revisiting, preload the old journal text
    if (isRevisit) {
      _journalController.text = widget.existingLog!.entryText;
    }
  }

  // Get AI feedback for the user's journal entry
  Future<void> _getAIReflection() async {
    setState(() => isLoading = true);

    final feedback = await openAI.getMoodFeedback(
      mood: widget.label, // was selectedMood
      journalText: _journalController.text,
    );

    setState(() {
      aiResponse = feedback;
      isLoading = false;
    });
  }

  // Color tint based on emoji
  Color getMoodColor() {
    switch (widget.emoji) {
      case '😄':
        return const Color.fromARGB(255, 7, 7, 7).withOpacity(0.4);
      case '🙂':
        return const Color.fromARGB(255, 238, 224, 161).withOpacity(0.4);
      case '😐':
        return Colors.grey.withOpacity(0.3);
      case '😣':
        return Colors.orangeAccent.withOpacity(0.4);
      case '😭':
        return Colors.indigo.withOpacity(0.4);
      case '🤩':
        return Colors.pinkAccent.withOpacity(0.4);
      default:
        return Colors.white.withOpacity(0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateFormat('EEE, MMM d – h:mm a').format(DateTime.now());
    final moodColor = getMoodColor();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: Text(
          '${widget.label} Mood',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // background
          Image.asset('assets/images/forestneutral.png', fit: BoxFit.cover),

          // mood overlay
          Container(color: moodColor),

          // blur effect for soft moods
          if (widget.emoji == '🙂' || widget.emoji == '😭')
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.transparent),
            ),

          // journal + reflection UI
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'You are feeling ${widget.label} ${widget.emoji}\n$now',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _journalController,
                    enabled: !isRevisit, // read-only if revisiting
                    style: const TextStyle(color: Colors.white),
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: isRevisit
                          ? 'Your previous reflection'
                          : 'Write your thoughts here...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black45,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!isRevisit)
                    ElevatedButton.icon(
                      onPressed: _getAIReflection,
                      icon: const Icon(Icons.spa),
                      label: const Text('Reflect with AI ✨'),
                    ),
                  const SizedBox(height: 20),
                  if (isLoading)
                    const CircularProgressIndicator(color: Colors.white)
                  else if (aiResponse != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        aiResponse!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (!isRevisit)
                    ElevatedButton.icon(
                      onPressed: () {
                        final newLog = MoodLog(
                          emoji: widget.emoji,
                          label: widget.label,
                          dateTime: DateTime.now(),
                          entryText: _journalController.text,
                        );
                        Navigator.pop(
                            context, newLog); // Return MoodLog to MoodPage
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save Mood Entry'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
