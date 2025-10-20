import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/mood_log.dart';
import '../controllers/mood_controller.dart';

// helpers
import '../helpers/mood_colors.dart';
import '../helpers/mood_data.dart';
import '../helpers/environment_map.dart';

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

  // forest background frames
  final List<String> forestFrames = [
    'assets/images/forest_begin.png',
    'assets/images/forest_11.png',
    'assets/images/forest_12.png',
    'assets/images/forest_13.png',
    'assets/images/forest_14.png',
    'assets/images/forest_15.png',
    'assets/images/forest_16.png',
  ];
  // load moods on init
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMoods();
  }

// dispose scroll controller
  Future<void> _loadMoods() async {
    final logs = await _controller.loadMoodLogs();
    setState(() => moodHistory = logs);
  }

// update scroll progress
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;
    setState(() {
      _scrollProgress = (pos / (maxScroll + 300)).clamp(0.0, 1.0);
    });
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

          // main foreground content
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 100, bottom: 80),
            children: [
              // title and date
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

              // past moods carousel
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
                              builder: (context) => getEnvironmentWidget(
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
                            color: color.withOpacity(0.35),
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

              // mood grid selector
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
                            builder: (context) =>
                                getEnvironmentWidget(label, emoji),
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
