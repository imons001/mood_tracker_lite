import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/mood_log.dart';
import '../controllers/mood_controller.dart';

// Environments
import 'mood_folder/mood_environment.dart';
import 'mood_folder/sadness_environment.dart';
import 'mood_folder/calm_environment.dart';
import 'mood_folder/conflicted_environment.dart';
import 'mood_folder/confused_environment.dart';
import 'mood_folder/detached_environment.dart';
import 'mood_folder/fear_environment.dart';
import 'mood_folder/grateful_environment.dart';
import 'mood_folder/happy_environment.dart';
import 'mood_folder/loving_environment.dart';
import 'mood_folder/melting_environment.dart';
import 'mood_folder/tired_environment.dart';
import 'mood_folder/vulnerable_environment.dart';
import 'mood_folder/content_environment.dart';
import 'mood_folder/stressed_environment.dart';
import 'mood_folder/angry_environment.dart';
import 'mood_folder/lonely_environment.dart';
import 'mood_folder/worried_environment.dart';
import 'mood_folder/overwhelmed_environment.dart';
import 'mood_folder/shocked_environment.dart';
import 'mood_folder/frustrated_environment.dart';
import 'mood_folder/indecisive_environment.dart';
import 'mood_folder/anxious_environment.dart';
import 'mood_folder/disappointed_environment.dart';
import 'mood_folder/bored_environment.dart';
import 'mood_folder/excited_environment.dart';
import 'mood_folder/regretful_environment.dart';
import 'mood_folder/awkward_environment.dart';
import 'mood_folder/curious_environment.dart';
import 'mood_folder/guilt_environment.dart';
import 'mood_folder/sick_environment.dart';
import 'mood_folder/disgusted_environment.dart';
import 'mood_folder/embarrassed_environment.dart';
import 'mood_folder/exhausted_environment.dart';
import 'mood_folder/sleepy_environment.dart';fl

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final ScrollController _scrollController = ScrollController();
  final MoodController _controller = MoodController();
  double _scrollProgress = 0.0;
  List<MoodLog> moodHistory = [];

  final List<String> forestFrames = [
    'assets/images/forest_begin.png',
    'assets/images/forest_11.png',
    'assets/images/forest_12.png',
    'assets/images/forest_13.png',
    'assets/images/forest_14.png',
    'assets/images/forest_15.png',
    'assets/images/forest_16.png',
  ];

  final List<Map<String, String>> moods = [
    {'emoji': '😄', 'label': 'Happy'},
    {'emoji': '🙂', 'label': 'Calm'},
    {'emoji': '😣', 'label': 'Stressed'},
    {'emoji': '😡', 'label': 'Angry'},
    {'emoji': '😭', 'label': 'Sadness'},
    {'emoji': '😴', 'label': 'Tired'},
    {'emoji': '😕', 'label': 'Confused'},
    {'emoji': '😇', 'label': 'Grateful'},
    {'emoji': '😌', 'label': 'Content'},
    {'emoji': '😶', 'label': 'Detached'},
    {'emoji': '😶‍🌫️', 'label': 'Conflicted'},
    {'emoji': '😨', 'label': 'Fear'},
    {'emoji': '🫶', 'label': 'Loving'},
    {'emoji': '🫠', 'label': 'Melting'},
    {'emoji': '🥹', 'label': 'Vulnerable'},
    {'emoji': '😵', 'label': 'Overwhelmed'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '🤒', 'label': 'Sick'},
    {'emoji': '🤢', 'label': 'Disgusted'},
    {'emoji': '😳', 'label': 'Embarrassed'},
    {'emoji': '🫥', 'label': 'Indecisive'},
    {'emoji': '😤', 'label': 'Frustrated'},
    {'emoji': '😒', 'label': 'Disappointed'},
    {'emoji': '😞', 'label': 'Regretful'},
    {'emoji': '😔', 'label': 'Guilty'},
    {'emoji': '😟', 'label': 'Worried'},
    {'emoji': '😢', 'label': 'Lonely'},
    {'emoji': '😖', 'label': 'Anxious'},
    {'emoji': '😩', 'label': 'Exhausted'},
    {'emoji': '🥱', 'label': 'Sleepy'},
    {'emoji': '🤯', 'label': 'Shocked'},
    {'emoji': '🤗', 'label': 'Excited'},
    {'emoji': '🤔', 'label': 'Curious'},
    {'emoji': '🙄', 'label': 'Bored'},
    {'emoji': '😬', 'label': 'Awkward'},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMoods();
  }

  Future<void> _loadMoods() async {
    final logs = await _controller.loadMoodLogs();
    setState(() => moodHistory = logs);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;
    setState(() {
      _scrollProgress = (pos / (maxScroll + 300)).clamp(0.0, 1.0);
    });
  }

  Color getMoodColor(String emoji) {
    switch (emoji) {
      case '😄':
        return Colors.yellow.withOpacity(0.35);
      case '🙂':
        return Colors.tealAccent.withOpacity(0.3);
      case '😣':
        return Colors.orangeAccent.withOpacity(0.35);
      case '😡':
        return Colors.redAccent.withOpacity(0.35);
      case '😭':
        return Colors.indigo.withOpacity(0.35);
      case '😴':
        return Colors.blueGrey.withOpacity(0.35);
      case '😕':
        return Colors.amber.withOpacity(0.35);
      case '😇':
        return Colors.greenAccent.withOpacity(0.35);
      case '😌':
        return Colors.lightBlueAccent.withOpacity(0.35);
      case '😶':
        return Colors.grey.withOpacity(0.35);
      case '😶‍🌫️':
        return Colors.purpleAccent.withOpacity(0.35);
      case '😨':
        return Colors.cyan.withOpacity(0.35);
      case '🫶':
        return Colors.pinkAccent.withOpacity(0.35);
      case '🫠':
        return Colors.deepOrangeAccent.withOpacity(0.35);
      case '🥹':
        return const Color(0xFFBAA6C4).withOpacity(0.35);
      case '😢':
        return const Color.fromARGB(255, 170, 178, 228).withOpacity(0.35);
      case '😟':
        return const Color.fromARGB(255, 252, 190, 108).withOpacity(0.35);
      case '😵':
        return const Color.fromARGB(255, 255, 0, 0).withOpacity(0.35);
      case '🤯':
        return const Color.fromARGB(255, 255, 165, 0).withOpacity(0.35);
      case '😤':
        return const Color.fromARGB(255, 182, 105, 33).withOpacity(0.35);
      case '🫥':
        return const Color.fromARGB(255, 128, 0, 128).withOpacity(0.35);
      case '😖':
        return const Color.fromARGB(255, 255, 0, 255).withOpacity(0.35);
      case '😒':
        return const Color.fromARGB(255, 255, 0, 0).withOpacity(0.35);
      case '🙄':
        return const Color.fromARGB(255, 255, 0, 0).withOpacity(0.35);
      case '🤗':
        return const Color.fromARGB(255, 245, 224, 40).withOpacity(0.35);
      case '😞':
        return const Color.fromARGB(255, 201, 207, 243).withOpacity(0.35);
      case '😬':
        return const Color.fromARGB(255, 192, 235, 94).withOpacity(0.35);
      case '🤔':
        return const Color.fromARGB(255, 201, 207, 243).withOpacity(0.35);
      case '🤒':
        return const Color.fromARGB(255, 163, 236, 169).withOpacity(0.35);
      case '🤢':
        return const Color.fromARGB(255, 27, 97, 45).withOpacity(0.35);
      case '😳':
        return const Color.fromARGB(255, 255, 0, 255).withOpacity(0.35);
      case '😩':
        return const Color.fromARGB(255, 255, 0, 0).withOpacity(0.35);
      case '🥱':
        return const Color.fromARGB(255, 44, 11, 88).withOpacity(0.35);
      default:
        return Colors.white.withOpacity(0.3);
    }
  }

  // helper to choose correct environment
  Widget _getEnvironment(String label, String emoji, [MoodLog? existing]) {
    switch (label.toLowerCase()) {
      case 'sadness':
        return SadnessEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'calm':
        return CalmEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'conflicted':
        return ConflictedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'confused':
        return ConfusedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'detached':
        return DetachedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'fear':
        return FearEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'grateful':
        return GratefulEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'happy':
        return HappyEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'loving':
        return LovingEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'melting':
        return MeltingEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'tired':
        return TiredEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'vulnerable':
        return VulnerableEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'content':
        return ContentEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'stressed':
        return StressedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'angry':
        return AngryEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'lonely':
        return LonelyEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'worried':
        return WorriedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'overwhelmed':
        return OverwhelmedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'shocked':
        return ShockedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'frustrated':
        return FrustratedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'indecisive':
        return IndecisiveEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'anxious':
        return AnxiousEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'disappointed':
        return DisappointedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'bored':
        return BoredEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'excited':
        return ExcitedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'regretful':
        return RegretfulEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'awkward':
        return AwkwardEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'curious':
        return CuriousEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'guilty':
        return GuiltEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'sick':
        return SickEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'disgusted':
        return DisgustedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'embarrassed':
        return EmbarrassedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'exhausted':
        return ExhaustedEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      case 'sleepy':
        return SleepyEnvironment(
            emoji: emoji, label: label, existingLog: existing);
      default:
        return MoodEnvironment(
            emoji: emoji, label: label, existingLog: existing);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    final frameIndex = (_scrollProgress * (forestFrames.length - 1)).floor();
    final nextIndex = (frameIndex + 1).clamp(0, forestFrames.length - 1);
    final opacity = (_scrollProgress * (forestFrames.length - 1)) % 1.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Mood Tracker",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // background forest scroll
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(forestFrames[frameIndex], fit: BoxFit.cover),
                AnimatedOpacity(
                  opacity: 0.8 * opacity,
                  duration: const Duration(milliseconds: 800),
                  child:
                      Image.asset(forestFrames[nextIndex], fit: BoxFit.cover),
                ),
              ],
            ),
          ),

          // overlay gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.65),
                  ],
                ),
              ),
            ),
          ),

          // foreground
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 100, bottom: 80),
            children: [
              // title
              Column(
                children: [
                  const Text(
                    "How are you feeling today?",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    now,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // past moods
              if (moodHistory.isNotEmpty)
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.8),
                    itemCount: moodHistory.length,
                    itemBuilder: (context, index) {
                      final mood = moodHistory.reversed.toList()[index];
                      final color = getMoodColor(mood.emoji);
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => _getEnvironment(
                                mood.label,
                                mood.emoji,
                                mood,
                              ),
                            ),
                          );
                          await _loadMoods();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white30),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(mood.emoji,
                                  style: const TextStyle(fontSize: 44)),
                              const SizedBox(height: 8),
                              Text(
                                mood.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM d, h:mm a')
                                    .format(mood.dateTime),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                const Center(
                  child: Text(
                    "No moods logged yet 🌱",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ),

              const SizedBox(height: 30),

              // mood grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: moods.length,
                  itemBuilder: (context, index) {
                    final mood = moods[index];
                    return GestureDetector(
                      onTap: () async {
                        final emoji = mood['emoji']!;
                        final label = mood['label']!;
                        final newLog = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => _getEnvironment(label, emoji),
                          ),
                        );
                        if (newLog != null && mounted) {
                          await _controller.addLog(newLog);
                          await _loadMoods();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(mood['emoji']!,
                                style: const TextStyle(fontSize: 28)),
                            const SizedBox(height: 6),
                            Text(
                              mood['label']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
