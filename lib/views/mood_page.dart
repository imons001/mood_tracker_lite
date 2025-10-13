import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mood_log.dart';
import '../controllers/mood_controller.dart';
import 'mood_environment.dart';

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
    'assets/images/forest_17.png',
  ];

  final List<Map<String, String>> moods = [
    {'emoji': '😄', 'label': 'Happy'},
    {'emoji': '🙂', 'label': 'Calm'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '😣', 'label': 'Stressed'},
    {'emoji': '😭', 'label': 'Sad'},
    {'emoji': '🤩', 'label': 'Excited'},
    {'emoji': '😡', 'label': 'Angry'},
    {'emoji': '😴', 'label': 'Tired'},
    {'emoji': '😕', 'label': 'Confused'},
    {'emoji': '😇', 'label': 'Grateful'},
    {'emoji': '😌', 'label': 'Content'},
    {'emoji': '🤔', 'label': 'Thoughtful'},
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
      case '😄': // Happy
        return Colors.yellow.withOpacity(0.35);
      case '😌': // Calm
        return Colors.tealAccent.withOpacity(0.3);
      case '😐': // Neutral
        return Colors.grey.withOpacity(0.3);
      case '😣': // Stressed
        return Colors.orangeAccent.withOpacity(0.35);
      case '😭': // Sad
        return Colors.indigo.withOpacity(0.35);
      case '🤩': // Excited
        return Colors.pinkAccent.withOpacity(0.35);
      case '😡': // Angry
        return Colors.redAccent.withOpacity(0.35);
      case '😴': // Tired
        return Colors.blueGrey.withOpacity(0.35);
      case '😕': // Confused
        return Colors.amber.withOpacity(0.35);
      case '😊': // Grateful
        return Colors.greenAccent.withOpacity(0.35);
      case '🤔': // Thoughtful
        return Colors.purpleAccent.withOpacity(0.35);
      default:
        return Colors.white.withOpacity(0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    // forest fade logic
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
      ),
      body: Stack(
        children: [
          //scrolling forest background
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 800),
                    child: Image.asset(
                      forestFrames[frameIndex],
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: 0.8 * opacity,
                    duration: const Duration(milliseconds: 800),
                    child: Image.asset(
                      forestFrames[nextIndex],
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🌫 Overlay gradient
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

          // 🌼 Foreground content
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 100, bottom: 80),
            children: [
              Center(
                child: Column(
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
              ),

              const SizedBox(height: 30),

              // Mood carousel (smaller height)
              if (moodHistory.isNotEmpty)
                Center(
                  child: SizedBox(
                    height: 180, // smaller carousel
                    child: PageView.builder(
                      controller:
                          PageController(viewportFraction: 0.8, initialPage: 0),
                      itemCount: moodHistory.length,
                      itemBuilder: (context, index) {
                        final mood = moodHistory.reversed.toList()[index];
                        final color = getMoodColor(mood.emoji);
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoodEnvironment(
                                  emoji: mood.emoji,
                                  label: mood.label,
                                  existingLog: mood,
                                ),
                              ),
                            );
                            await _loadMoods();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white30),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: -2,
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
                  ),
                )
              else
                const Center(
                  child: Text(
                    "No moods logged yet 🌱",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ),

              const SizedBox(height: 30), // closer spacing than before

              // Smaller mood picker closer to carousel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // #of items across
                    mainAxisSpacing: 10, // closer spacing
                    crossAxisSpacing: 10.0, // horizontal spacing
                    childAspectRatio: 1, // square items
                  ),
                  itemCount: moods.length, // total mood options
                  itemBuilder: (context, index) {
                    // build each mood item
                    final mood = moods[index]; // get mood data
                    return GestureDetector(
                      // handle taps
                      onTap: () async {
                        // open mood environment
                        final newLog = await Navigator.push(
                          // open mood environment
                          context, // navigate to mood environment
                          MaterialPageRoute(
                            // create route
                            builder: (context) => MoodEnvironment(
                              // pass selected mood
                              emoji: mood['emoji']!, // pass emoji
                              label: mood['label']!, // pass label
                            ),
                          ),
                        );

                        if (newLog != null && mounted) {
                          await _controller.addLog(newLog);
                          await _loadMoods();
                        }
                      },
                      // mood item UI
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.12), // semi-transparent background
                          borderRadius:
                              BorderRadius.circular(16), // rounded corners
                          border:
                              Border.all(color: Colors.white24), // border color
                        ),
                        child: Center(
                          // center emoji
                          child: Text(
                            // display emoji
                            mood['emoji']!,
                            style: const TextStyle(fontSize: 20),
                          ),
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
